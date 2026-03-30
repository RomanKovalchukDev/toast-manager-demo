//
//  ContentViewModel.swift
//  ToastManagerDemo
//
//  Created by Roman Kovalchuk on 30.03.2026.
//

import Foundation
import Combine

@MainActor
final class ContentViewModel: ObservableObject {
    private let toastManager: ToastManager

    @Published var counter: Int = 0
    @Published var isLoading: Bool = false

    init(toastManager: ToastManager) {
        self.toastManager = toastManager
    }

    func showSuccessToast() {
        toastManager.showToast(.success("Operation completed successfully!"))
    }

    func showErrorToast() {
        toastManager.showToast(.error("Something went wrong. Please try again."))
    }

    func performAsyncOperation() {
        isLoading = true

        // Simulate async operation
        Task {
            try? await Task.sleep(for: .seconds(2))

            isLoading = false

            // Random success or failure
            if Bool.random() {
                counter += 1
                toastManager.showToast(.success("Counter incremented to \(counter)"))
            } else {
                toastManager.showToast(.error("Failed to increment counter"))
            }
        }
    }

    func showCustomDurationToast() {
        toastManager.showToast(
            .success("This toast will stay for 5 seconds"),
            autoDismissDelay: 5.0
        )
    }

    func showLongMessageToast() {
        toastManager.showToast(
            .error("This is a longer error message that demonstrates how the toast handles multi-line text content gracefully.")
        )
    }
}
