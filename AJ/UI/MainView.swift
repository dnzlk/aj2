//
//  MainView.swift
//  AJ
//
//  Created by Денис on 04.09.2023.
//

import SwiftData
import SwiftUI

struct MainView: View {

    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            VStack {
                ChatView()
            }
        }
        .onViewDidLoad {
            let fetchDescriptor = FetchDescriptor(sortBy: [SortDescriptor(\Message.createdAt)])

            let messages = (try? context.fetch(fetchDescriptor)) ?? []

            for message in messages where message.translation == nil {
                context.delete(message)
            }

//            for _ in 0...1000 {
//                let message = Message(id: UUID().uuidString, originalText: UUID().uuidString, translation: .init(text: UUID().uuidString, language: "ru", isSentByUser: true), createdAt: Date(), isFav: false, error: nil)
//                context.insert(message)
//            }
        }
    }
}
