//
//  ToastManagerDemoApp.swift
//  ToastManagerDemo
//
//  Created by Roman Kovalchuk on 30.03.2026.
//

import SwiftUI

@main
struct ToastManagerDemoApp: App {
    // Create ToastManager at app level
    private let toastManager = ToastManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(
                    viewModel: ContentViewModel(toastManager: toastManager)
                )
            }
            // Apply toastable modifier at root level
            .toastable(with: toastManager)
        }
    }
}
