//
//  HalanTwitterViewModel.swift
//  HalanTwitterFeature
//
//  Created by Mohamed Salah on 20/12/2025.
//

import SwiftUI
import Foundation
import Combine
import Factory
import HalanTwitterUseCases
import CoreUI

class HalanTwitterViewModel: ObservableObject {
    @Injected(\.authenticateUserUseCase) private var authenticateUserUseCase
    
    @Published var userIsLoggedIn: Bool = false
    
    init() {
        
    }
    
}

// MARK: - View Life Cycle -
extension HalanTwitterViewModel {
    func onAppear() {
        checkIfUserTokenExist()
    }
}

// MARK: - Check User State -
extension HalanTwitterViewModel {
    ///Check if user is logged in or not
    func checkIfUserTokenExist() {
        Task {
            do {
               let token = try await authenticateUserUseCase.checkIfUserTokenIsValid()
                await MainActor.run {
                    userIsLoggedIn = true
                }
            } catch {
                AlertManager.show(message: "SomeThing Went Wrong!")
                await MainActor.run {
                    userIsLoggedIn = false
                }
            }
        }
    }
}
