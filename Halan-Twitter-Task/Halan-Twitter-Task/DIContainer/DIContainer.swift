//
//  File.swift
//  HalanTwitterFeature
//
//  Created by Mohamed Salah on 18/12/2025.
//

import Factory
import HalanTwitterRepositories
public extension Container {

    static func registerAppLayerDependencies() {
        // Register repository implementations from BreadfastRepositories
        registerRepositoryImplementations()
    }
    
    /// Resets all registered dependencies and clears the container cache.
    /// This should be called during logout to ensure a clean state.
    static func resetAndReinitialize() {
        // Reset all singletons and cached instances
        Container.shared.reset()
        // Re-register all dependencies
        registerAppLayerDependencies()
    }
}
