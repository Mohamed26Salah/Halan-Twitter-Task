//
//  ContentView.swift
//  Halan-Twitter-Task
//
//  Created by Mohamed Salah on 18/12/2025.
//

import SwiftUI
import HalanTwitterUseCases
import Factory

struct ContentView: View {
    @Injected(\.authenticateUserUseCase) private var authenticateUserUseCase

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            do {
                try await authenticateUserUseCase.execute()
            } catch {
                print("Error: \(error)")
            }
        }
        
    }
}

#Preview {
    ContentView()
}
