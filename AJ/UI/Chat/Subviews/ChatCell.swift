//
//  ChatCell.swift
//  AJ
//
//  Created by Денис on 15.09.2023.
//

import SwiftData
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

    private var hasTranslation: Bool {
        message.translation != nil
    }

    private var isError: Bool {
        message.error != nil
    }

    // MARK: - View

    var body: some View {
        HStack {
            if isRight {
                Spacer()
                Spacer()
            }
            VStack(alignment: isRight ? .trailing : isLeft ? .leading : .center) {
                loadingView()
                translation()
                originalText()
            }
            if isLeft {
                Spacer()
                Spacer()
            }
        }
    }

    private func loadingView() -> some View {
        ProgressView()
            .frame(height: hasTranslation || isError ? 0 : nil)
            .opacity(hasTranslation || isError ? 0 : 1)
    }

    private func translation() -> some View {
        VStack(alignment: isRight ? .trailing : isLeft ? .leading : .center) {
            Text(message.translation?.text ?? "")
                .foregroundStyle(Assets.Colors.textOnAccent)
                .font(.callout)
                .padding(8)
                .background(Assets.Colors.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))

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
        .frame(height: hasTranslation ? nil : 0)
        .opacity(hasTranslation ? 1 : 0)
    }

    private func originalText() -> some View {
        Text(message.originalText)
            .lineLimit(3)
            .foregroundStyle(Assets.Colors.dark)
            .font(.caption)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, alignment: isRight ? .trailing : isLeft ? .leading : .center)
    }
}
