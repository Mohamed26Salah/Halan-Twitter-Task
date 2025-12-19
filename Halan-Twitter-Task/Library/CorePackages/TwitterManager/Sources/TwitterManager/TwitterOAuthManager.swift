//
//  TwitterOAuthManager.swift
//  TwitterManager
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Foundation
import Factory
import AuthenticationServices

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
    private var authenticationContinuation: CheckedContinuation<String, Error>?
    
    // MARK: - Initialization
    
    public init(
        clientId: String,
        clientSecret: String,
        redirectURI: String,
    ) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
    }
    
    // MARK: - Public Methods
    
    /// Initiates OAuth 2.0 authentication flow
    /// - Returns: Access token
    /// - Throws: TwitterOAuthError if authentication fails
    public func authenticate() async throws -> String {
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
        
        return try await withCheckedThrowingContinuation { continuation in
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
    
    private func handleAuthenticationError(_ error: Error, continuation: CheckedContinuation<String, Error>) {
        if let authError = error as? ASWebAuthenticationSessionError,
           authError.code == .canceledLogin {
            continuation.resume(throwing: TwitterOAuthError.userCancelled)
        } else {
            continuation.resume(throwing: error)
        }
    }
    
    private func exchangeCodeForToken(code: String, continuation: CheckedContinuation<String, Error>) async {
        guard let verifier = codeVerifier else {
            continuation.resume(throwing: TwitterOAuthError.codeVerifierNotFound)
            return
        }
        
        do {
            let accessToken = try await tokenExchanger.exchangeCodeForToken(
                code: code,
                clientId: clientId,
                clientSecret: clientSecret,
                redirectURI: redirectURI,
                codeVerifier: verifier
            )
            continuation.resume(returning: accessToken)
        } catch {
            continuation.resume(throwing: error)
        }
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension TwitterOAuthManager: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return presentationContextProvider.presentationAnchor()
    }
}
