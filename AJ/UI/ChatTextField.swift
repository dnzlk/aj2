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
            TextField("Type here",
                      text: $inputText,
                      axis: .vertical)
            .font(.subheadline)
                .lineLimit(3)

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
        .background(Assets.Colors.solidWhite)
    }
}

#Preview {
    @State var input = ""
    @State var isMic = false
    return ChatTextField(inputText: $input, isMicInput: $isMic) {

    }
}
