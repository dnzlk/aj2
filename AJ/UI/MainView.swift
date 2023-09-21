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

    @State private var voiceText: String = ""
    @State private var languages: Languages = .init(from: .russian, to: .english)

    @State private var isRecording = false

    var body: some View {
        NavigationStack {
            VStack {
                ChatView()
                .fullScreenCover(isPresented: $isRecording) {
                    RecordingView(languages: languages, transcription: $voiceText)
                }
            }
        }
        .onViewDidLoad {
            let fetchDescriptor = FetchDescriptor(sortBy: [SortDescriptor(\Message.createdAt)])

            let messages = (try? context.fetch(fetchDescriptor)) ?? []

            for message in messages where message.translation == nil {
                context.delete(message)
            }
        }
    }
}

struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}

extension View {
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
}
