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
    
    ///A Flag indicating if user is logged in or his session is still active
    @Published var isUserLoggedIn: Bool
    
    ///A Flag indicating if the sign in button should be enabled or not
    @Published var isTwitterLogInButtonEnabled: Bool
    
    ///A Flag indicating if the sign in button should show loaded or not
    @Published var isTwitterLogInButtonLoading: Bool

    public init() {
        isUserLoggedIn = false
        isTwitterLogInButtonEnabled = true
        isTwitterLogInButtonLoading = false
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
    
    ///Log out user and delete the cached token
    func logOut() {
        authenticateUserUseCase.logOutUser()
        isUserLoggedIn = false
    }
}

// MARK: - Twitter Api Calls -
extension HalanTwitterViewModel {
    ///Start the authentication with twitter and cache the token
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
