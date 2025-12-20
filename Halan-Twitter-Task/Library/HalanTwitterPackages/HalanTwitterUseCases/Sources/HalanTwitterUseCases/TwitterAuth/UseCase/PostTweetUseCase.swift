//
//  PostTweetUseCase.swift
//  HalanTwitterUseCases
//
//  Created by Mohamed Salah on 20/12/2025.
//

import Foundation
import Factory

/// Protocol for posting a tweet
public protocol PostTweetUseCaseProtocol {
    func execute(text: String) async throws -> String
}

/// Use case for posting a tweet to Twitter
public class PostTweetUseCase: PostTweetUseCaseProtocol {
    @Injected(\.twitterTweetRepository) private var tweetRepository

    // MARK: - Public Methods
    public func execute(text: String) async throws -> String {
        return try await tweetRepository.postTweet(text: text)
    }
}

