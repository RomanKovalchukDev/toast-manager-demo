//
//  ErrorToastView.swift
//  ToastManagerDemo
//
//  Created by Roman Kovalchuk on 30.03.2026.
//

import SwiftUI

struct ErrorToastView: View {
    let error: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "xmark.circle.fill")
                .font(.title2)
                .foregroundStyle(.white)

            Text(error)
                .font(.callout)
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red.gradient)
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    VStack {
        Spacer()
        ErrorToastView(error: "Failed to load data")
            .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.2))
}
