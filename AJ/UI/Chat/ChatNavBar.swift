//
//  ChatNavBar.swift
//  AJ
//
//  Created by Денис on 14.09.2023.
//

import SwiftUI

struct ChatNavBar: View {

    @Binding var isMenuPresented: Bool
    @Binding var isEditMode: Bool
    @Binding var isLanguagesPresented: Bool

    var languages: Languages

    var body: some View {
        HStack {
            Text("🗿")
                .font(.title2)
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
            Text(isEditMode ? "✅" : "✏️")
                .font(.title2)
                .onTapGesture {
                    isEditMode.toggle()
                }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
