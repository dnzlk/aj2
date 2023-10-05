//
//  ChatNavBar.swift
//  AJ
//
//  Created by Денис on 14.09.2023.
//

import SwiftUI

struct ChatNavBar: View {

    @Binding var isMenuPresented: Bool
    @Binding var isSpeakAloud: Bool
    @Binding var isLanguagesPresented: Bool

    var languages: Languages

    var body: some View {
        HStack {
            Text("☰")
                .font(.title)
                .onTapGesture {
                    isMenuPresented = true
                }
            Spacer()

            HStack(spacing: 4) {
                Text(languages.from.flag)
                    .font(.title2)
                Image(._2)
                Text(languages.to.flag)
                    .font(.title2)
            }
            .onTapGesture {
                isLanguagesPresented = true
            }

            Spacer()
            Image(systemName: isSpeakAloud ? "speaker.wave.3.fill" : "speaker.wave.3")
                .contentTransition(.symbolEffect(.replace, options: .speed(2.2)))
                .foregroundStyle(isSpeakAloud ? Assets.Colors.accentColor : Color.gray)
                .onTapGesture {
                    isSpeakAloud.toggle()
                }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
