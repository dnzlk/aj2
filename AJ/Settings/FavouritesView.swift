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

    @State private var fullScreenMessage: Message?

    @Query(filter: #Predicate<Message> { $0.isFav }, sort: \Message.createdAt, order: .reverse)
    private var messages: [Message]

    @StateObject private var audioPlayer = AudioPlayer()

    // MARK: - View

    var body: some View {
        VStack {
            NavBar(title: "Favourites ⭐")
            List(messages, id: \.id) { message in
                ChatCell(message: message,
                         fullScreenMessage: $fullScreenMessage,
                         isPlaying: message.id == audioPlayer.playingMessageId,
                         onPlay: { audioPlayer.play(message: message) },
                         onCopy: { UIPasteboard.general.string = message.translation?.text })
                .flippedUpsideDown()
                .listRowSeparator(.hidden)
            }
            .flippedUpsideDown()
            .listStyle(.plain)
            .fullScreenCover(item: $fullScreenMessage) { message in
                FullScreenText(text: message.translation?.text ?? "")
            }
        }
        .toolbar(.hidden, for: .navigationBar)
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
