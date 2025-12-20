//
//  AuthenticateUserUseCase.swift
//  HalanTwitterUseCases
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Foundation
import Factory

/// Protocol for authenticating a user with Twitter
public protocol AuthenticateUserUseCaseProtocol {
    func execute() async throws
    func checkIfUserTokenIsValid() async throws -> String
}

/// Use case for authenticating a user with Twitter
public class AuthenticateUserUseCase: AuthenticateUserUseCaseProtocol {
    @Injected(\.twitterAuthRepository) private var authRepository

    // MARK: - Public Methods
    public func execute() async throws {
        try await authRepository.authenticate()
    }
    
    public func checkIfUserTokenIsValid() async throws -> String {
        try await authRepository.checkIfAccessTokenExist()
    }
}

