//
//  ChatNavBar.swift
//  AJ
//
//  Created by Денис on 14.09.2023.
//

import SwiftUI

struct ChatNavBar: View {

    @Binding var isMenuPresented: Bool
    @Binding var isLanguagesPresented: Bool
    @Binding var isPhotoPresented: Bool

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

            Image(systemName: "camera")
                .foregroundStyle(Assets.Colors.accentColor)
                .onTapGesture {
                    isPhotoPresented = true
                }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
