//
//  ChatTextField.swift
//  AJ
//
//  Created by Денис on 25.09.2023.
//

import SwiftUI

struct ChatTextField: View {

    @Binding var inputText: String
    @Binding var isMicInput: Bool

    var onSend: () -> Void

    var body: some View {
        HStack {
            textField()

            Button {
                inputText.isEmpty ? isMicInput = true : onSend()
            } label: {
                Image(systemName: inputText.isEmpty ? "mic.circle.fill" : "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Assets.Colors.accentColor)
            }
            .contentTransition(.symbolEffect(.replace, options: .speed(2.2)))
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(.ultraThickMaterial)
    }

    @ViewBuilder
    private func textField() -> some View {
        HStack {
            TextField("Type here",
                      text: $inputText,
                      axis: .vertical)
            .font(.body)
            .lineLimit(3)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)

            if inputText.isEmpty && !isMicInput {
                Button {
                    inputText = UIPasteboard.general.string ?? ""
                } label: {
                    Image(systemName: "doc.on.clipboard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                        .foregroundStyle(Assets.Colors.mediumGray.opacity(0.5))
                }
                .padding(.horizontal)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Assets.Colors.mediumGray.opacity(0.5), lineWidth: 1)
        )
    }
}

#Preview {
    @State var input = ""
    @State var isMic = false
    return ChatTextField(inputText: $input, isMicInput: $isMic) {
    }
}
