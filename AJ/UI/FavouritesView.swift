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

    @Environment(\.modelContext) private var context

    @Query(filter: #Predicate<Message> { $0.isFav },
           sort: \Message.createdAt, order: .reverse)
    private var messages: [Message]

    private let audioPlayer = PlayerManager()

    // MARK: - View

    var body: some View {
        List(messages, id: \.id) { message in
            ChatCell(message: message,
                     onPlay: { audioPlayer.play(message: message, context: context) })
                .flippedUpsideDown()
                .listRowSeparator(.hidden)
        }
        .flippedUpsideDown()
        .listStyle(.plain)
        .navigationTitle("Favourites ⭐")
    }
}
