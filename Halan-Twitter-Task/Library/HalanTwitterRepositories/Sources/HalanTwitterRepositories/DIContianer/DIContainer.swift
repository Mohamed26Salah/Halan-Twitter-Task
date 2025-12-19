//
//  File.swift
//  HalanTwitterFeature
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Factory
import TwitterManager
import HalanTwitterUseCases

public extension Container {
    static func registerRepositoryImplementations() {
        Container.shared.twitterAuthRepository.register {
            TwitterAuthRepository()
        }
    }
}
