//
//  ChatNavBar.swift
//  AJ
//
//  Created by Денис on 14.09.2023.
//

import SwiftUI

struct ChatNavBar: View {

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
    }
}

#Preview {
    let lan: Languages = (.english, .russian)

    return ChatNavBar(languages: lan)
}
