//
//  TokenResponse.swift
//  TwitterManager
//
//  Created by Mohamed Salah on 19/12/2025.
//

import Foundation

/// Response model for Twitter OAuth token exchange
public struct TokenResponse: Codable {
    public let accessToken: String
    public let refreshToken: String?
    public let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
    
    public init(accessToken: String, refreshToken: String?, expiresIn: Int) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
    }
}
