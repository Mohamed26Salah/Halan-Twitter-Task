//
//  File.swift
//  HalanTwitterUseCases
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Foundation

/// Protocol for Twitter authentication repository
public protocol TwitterAuthRepositoryProtocol {
    func authenticate() async throws -> String
}
