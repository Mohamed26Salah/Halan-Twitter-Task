//
//  HalanTwitterView.swift
//  HalanTwitterFeature
//
//  Created by Mohamed Salah on 20/12/2025.
//

import SwiftUI
import CoreUI

public struct HalanTwitterView: View {
    @StateObject private var viewModel: HalanTwitterViewModel
    
    public init(
        viewModel: StateObject<HalanTwitterViewModel> = .init(wrappedValue: .init())
    ) {
        self._viewModel = viewModel
    }
    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.isUserLoggedIn {
//                    LoggedInView
                    Text("User is Logged in")
                } else {
                    SignInButtonView
                }
            }
            .navigationTitle("Twitter")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.logOut()
                    }, label: {
                        Text("Log Out")
                            .foregroundColor(.red)
                            .opacity(viewModel.isUserLoggedIn ? 1.0 : 0.0)
                    })
                    .disabled(!viewModel.isUserLoggedIn)
                }
            }
        }
        .onAppear {
            viewModel.checkIfUserTokenExist()
        }
    }
}

// MARK: - Logged Out User -
extension HalanTwitterView {
    var SignInButtonView: some View {
        PrimaryButton(
            isEnabled: $viewModel.isTwitterLogInButtonEnabled,
            isLoading: $viewModel.isTwitterLogInButtonLoading,
            title: "Sign In using Twitter",
            backgroundColor: .black) {
                viewModel.authenticateUser()
            }
            .padding(.horizontal, 25)
    }
}

// MARK: - Logged In User -
extension HalanTwitterView {
    
}

#Preview {
    HalanTwitterView(viewModel: .init(wrappedValue: .init()))
}
