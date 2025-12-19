//
//  TwitterTokenExchanger.swift
//  TwitterManager
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Foundation

public protocol TwitterTokenExchangerProtocol {
    func exchangeCodeForToken(
        code: String,
        clientId: String,
        clientSecret: String,
        redirectURI: String,
        codeVerifier: String
    ) async throws -> TokenResponse
    
    func refreshToken(
        refreshToken: String,
        clientId: String,
        clientSecret: String
    ) async throws -> TokenResponse
}

/// Handles the exchange of authorization code for access token
public struct TwitterTokenExchanger: TwitterTokenExchangerProtocol {
    
    private let tokenEndpoint = "https://api.twitter.com/2/oauth2/token"
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// - Parameters:
    ///   - code: Authorization code received from callback
    ///   - clientId: OAuth 2.0 client ID
    ///   - clientSecret: OAuth 2.0 client secret
    ///   - redirectURI: Callback URL used in authorization
    ///   - codeVerifier: PKCE code verifier
    /// - Returns: TokenResponse containing access token, refresh token, and expiration
    /// - Throws: TwitterOAuthError if exchange fails
    public func exchangeCodeForToken(
        code: String,
        clientId: String,
        clientSecret: String,
        redirectURI: String,
        codeVerifier: String
    ) async throws -> TokenResponse {
        guard let url = URL(string: tokenEndpoint) else {
            throw TwitterOAuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Create Basic Auth header (client_id:client_secret base64 encoded)
        let credentials = "\(clientId):\(clientSecret)"
        if let credentialsData = credentials.data(using: .utf8) {
            let base64Credentials = credentialsData.base64EncodedString()
            request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        }
        
        // Build form-encoded body
        let bodyParams = [
            "code": code,
            "grant_type": "authorization_code",
            "client_id": clientId,
            "redirect_uri": redirectURI,
            "code_verifier": codeVerifier
        ]
        
        request.httpBody = bodyParams
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        return try await performTokenRequest(request: request)
    }
    
    /// - Parameters:
    ///   - refreshToken: The refresh token to use
    ///   - clientId: OAuth 2.0 client ID
    ///   - clientSecret: OAuth 2.0 client secret
    /// - Returns: TokenResponse containing new access token, refresh token, and expiration
    /// - Throws: TwitterOAuthError if refresh fails
    public func refreshToken(
        refreshToken: String,
        clientId: String,
        clientSecret: String
    ) async throws -> TokenResponse {
        guard let url = URL(string: tokenEndpoint) else {
            throw TwitterOAuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Create Basic Auth header (client_id:client_secret base64 encoded)
        let credentials = "\(clientId):\(clientSecret)"
        if let credentialsData = credentials.data(using: .utf8) {
            let base64Credentials = credentialsData.base64EncodedString()
            request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        }
        
        // Build form-encoded body for refresh token request
        let bodyParams = [
            "refresh_token": refreshToken,
            "grant_type": "refresh_token"
        ]
        
        request.httpBody = bodyParams
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        return try await performTokenRequest(request: request)
    }
    
    // MARK: - Private Methods
    
    private func performTokenRequest(request: URLRequest) async throws -> TokenResponse {
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw TwitterOAuthError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = extractErrorMessage(from: data)
                throw TwitterOAuthError.tokenExchangeFailed(errorMessage)
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let accessToken = json["access_token"] as? String else {
                throw TwitterOAuthError.invalidResponse
            }
            
            let refreshToken = json["refresh_token"] as? String
            let expiresIn = json["expires_in"] as? Int ?? 7200 // Default to 2 hours if not provided
            
            return TokenResponse(
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiresIn: expiresIn
            )
        } catch {
            throw error
        }
    }
    
    private func extractErrorMessage(from data: Data?) -> String {
        guard let data = data,
              let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let errorMessage = errorData["error_description"] as? String else {
            return "Unknown error"
        }
        return errorMessage
    }
}

