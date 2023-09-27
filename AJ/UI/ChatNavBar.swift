//
//  ChatNavBar.swift
//  AJ
//
//  Created by Денис on 14.09.2023.
//

import SwiftUI

struct ChatNavBar: View {

    @Binding var isLanguagesPresented: Bool

    var languages: Languages

    var body: some View {
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
            NavigationLink(destination: {
                FavouritesView()
            }) {
                Text("⭐")
                    .font(.title2)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
