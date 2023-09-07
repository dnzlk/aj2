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
            Image(systemName: "square.grid.2x2")
                .imageScale(.large)
                .hidden()
            Spacer()

            Image(.a2Z)
            Spacer()
            NavigationLink(destination: {
                MenuView()
            }) {
                Image(systemName: "square.grid.2x2")
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
