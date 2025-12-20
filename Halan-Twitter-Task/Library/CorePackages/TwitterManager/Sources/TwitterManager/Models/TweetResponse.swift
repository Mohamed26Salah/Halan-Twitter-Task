//
//  TweetResponse.swift
//  TwitterManager
//
//  Created by Mohamed Salah on 20/12/2025.
//

import Foundation

/// Response model for posted tweet
public struct TweetResponse: Codable {
    public let tweetId: String
    
    public init(tweetId: String) {
        self.tweetId = tweetId
    }
}

