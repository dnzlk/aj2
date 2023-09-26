//
//  Toast.swift
//  AJ
//
//  Created by Денис on 22.09.2023.
//

import SwiftUI

struct Toast: ViewModifier {

    @Binding var isShow: Bool

    @State private var offset: Double = -200

    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        content
            .overlay(
                VStack {
                    toastView()
                        .offset(y: offset)
                    Spacer()
                }
            )
            .onChange(of: isShow) { _, _ in
              show()
            }
    }

    private func toastView() -> some View {
        VStack {
            HStack(spacing: 2) {
                Image(systemName: "doc.on.doc")
                    .foregroundStyle(Assets.Colors.accentColor)
                Text("Copied")
                    .font(.subheadline)
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(Assets.Colors.solidWhite)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .shadow(radius: 2)
        }
    }

    private func show() {
        guard isShow else { return }

        workItem?.cancel()

        let task = DispatchWorkItem {
            dismiss()
        }

        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: task)

        withAnimation(.spring(duration: 0.5)) {
            offset = isShow ? 16 : -50
        }
    }

    private func dismiss() {
        withAnimation {
            offset = -200
            isShow = false
        }
        workItem?.cancel()
        workItem = nil
    }
}

extension View {

    func toast(isShow: Binding<Bool>) -> some View {
        self.modifier(Toast(isShow: isShow))
    }
}
