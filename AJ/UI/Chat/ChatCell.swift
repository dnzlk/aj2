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

    private enum Style: Hashable {
        case loading
        case error
        case right
        case left
    }

    // MARK: - Public Properties

    @Bindable var message: Message
    var isPlaying: Bool
    var onPlay: () -> Void
    var onCopy: () -> Void

    // MARK: - Private Properties

    private var style: Style {
        if message.state == .loading {
            return .loading
        }
        if message.state == .failed {
            return .error
        }
        return message.translation?.isSentByUser == true ? .right : .left
    }

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

    private var bgColor: Color {
        let accentColor = Assets.Colors.accentColor

        guard let translation = message.translation else { return accentColor }

        return Language(rawValue: translation.language)?.color.bgColor ?? accentColor
    }

    private var textColor: Color {
        guard let translation = message.translation else { return .white }

        return Language(rawValue: translation.language)?.color.textColor ?? .white
    }

    // MARK: - View

    var body: some View {
        HStack {
            if isRight {
                Spacer()
                Spacer()
            }
            VStack(alignment: isRight ? .trailing : isLeft ? .leading : .center, spacing: 0) {
                if !hasTranslation && !isError {
                    loader()
                }
                if hasTranslation {
                    translation()
                    originalText()
                }
            }
            if isLeft {
                Spacer()
                Spacer()
            }
        }
        .listRowBackground(Color.clear)
    }

    private func loader() -> some View {
        HStack {
            Spacer()
            Loader()
            Spacer()
        }
    }

    private func translation() -> some View {
        VStack(alignment: isRight ? .trailing : isLeft ? .leading : .center, spacing: 0) {
            HStack {
                if isRight {
                    speaker()
                }
                Text(message.isShowOriginalText ? message.originalText : message.translation?.text ?? "")
                    .foregroundStyle(textColor)
                    .font(.callout)
                    .padding(8)
                    .background(bgColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .gesture(
                        TapGesture(count: 2).onEnded {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation(.spring(duration: 0.25)) {
                                message.isFav.toggle()
                            }
                        }.exclusively(before: TapGesture(count: 1).onEnded {
                            onCopy()
                        })
                    )
                if isLeft {
                    speaker()
                }
            }
            star()
        }
        .offset(y: message.isFav ? -8 : 0)
    }

    private func originalText() -> some View {
        Text(message.isShowOriginalText ? message.translation?.text ?? "" : message.originalText)
            .lineLimit(3)
            .multilineTextAlignment(isRight ? .trailing : isLeft ? .leading : .center)
            .foregroundStyle(Assets.Colors.dark)
            .font(.caption)
            .padding(.bottom, 4)
            .padding(isLeft ? .leading : .trailing, 4)
            .offset(y: -8)
            .frame(maxWidth: .infinity, alignment: isRight ? .trailing : isLeft ? .leading : .center)
            .onTapGesture {
                message.isShowOriginalText.toggle()
            }
    }

    @ViewBuilder
    private func speaker() -> some View {
        let _ = Self._printChanges()

        Button(action: {
            onPlay()
        }, label: {
            Image(systemName: "speaker.wave.2.fill")
                .imageScale(.medium)
                .foregroundStyle(isPlaying ? bgColor : Assets.Colors.gray)
        })
        .buttonStyle(.borderless)
    }

    private func star() -> some View {
        Text("⭐")
            .font(.system(size: 12))
            .padding(4)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Assets.Colors.solidWhite, lineWidth: 1)
            )
            .offset(x: isRight ? -2 : 2, y: -8)
            .opacity(message.isFav ? 1 : 0)
    }
}
