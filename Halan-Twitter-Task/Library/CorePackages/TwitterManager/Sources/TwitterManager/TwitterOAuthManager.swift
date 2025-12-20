//
//  TwitterOAuthManager.swift
//  TwitterManager
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Foundation
import Factory
import AuthenticationServices
import CoreStorage

public class TwitterOAuthManager: NSObject {
    @Injected(\.pkceGenerator) private var pkceGenerator
    @Injected(\.oauthURLBuilder) private var urlBuilder
    @Injected(\.tokenExchanger) private var tokenExchanger
    @Injected(\.presentationContextProvider) private var presentationContextProvider

    // MARK: - Properties
    private let clientId: String
    private let clientSecret: String
    private let redirectURI: String
    private var codeVerifier: String?
    private var authenticationContinuation: CheckedContinuation<Void, Error>?
    private let userDefaults: UserDefaults
    
    // MARK: - Initialization
    
    public init(
        clientId: String,
        clientSecret: String,
        redirectURI: String,
        userDefaults: UserDefaults = .standard
    ) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
        self.userDefaults = userDefaults
    }
    
    // MARK: - Public Methods
    
    /// Initiates OAuth 2.0 authentication flow
    /// Saves tokens to DefaultsStorage automatically
    /// - Throws: TwitterOAuthError if authentication fails
    public func authenticate() async throws {
        let verifier = pkceGenerator.generateCodeVerifier()
        guard !verifier.isEmpty else {
            throw TwitterOAuthError.codeVerifierGenerationFailed
        }
        
        codeVerifier = verifier
        let codeChallenge = pkceGenerator.generateCodeChallenge(from: verifier)
        let state = UUID().uuidString
        
        guard let authURL = urlBuilder.buildAuthorizationURL(
            clientId: clientId,
            redirectURI: redirectURI,
            codeChallenge: codeChallenge,
            state: state
        ) else {
            throw TwitterOAuthError.invalidURL
        }
        
        try await withCheckedThrowingContinuation { continuation in
            self.authenticationContinuation = continuation
            startAuthenticationSession(with: authURL)
        }
    }
    
    // MARK: - Private Methods
    private func startAuthenticationSession(with url: URL) {
        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: URL(string: redirectURI)?.scheme
        ) { [weak self] callbackURL, error in
            self?.handleAuthenticationCallback(callbackURL: callbackURL, error: error)
        }
        
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = false
        session.start()
    }
    
    private func handleAuthenticationCallback(callbackURL: URL?, error: Error?) {
        guard let continuation = authenticationContinuation else { return }
        authenticationContinuation = nil // Clear immediately to prevent multiple resumes
        
        if let error = error {
            handleAuthenticationError(error, continuation: continuation)
            return
        }
        
        guard let callbackURL = callbackURL,
              let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
            continuation.resume(throwing: TwitterOAuthError.invalidResponse)
            return
        }
        
        Task {
            await exchangeCodeForToken(code: code, continuation: continuation)
        }
    }
    
    private func handleAuthenticationError(_ error: Error, continuation: CheckedContinuation<Void, Error>) {
        if let authError = error as? ASWebAuthenticationSessionError,
           authError.code == .canceledLogin {
            continuation.resume(throwing: TwitterOAuthError.userCancelled)
        } else {
            continuation.resume(throwing: error)
        }
    }
    
    private func exchangeCodeForToken(code: String, continuation: CheckedContinuation<Void, Error>) async {
        guard let verifier = codeVerifier else {
            continuation.resume(throwing: TwitterOAuthError.codeVerifierNotFound)
            return
        }
        
        do {
            let tokenResponse = try await tokenExchanger.exchangeCodeForToken(
                code: code,
                clientId: clientId,
                clientSecret: clientSecret,
                redirectURI: redirectURI,
                codeVerifier: verifier
            )
            
            // Save tokens to DefaultsStorage
            saveTokens(tokenResponse: tokenResponse)
            
            continuation.resume()
        } catch {
            continuation.resume(throwing: error)
        }
    }
    
    /// Saves tokens to DefaultsStorage
    private func saveTokens(tokenResponse: TokenResponse) {
        userDefaults.getAuthToken = tokenResponse.accessToken
        
        if let refreshToken = tokenResponse.refreshToken {
            userDefaults.getRefreshToken = refreshToken
        }
        
        // Calculate expiration date (expires_in is in seconds, default 2 hours)
        let expirationDate = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn))
        userDefaults.tokenExpirationDate = expirationDate
    }
    
    /// Refreshes the access token if it's expired or about to expire
    public func refreshTokenIfNeeded() async throws {
        guard let refreshToken = userDefaults.getRefreshToken else {
            throw TwitterOAuthError.refreshTokenNotFound
        }
        
        // Check if token is expired or will expire in the next 5 minutes
        if let expirationDate = userDefaults.tokenExpirationDate,
           expirationDate > Date().addingTimeInterval(300) {
            // Token is still valid
            return
        }
        
        do {
            let tokenResponse = try await tokenExchanger.refreshToken(
                refreshToken: refreshToken,
                clientId: clientId,
                clientSecret: clientSecret
            )
            
            saveTokens(tokenResponse: tokenResponse)
        } catch let error as TwitterOAuthError {
            throw error
        } catch {
            throw TwitterOAuthError.tokenRefreshFailed(error.localizedDescription)
        }
    }
    
    public func getAccessToken() async throws -> String {
        // Try to refresh if needed
        try await refreshTokenIfNeeded()
        
        guard let accessToken = userDefaults.getAuthToken else {
            throw TwitterOAuthError.invalidResponse
        }
        
        return accessToken
    }
    
    public func deleteAccessToken() {
        userDefaults.removeObject(forKey: .authToken)
        userDefaults.removeObject(forKey: .refreshToken)
        userDefaults.removeObject(forKey: .tokenExpirationDate)
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension TwitterOAuthManager: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return presentationContextProvider.presentationAnchor()
    }
}
