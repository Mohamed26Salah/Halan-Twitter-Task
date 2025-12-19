//
//  File.swift
//  CoreUI
//
//  Created by Mohamed Salah on 19/12/2025.
//

import SwiftUI

struct HideViewModifier: ViewModifier {
    let isHidden: Bool
    @ViewBuilder func body(
        content: Content
    ) -> some View {
        if isHidden {
            EmptyView()
                .frame(
                    width: .zero,
                    height: .zero
                )
        } else {
            content
        }
    }
}
