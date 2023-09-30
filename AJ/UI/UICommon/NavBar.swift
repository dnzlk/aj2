//
//  NavBar.swift
//  AJ
//
//  Created by Денис on 30.09.2023.
//

import SwiftUI

struct NavBar: View {

    let title: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Assets.Colors.accentColor)
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            Spacer()

            Text(title)
                .fontWeight(.semibold)

            Spacer()

            Button(action: {}) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Assets.Colors.accentColor)
                    .padding(.horizontal)
            }
            .opacity(0)
        }
    }
}

#Preview {
    NavBar(title: "Hello")
}
