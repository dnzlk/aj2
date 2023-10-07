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
    @Binding var isOpenCamera: Bool
    @Binding var isOpenLibrary: Bool

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
            Menu {
                Button(action: {isOpenCamera = true}, label: {
                    Label("Camera", systemImage: "camera.viewfinder")
                })
                Button(action: {isOpenLibrary = true}, label: {
                    Label("Library", systemImage: "photo")
                })
            } label: {
                Image(systemName: "camera")
                    .foregroundStyle(Assets.Colors.accentColor)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
