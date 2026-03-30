//
//  SuccessToastView.swift
//  ToastManagerDemo
//
//  Created by Roman Kovalchuk on 30.03.2026.
//

import SwiftUI

struct SuccessToastView: View {
    let message: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundStyle(.white)

            Text(message)
                .font(.callout)
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.gradient)
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    VStack {
        Spacer()
        SuccessToastView(message: "Data loaded successfully")
            .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.2))
}
