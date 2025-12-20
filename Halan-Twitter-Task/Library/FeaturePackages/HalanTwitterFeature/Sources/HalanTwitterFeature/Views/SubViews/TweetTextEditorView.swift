//
//  TweetTextEditorView.swift
//  HalanTwitterFeature
//
//  Created by Mohamed Salah on 20/12/2025.
//

import SwiftUI

struct TweetTextEditorView: View {
    @Binding var text: String
    let placeholder: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // Text Editor
            TextEditor(text: $text)
                .font(.body)
                .foregroundColor(Colors.text)
                .padding(Layout.textPadding)
                .background(Colors.background)
                .scrollContentBackground(.hidden)
                .focused($isFocused)
            
            // Placeholder (hidden when focused OR text is not empty)
            if text.isEmpty && !isFocused {
                Text(placeholder)
                    .font(.system(
                        size: Typography.placHolderFontSize,
                        weight: .medium
                    ))
                    .foregroundColor(Colors.placeholder)
                    .padding(Layout.placeholderPadding)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: Layout.cornerRadius)
                .stroke(Colors.border, lineWidth: Layout.borderWidth)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: Layout.cornerRadius)
        )
    }
}


private extension TweetTextEditorView {
    
    enum Layout {
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 1
        static let textPadding: CGFloat = 12
        static let placeholderPadding: EdgeInsets = .init(
            top: 16,
            leading: 16,
            bottom: 0,
            trailing: 0
        )
    }
    
    enum Typography {
        static let placHolderFontSize: CGFloat = 12
    }
    
    enum Colors {
        static let background: Color = .white
        static let text: Color = .black
        static let placeholder: Color = .black.opacity(0.5)
        static let border: Color = Color.black.opacity(0.1)
    }
}


#Preview {
    TweetTextEditorView(
        text: .constant(""),
        placeholder: "Start typing! You can enter up to 280 characters"
    )
    .padding()
}
