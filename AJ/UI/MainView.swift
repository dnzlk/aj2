//
//  MainView.swift
//  AJ
//
//  Created by Денис on 04.09.2023.
//

import SwiftUI

struct MainView: View {

    @Environment(\.modelContext) private var context

    @State private var voiceText: String = ""
    @State private var languages: Languages = (.english, .russian)

    @State private var isRecording = false

    var body: some View {
        NavigationStack {
            VStack {
                ChatView()
                .fullScreenCover(isPresented: $isRecording) {
                    RecordingView(languages: languages, transcription: $voiceText)
                }
            }
            .background(Assets.Colors.white)
        }
    }
}

//#Preview {
//    MainView()
//}
