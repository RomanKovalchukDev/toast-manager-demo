//
//  ToastableModifier.swift
//  ToastManagerDemo
//
//  Created by Roman Kovalchuk on 02.01.2026.
//

import SwiftUI

public struct ToastableModifier: ViewModifier {
    @Bindable var toastManager: ToastManager

    public init(toastManager: ToastManager) {
        self._toastManager = Bindable(toastManager)
    }

    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let toast = toastManager.toast {
                    VStack {
                        Spacer()

                        switch toast {
                        case .error(let message):
                            ErrorToastView(error: message)

                        case .success(let message):
                            SuccessToastView(message: message)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: toastManager.toast)
                }
            }
    }
}
