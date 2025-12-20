//
//  File.swift
//  HalanTwitterFeature
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Factory

public extension Container {
    /// Authenticate User Use Case factory
    var authenticateUserUseCase: Factory<AuthenticateUserUseCaseProtocol> {
        Factory(self) {
            AuthenticateUserUseCase()
        }
    }
    
    /// Count Tweet Characters Use Case factory
    var countTweetCharactersUseCase: Factory<CountTweetCharactersUseCaseProtocol> {
        Factory(self) {
            CountTweetCharactersUseCase()
        }
    }
    
    /// Post Tweet Use Case factory
    var postTweetUseCase: Factory<PostTweetUseCaseProtocol> {
        Factory(self) {
            PostTweetUseCase()
        }
    }
}
