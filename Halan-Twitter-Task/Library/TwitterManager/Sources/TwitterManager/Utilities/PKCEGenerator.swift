//
//  PKCEGenerator.swift
//  TwitterManager
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Foundation
import CommonCrypto

public protocol PKCEGeneratorProtocol {
    func generateCodeVerifier() -> String
    func generateCodeChallenge(from verifier: String) -> String
}

/// Generates PKCE parameters for OAuth 2.0 security
public struct PKCEGenerator: PKCEGeneratorProtocol {
    
    private let codeVerifierLength = 128
    private let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
    
    public init() {}
    /// Generates a random string for PKCE code verifier
    /// - Returns: A 128-character random string
    public func generateCodeVerifier() -> String {
        return String((0..<codeVerifierLength).map { _ in 
            allowedCharacters.randomElement()! 
        })
    }
    
    /// Generates code challenge from verifier (SHA256 hash, base64url encoded)
    public func generateCodeChallenge(from verifier: String) -> String {
        guard let data = verifier.data(using: .utf8) else {
            return ""
        }
        let hash = data.sha256()
        return hash.base64URLEncodedString()
    }
}

