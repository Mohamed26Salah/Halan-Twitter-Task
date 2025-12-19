//
//  TwitterOAuthError.swift
//  TwitterManager
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Foundation

/// Errors that can occur during Twitter OAuth authentication flow
public enum TwitterOAuthError: LocalizedError {
    case invalidURL
    case invalidResponse
    case codeVerifierGenerationFailed
    case codeVerifierNotFound
    case tokenExchangeFailed(String)
    case httpError(Int)
    case userCancelled
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .codeVerifierGenerationFailed:
            return "Failed to generate code verifier"
        case .codeVerifierNotFound:
            return "Code verifier not found"
        case .tokenExchangeFailed(let message):
            return "Token exchange failed: \(message)"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .userCancelled:
            return "User cancelled authentication"
        }
    }
}



