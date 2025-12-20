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
import UIKit

public class HalanTwitterViewModel: ObservableObject {
    @Injected(\.authenticateUserUseCase) private var authenticateUserUseCase
    @Injected(\.countTweetCharactersUseCase) private var countTweetCharactersUseCase
    
    ///A Flag indicating if user is logged in or his session is still active
    @Published var isUserLoggedIn: Bool
    
    ///A Flag indicating if the sign in button should be enabled or not
    @Published var isTwitterLogInButtonEnabled: Bool
    
    ///A Flag indicating if the sign in button should show loaded or not
    @Published var isTwitterLogInButtonLoading: Bool

    ///The text of the tweet, that will be posted.
    @Published var tweetText: String
    
    ///The character count of the tweet according to Twitter's counting rules
    @Published var tweetCharacterCount: Int?
    
    ///The remaining characters available for the tweet (starts at 280 and decreases as user types)
    @Published var tweetCharacterLimit: Int
    
    ///A Flag indicating if the post tweet button should be enabled(0> or =280) or disabled (=0 or >280)
    @Published var isPostTweetButtonEnabled: Bool
    
    private var cancellables = Set<AnyCancellable>()
    let maxCharacterLimit = 280

    public init() {
        isUserLoggedIn = false
        isTwitterLogInButtonEnabled = true
        isTwitterLogInButtonLoading = false
        tweetText = ""
        tweetCharacterCount = nil
        tweetCharacterLimit = maxCharacterLimit
        isPostTweetButtonEnabled = false
        setupTweetTextSubscription()
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

//MARK: - Subscribtions -
extension HalanTwitterViewModel {
    /// Sets up subscription to tweetText changes to update character count and remaining limit
    private func setupTweetTextSubscription() {
        $tweetText
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .map { [weak self] text -> (Int?, Int) in
                guard let self = self else { return (0, 280) }
                if text.isEmpty {
                    return (0, 280)
                }
                let count = self.countTweetCharactersUseCase.execute(text: text)
                let remaining = 280 - count
                return (count, remaining)
            }
            .sink { [weak self] count, remaining in
                guard let self = self else { return }
                withAnimation(.default) {
                    self.tweetCharacterCount = count
                    // Disable if no text (remaining == 280) or over limit (remaining < 0)
                    self.isPostTweetButtonEnabled = remaining < self.maxCharacterLimit && remaining >= 0
                    guard self.isPostTweetButtonEnabled else {return}
                    self.tweetCharacterLimit = remaining
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - Post A Tweet Helper Functions -
extension HalanTwitterViewModel {
    /// Copy the tweet text to the clipboard
    func copyText() {
        UIPasteboard.general.string = tweetText
        AlertManager.show(title: "Done", message: "Text copied to clipboard!")
    }
    
    /// Clear the tweet text
    func clearTweetText() {
        self.tweetText = ""
        self.tweetCharacterCount = 0
        self.tweetCharacterLimit = maxCharacterLimit
        self.isPostTweetButtonEnabled = false
    }
}

