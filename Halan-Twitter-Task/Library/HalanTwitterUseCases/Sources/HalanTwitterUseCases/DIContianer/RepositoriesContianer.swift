//
//  File.swift
//  HalanTwitterUseCases
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Factory

public extension Container {
    var twitterAuthRepository: Factory<TwitterAuthRepositoryProtocol> {
        Factory(self) { fatalError("Implementation for TwitterAuthRepositoryProtocol must be provided by higher layer")
        }
    }
}
