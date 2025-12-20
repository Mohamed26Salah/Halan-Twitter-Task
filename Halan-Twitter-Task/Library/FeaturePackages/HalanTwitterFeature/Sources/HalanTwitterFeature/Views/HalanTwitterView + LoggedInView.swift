//
//  LoggedInView.swift
//  HalanTwitterFeature
//
//  Created by Mohamed Salah on 20/12/2025.
//

import SwiftUI
import CoreUI

struct LoggedInView: View {
    @ObservedObject var viewModel: HalanTwitterViewModel
    
    var body: some View {
        VStack(spacing: Layout.verticalSpacing) {
            twitterLogo
            
            characterCountersView
            
            TweetTextEditorView(
                text: $viewModel.tweetText,
                placeholder: Texts.editorPlaceholder
            )
            .frame(height: Sizes.editorHeight)
            .padding(.bottom, Spacing.section)
            
            buttonsRow
            
            postTweetButtonView
        }
        .padding(.horizontal, Spacing.horizontal)
    }
}

extension LoggedInView {
    
    var twitterLogo: some View {
        Image("twitterLogo", bundle: .coreUI)
            .resizable()
            .frame(
                width: Sizes.logo,
                height: Sizes.logo
            )
            .padding(.bottom, Spacing.section)
    }
    
    var characterCountersView: some View {
        HStack(spacing: Spacing.counters) {
            CharacterCounterView(
                title: Texts.typed,
                maxCount: .constant(viewModel.maxCharacterLimit),
                typedCount: $viewModel.tweetCharacterCount
            )
            
            CharacterCounterView(
                title: Texts.remaining,
                maxCount: $viewModel.tweetCharacterLimit,
                typedCount: .constant(nil)
            )
        }
        .padding(.bottom, Spacing.section)
    }
    
    var buttonsRow: some View {
        HStack(spacing: Spacing.buttons) {
            copyTextButtonView
            clearTextButtonView
        }
        .padding(.bottom, Spacing.section)
    }
    
    var copyTextButtonView: some View {
        PrimaryButton(
            title: Texts.copy,
            backgroundColor: Colors.copyButton
        ) {
            viewModel.copyText()
        }
    }
    
    var clearTextButtonView: some View {
        PrimaryButton(
            title: Texts.clear,
            backgroundColor: Colors.clearButton
        ) {
            viewModel.clearTweetText()
        }
    }
    
    var postTweetButtonView: some View {
        PrimaryButton(
            isEnabled: $viewModel.isPostTweetButtonEnabled,
            isLoading: $viewModel.isPostTweetButtonLoading,
            title: Texts.post
        ) {
            viewModel.postTweet()
        }
    }
}

private extension LoggedInView {
    
    enum Layout {
        static let verticalSpacing: CGFloat = 0
    }
    
    enum Spacing {
        static let horizontal: CGFloat = 16
        static let section: CGFloat = 24
        static let counters: CGFloat = 20
        static let buttons: CGFloat = 180
    }
    
    enum Sizes {
        static let logo: CGFloat = 60
        static let editorHeight: CGFloat = 240
    }
    
    
    enum Colors {
        static let copyButton: Color = .green
        static let clearButton: Color = .red
    }
    
    enum Texts {
        static let editorPlaceholder = "Start typing! You can enter up to 280 characters"
        static let typed = "Characters Typed"
        static let remaining = "Characters Remaining"
        static let copy = "Copy Text"
        static let clear = "Clear Text"
        static let post = "Post Tweet"
    }
}


//#Preview {
//    LoggedInView()
//}
