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
    var onPlay: () -> Void

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
            VStack(alignment: isRight ? .trailing : isLeft ? .leading : .center, spacing: 4) {
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
        HStack {
            if isRight {
                speaker()
            }
            VStack(alignment: isRight ? .trailing : isLeft ? .leading : .center, spacing: 4) {
                Text(message.translation?.text ?? "")
                    .foregroundStyle(textColor)
                    .font(.callout)
                    .padding(8)
                    .background(bgColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(alignment: isRight ? .trailing : isLeft ? .leading : .center)
                    .gesture(
                        TapGesture(count: 2).onEnded {
                            withAnimation {
                                message.isFav.toggle()
                            }
                        }.exclusively(before: TapGesture(count: 1).onEnded {
                            copy()
                        })
                    )

                if message.isFav {
                    star()
                }
            }
            if isLeft {
                speaker()
            }
        }
    }

    private func originalText() -> some View {
        Text(message.originalText)
            .lineLimit(3)
            .multilineTextAlignment(isRight ? .trailing : isLeft ? .leading : .center)
            .foregroundStyle(Assets.Colors.dark)
            .font(.caption)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, alignment: isRight ? .trailing : isLeft ? .leading : .center)
    }

    @ViewBuilder
    private func speaker() -> some View {
        let _ = Self._printChanges()

        Button(action: {
            onPlay()
        }, label: {
            Image(systemName: "speaker.wave.2.fill")
                .imageScale(.medium)
                .foregroundStyle(message.isPlaying ? bgColor : Assets.Colors.gray)
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
            .transition(.scale)
    }

    // MARK: - Actions

    private func copy() {
        UIPasteboard.general.string = message.translation?.text
    }
}
