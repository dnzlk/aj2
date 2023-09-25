//
//  ChatVoicesBottomBar.swift
//  AJ
//
//  Created by Денис on 25.09.2023.
//

import SwiftUI

struct ChatVoicesBottomBar: View {

    let languages: Languages

    var selectedLanguage: Language?

    var isRecording: Bool

    @Binding var isMicInput: Bool

    var onStartRecording: (Language) -> Void

    var onSend: () -> Void

    var onCancel: () -> Void

    @State private var speakTextOpacity: Double = 0.5

    @State private var selectLanguageString = ""

    @State private var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            HStack {
                cancelButton()
                    .opacity(isRecording ? 1 : 0)

                if selectedLanguage != languages.to {
                    Spacer()
                    flag(language: languages.from)
                }

                Spacer()

                if selectedLanguage != languages.from {
                    flag(language: languages.to)
                    Spacer()
                }

                if isRecording {
                    sendButton()
                } else {
                    textButton()
                }
            }
            Text(isRecording ? selectedLanguage?.speakText ?? " " : selectLanguageString)
                .font(.title2)
                .foregroundStyle(Assets.Colors.dark)
                .opacity(isRecording ? speakTextOpacity : 1)
                .transition(.opacity)
        }
        .padding(.horizontal)
        .background(.regularMaterial)
        .onChange(of: isRecording, { oldValue, newValue in
            if newValue {
                timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
            } else {
                timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
            }
        })
        .onReceive(timer) { _ in
            withAnimation {
                if isRecording {
                    speakTextOpacity = speakTextOpacity == 0.5 ? 0.2 : 0.5
                } else {
                    if selectLanguageString == languages.from.selectLanguage {
                        selectLanguageString = languages.to.selectLanguage
                    } else {
                        selectLanguageString = languages.from.selectLanguage
                    }
                }
            }
        }
        .onViewDidLoad {
            selectLanguageString = languages.from.selectLanguage
        }
    }

    private func sendButton() -> some View {
        Button {
            onSend()
        } label: {
            Image(systemName: "arrow.up.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(Assets.Colors.accentColor)
        }
        .padding(8)
    }

    private func textButton() -> some View {
        Button {
            withAnimation {
                isMicInput = false
            }
        } label: {
            Image(systemName: "textformat")
                .frame(width: 30, height: 30)
                .foregroundStyle(Assets.Colors.solidWhite)
                .background(Assets.Colors.accentColor)
                .clipShape(Circle())
        }
        .padding(8)
    }

    private func cancelButton() -> some View {
        Button {
            onCancel()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(Assets.Colors.gray)
        }
        .padding(8)
    }

    private func flag(language: Language) -> some View {
        Button(action: {
            onStartRecording(language)
        }) {
            Text(language.flag)
                .font(.system(size: 60))
        }
        .transition(.slide.combined(with: .opacity))
    }
}
