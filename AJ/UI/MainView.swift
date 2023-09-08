//
//  MainView.swift
//  AJ
//
//  Created by Денис on 04.09.2023.
//

import SwiftUI

struct MainView: View {

    @State private var languages: Languages = (.english, .russian)

    var body: some View {
        NavigationStack {
            VStack {
                navBar()

                ChatView(languages: languages)
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
                Image(systemName: "gear")
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
                Image(systemName: "plus.message")
                    .imageScale(.large)
                    .foregroundStyle(Assets.Colors.accentColor)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    MainView()
}
