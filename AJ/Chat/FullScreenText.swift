//
//  FullScreenText.swift
//  AJ
//
//  Created by Денис on 10.10.2023.
//

import SwiftUI

struct FullScreenText: View {

    @Environment(\.dismiss) private var dismiss

    var text: String

    var body: some View {
        ZStack {
            Assets.Colors.chatBackground
                .ignoresSafeArea()
            let screen = UIScreen.main.bounds
            let size = CGSize(width: screen.height - 100, height: screen.width)
            Text(text)
                .font(.system(size: fontSize(rect: size)))
                .foregroundStyle(Assets.Colors.black)
                .frame(width: size.width, height: size.height)
                .multilineTextAlignment(.center)
                .rotationEffect(.degrees(90), anchor: .center)
        }
        .onTapGesture {
            dismiss()
        }
    }

    private func fontSize(rect: CGSize) -> CGFloat {
        var maxFontSize: CGFloat = 200
        let minFontSize: CGFloat = 8

        while !doesText(text, font: .systemFont(ofSize: maxFontSize), fitIn: rect) {
            maxFontSize -= 1
            if maxFontSize == minFontSize {
                break
            }
        }
        return maxFontSize
    }

    private func doesText(_ text: String, font: UIFont, fitIn rect: CGSize) -> Bool {
        let constraintSize = CGSize(width: rect.width, height: .greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: font]

        let boundingRect = (text as NSString).boundingRect(with: constraintSize,
                                                          options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                          attributes: attributes,
                                                          context: nil)

        return boundingRect.height <= rect.height
    }
}

#Preview {
    FullScreenText(text: "1HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHe2")
}
