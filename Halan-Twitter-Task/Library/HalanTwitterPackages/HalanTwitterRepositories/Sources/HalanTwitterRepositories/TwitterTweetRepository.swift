//
//  TwitterTweetRepository.swift
//  HalanTwitterRepositories
//
//  Created by Mohamed Salah on 20/12/2025.
//

import Foundation
import Factory
import TwitterManager
import HalanTwitterUseCases

public class TwitterTweetRepository: TwitterTweetRepositoryProtocol {
    @Injected(\.twitterOAuthManager) private var oauthManager

    // MARK: - Public Methods
    public func postTweet(text: String) async throws -> String {
        let response = try await oauthManager.postTweet(text: text)
        return response.tweetId
    }
}

