//
//  ChatCell.swift
//  AJ
//
//  Created by Денис on 15.09.2023.
//

import SwiftUI

struct ChatCell: View {

    // MARK: - Types

    enum Style: Hashable {
        case loading
        case error
        case right
        case left
    }

    // MARK: - Public Properties

    var message: Message
    var style: Style
    var isPlaying: Bool

    // MARK: - Private Properties

    private var isLeft: Bool {
        style == .left
    }

    private var isRight: Bool {
        style == .right
    }

    // MARK: - View

    var body: some View {
        HStack {
            if isRight {
                Spacer()
                Spacer()
            }
            VStack(alignment: isRight ? .trailing : isLeft ? .leading : .center) {

                switch style {
                case .loading:
                    ProgressView()
                case .error:
                    EmptyView()
                case .right, .left:
                    translation()
                    voiceAndCopyButtons()
                }

                originalText()
            }
            if isLeft {
                Spacer()
                Spacer()
            }
        }
//        .padding()
    }

    private func translation() -> some View {
        Text(message.translation?.text ?? "")
            .foregroundStyle(Assets.Colors.textOnAccent)
            .font(.callout)
            .padding(8)
            .background(Assets.Colors.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func voiceAndCopyButtons() -> some View {
        HStack {
            Button(action: {}, label: {
                Text(isRight ? "📄" : "▶️")
                    .font(.title2)
                    .padding(isRight ? .horizontal : .init(rawValue: 0))
            })
            Button(action: {}, label: {
                Text(isLeft ? "📄" : "▶️")
                    .font(.title2)
                    .padding(isLeft ? .horizontal : .init(rawValue: 0))
            })
        }
    }

    private func originalText() -> some View {
        Text(message.originalText)
            .multilineTextAlignment(isRight ? .trailing : isLeft ? .leading : .center)
            .foregroundStyle(Assets.Colors.dark)
            .font(.caption)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
    }
}
