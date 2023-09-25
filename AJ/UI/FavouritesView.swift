//
//  FavouritesView.swift
//  AJ
//
//  Created by Денис on 22.09.2023.
//

import SwiftData
import SwiftUI

struct FavouritesView: View {

    // MARK: - Private Properties

    @Environment(\.dismiss) private var dismiss

    @Query(filter: #Predicate<Message> { $0.isFav }, sort: \Message.createdAt, order: .reverse)
    private var messages: [Message]

    private let audioPlayer = PlayerManager()

    // MARK: - View

    var body: some View {
        VStack {
            navBar()
            List(messages, id: \.id) { message in
                ChatCell(message: message,
                         onPlay: { audioPlayer.play(message: message) },
                         onCopy: { UIPasteboard.general.string = message.translation?.text })
                .flippedUpsideDown()
                .listRowSeparator(.hidden)
            }
            .flippedUpsideDown()
            .listStyle(.plain)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func navBar() -> some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Assets.Colors.accentColor)
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            Spacer()

            Text("Favourites ⭐")
                .fontWeight(.semibold)

            Spacer()

            Button(action: {}) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Assets.Colors.accentColor)
                    .padding(.horizontal)
            }
            .opacity(0)
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
