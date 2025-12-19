//
//  TwitterOAuthURLBuilder.swift
//  TwitterManager
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Foundation

public protocol TwitterOAuthURLBuilderProtocol {
    func buildAuthorizationURL(
        clientId: String,
        redirectURI: String,
        codeChallenge: String,
        state: String
    ) -> URL?
}

/// Builds Twitter OAuth 2.0 authorization URLs
public struct TwitterOAuthURLBuilder: TwitterOAuthURLBuilderProtocol {
    
    private let baseURL = "https://twitter.com/i/oauth2/authorize"
    private let scopes = "tweet.read tweet.write users.read offline.access"
    
    public init() {}

    /// - Parameters:
    ///   - clientId: OAuth 2.0 client ID
    ///   - redirectURI: Callback URL after authorization
    ///   - codeChallenge: PKCE code challenge
    ///   - state: Random state string for CSRF protection
    /// - Returns: Complete authorization URL
    public func buildAuthorizationURL(
        clientId: String,
        redirectURI: String,
        codeChallenge: String,
        state: String
    ) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "scope", value: scopes),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "S256")
        ]
        return components?.url
    }
}



