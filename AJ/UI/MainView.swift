//
//  MainView.swift
//  AJ
//
//  Created by Денис on 04.09.2023.
//

import SwiftUI

struct MainView: View {

    @State private var voiceText: String = ""
    @State private var languages: Languages = (.english, .russian)

    @State private var isRecording = false

    var body: some View {
        NavigationStack {
            VStack {
                navBar()

                ChatView(voiceText: $voiceText, languages: languages) {
                    isRecording = true
                }
                .fullScreenCover(isPresented: $isRecording) {
                    RecordingView(languages: languages, transcription: $voiceText)
                }
            }
            .background(Assets.Colors.white)
        }
    }
}

private extension MainView {

    func navBar() -> some View {
        HStack {
            NavigationLink(destination: {
                MenuView()
            }) {
                Image(systemName: "square.grid.2x2")
                    .imageScale(.large)
                    .foregroundStyle(Assets.Colors.accentColor)
            }
            Spacer()

            HStack(spacing: 4) {
                Text(languages.0.flag)
                    .font(.title2)
                Image(._2)
                Text(languages.1.flag)
                    .font(.title2)
            }
            Spacer()
            NavigationLink(destination: {
                MenuView()
            }) {
                Image(systemName: "heart.fill")
                    .imageScale(.large)
                    .foregroundStyle(.red)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

//#Preview {
//    MainView()
//}
