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

public class HalanTwitterViewModel: ObservableObject {
    @Injected(\.authenticateUserUseCase) private var authenticateUserUseCase
    
    @Published var isUserLoggedIn: Bool = false
    @Published var isTwitterLogInButtonEnabled: Bool = true
    @Published var isTwitterLogInButtonLoading: Bool = false

    public init() {
        
    }
    
}

// MARK: - View Life Cycle -
extension HalanTwitterViewModel {
    func onAppear() {
        checkIfUserTokenExist()
    }
}

// MARK: - User State -
extension HalanTwitterViewModel {
    ///Check if user is logged in or not
    func checkIfUserTokenExist() {
        Task {
            do {
               let _ = try await authenticateUserUseCase.checkIfUserTokenIsValid()
                await MainActor.run {
                    isUserLoggedIn = true
                }
            } catch {
                AlertManager.show(message: "SomeThing Went Wrong!")
                await MainActor.run {
                    isUserLoggedIn = false
                }
            }
        }
    }
    
    func logOut() {
        authenticateUserUseCase.logOutUser()
        isUserLoggedIn = false
    }
}

// MARK: - Twitter Api Calls -
extension HalanTwitterViewModel {
    func authenticateUser() {
        isTwitterLogInButtonEnabled = false
        isTwitterLogInButtonLoading = true
        Task {
            do {
                try await authenticateUserUseCase.execute()
                await MainActor.run {
                    isTwitterLogInButtonLoading = false
                    isUserLoggedIn = true
                    isTwitterLogInButtonEnabled = true
                }
            } catch {
                AlertManager.show(message: "Failed To Sign In!")
                await MainActor.run {
                    isTwitterLogInButtonEnabled = true
                    isTwitterLogInButtonLoading = false
                }
            }
        }
    }
}
