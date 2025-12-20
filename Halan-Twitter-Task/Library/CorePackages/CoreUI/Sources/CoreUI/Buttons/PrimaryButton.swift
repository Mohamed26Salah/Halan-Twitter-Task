//
//  File.swift
//  CoreUI
//
//  Created by Mohamed Salah on 19/12/2025.
//

import Foundation
import SwiftUI

public struct PrimaryButton: View {
    @Binding var isEnabled: Bool
    @Binding var isLoading: Bool
    var title: String
    var font: Font
    var foregroundColor: Color
    var backgroundColor: Color
    var cornerRadius: CGFloat
    var verticalPadding: CGFloat
    var action: () -> Void

    public init(
        isEnabled: Binding<Bool> = .constant(true),
        isLoading: Binding<Bool> = .constant(false),
        title: String,
        font: Font = .body,
        foregroundColor: Color = .white,
        backgroundColor: Color = .blue,
        cornerRadius: CGFloat = 12,
        verticalPadding: CGFloat = 12,
        action: @escaping () -> Void
    ) {
        self._isEnabled = isEnabled
        self._isLoading = isLoading
        self.title = title
        self.font = font
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.verticalPadding = verticalPadding
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .font(font)
                    .foregroundStyle(foregroundColor)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                    .hide(if: !isLoading)
            }
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: .infinity)
            .background(backgroundColor.opacity(isEnabled ? 1.0 : 0.5))
            .cornerRadius(cornerRadius)
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    PrimaryButton(
        isEnabled: .constant(true),
        isLoading: .constant(false),
        title: "Salah",
        action: {}
    )
}
