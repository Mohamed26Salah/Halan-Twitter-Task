//
//  TwitterTweetRepositoryProtocol.swift
//  HalanTwitterUseCases
//
//  Created by Mohamed Salah on 20/12/2025.
//

import Foundation

/// Protocol for Twitter tweet operations repository
public protocol TwitterTweetRepositoryProtocol {
    func postTweet(text: String) async throws -> String
}

