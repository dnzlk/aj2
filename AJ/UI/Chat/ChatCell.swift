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
                        .transition(.move(edge: .bottom))
                        .transition(.opacity)
                    voiceAndCopyButtons()
                }

                originalText()
                    .frame(maxWidth: .infinity)
            }
            if isLeft {
                Spacer()
                Spacer()
            }
        }
        .padding()
        .background(.black.opacity(0.1))
    }

    private func translation() -> some View {
        Text(message.translation ?? "")
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
            .padding(.vertical, 4)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension Edge.Set {
    public static var none: HorizontalAlignment?
}

//#Preview {
//
//    struct _V: View {
//
//        @State var style = ChatCell.Style.loading
//        @State var isPlaying = false
//
//        var body: some View {
//            return VStack {
//                ChatCell(message: .init(originalText: "Его родин",
//                                        translation: "A list view is a container view that shows its content in a single scrollable column. This list can be constructed using hierarchical, dynamic, and static data. It provides a great-looking appearance that conforms to the standard styling for each of the different Apple platforms like iOS, macOS, and watchOS. Making it easy to build cross-platform apps.",
//                                        createdAt: Date(),
//                                        language: "en",
//                                        isFav: true),
//                         style: style,
//                         isPlaying: isPlaying)
//
//                Button(action: {
//                    withAnimation {
//                        style = .right
//                    }
//                }, label: {
//                    Text("Button")
//                })
//            }
//        }
//    }
//
//    return _V()
//}
