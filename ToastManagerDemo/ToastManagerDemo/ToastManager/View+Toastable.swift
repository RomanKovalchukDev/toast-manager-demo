//
//  View+Toastable.swift
//  ToastManagerDemo
//
//  Created by Roman Kovalchuk on 30.03.2026.
//

import SwiftUI

extension View {
    func toastable(with toastManager: ToastManager) -> some View {
        modifier(ToastableModifier(toastManager: toastManager))
    }
}
