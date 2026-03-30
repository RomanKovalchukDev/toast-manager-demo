//
//  ContentView.swift
//  ToastManagerDemo
//
//  Created by Roman Kovalchuk on 30.03.2026.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection

                basicToastsSection

                asyncOperationSection

                advancedToastsSection

                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle("ToastManager Demo")
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue.gradient)

            Text("ToastManager Demo")
                .font(.title.bold())

            Text("Tap buttons below to see different toast styles")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical)
    }

    private var basicToastsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Basic Toasts")
                .font(.headline)

            Button {
                viewModel.showSuccessToast()
            } label: {
                Label("Show Success Toast", systemImage: "checkmark.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)

            Button {
                viewModel.showErrorToast()
            } label: {
                Label("Show Error Toast", systemImage: "xmark.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }

    private var asyncOperationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Async Operation")
                .font(.headline)

            Text("Counter: \(viewModel.counter)")
                .font(.title2.bold())
                .foregroundStyle(.blue)

            Button {
                viewModel.performAsyncOperation()
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(maxWidth: .infinity)
                } else {
                    Label("Perform Async Task", systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)

            Text("Simulates an async operation with random success/failure")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }

    private var advancedToastsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Advanced Examples")
                .font(.headline)

            Button {
                viewModel.showCustomDurationToast()
            } label: {
                Label("Custom Duration (5s)", systemImage: "clock.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                viewModel.showLongMessageToast()
            } label: {
                Label("Long Message Toast", systemImage: "text.alignleft")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    @StateObject private var viewModel: ContentViewModel
    
    init(viewModel: @autoclosure @escaping () -> ContentViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
}

#Preview {
    NavigationStack {
        ContentView(viewModel: ContentViewModel(toastManager: ToastManager()))
    }
}
