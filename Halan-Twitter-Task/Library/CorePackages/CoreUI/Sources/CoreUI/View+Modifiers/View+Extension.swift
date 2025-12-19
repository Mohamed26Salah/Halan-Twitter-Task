//
//  File.swift
//  CoreUI
//
//  Created by Mohamed Salah on 19/12/2025.
//

import SwiftUI
public extension View {
    func hide(
        if isHiddden: Bool
    ) -> some View {
        ModifiedContent(
            content: self,
            modifier: HideViewModifier(
                isHidden: isHiddden
            )
        )
    }
}
