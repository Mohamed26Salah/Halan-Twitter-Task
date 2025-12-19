//
//  TwitterAuthRepository.swift
//  HalanTwitterRepositories
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Foundation
import Factory
import TwitterManager
import HalanTwitterUseCases

public class TwitterAuthRepository: TwitterAuthRepositoryProtocol {
    @Injected(\.twitterOAuthManager) private var oauthManager

    // MARK: - Public Methods
    public func authenticate() async throws {
        try await oauthManager.authenticate()
    }
}

