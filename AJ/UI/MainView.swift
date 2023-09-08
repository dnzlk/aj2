//
//  MainView.swift
//  AJ
//
//  Created by Денис on 04.09.2023.
//

import SwiftUI

struct MainView: View {

    var body: some View {
        NavigationStack {
            VStack {
                navBar()

                ChatView()
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

            Image(.a2Z)
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
