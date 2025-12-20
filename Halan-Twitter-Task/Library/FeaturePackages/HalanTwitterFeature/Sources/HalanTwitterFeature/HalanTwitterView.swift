//
//  HalanTwitterView.swift
//  HalanTwitterFeature
//
//  Created by Mohamed Salah on 20/12/2025.
//

import SwiftUI

struct HalanTwitterView: View {
    @StateObject private var viewModel: HalanTwitterViewModel
    
    init(viewModel: StateObject<HalanTwitterViewModel>) {
        self._viewModel = viewModel
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SwiftUIView(viewModel: .init(wrappedValue: .init()))
}
