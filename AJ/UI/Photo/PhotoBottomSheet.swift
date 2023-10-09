//
//  PhotoBottomSheet.swift
//  AJ
//
//  Created by Денис on 07.10.2023.
//

import SwiftUI

struct PhotoBottomSheet: View {

    @State private var languages: Languages
    @State private var isLanguagesPresented = false
    @Binding var source: ImagePicker.Source?

    @Environment(\.dismiss) var dismiss

    init(languages: Languages, source: Binding<ImagePicker.Source?>) {
        self._languages = State(initialValue: languages)
        self._source = source
    }

    var body: some View {
        VStack {
            HStack(spacing: 4) {
                Text(languages.from.flag)
                    .font(.title)
                Image(systemName: "arrow.left.arrow.right")
                    .foregroundStyle(Assets.Colors.accentColor)
                Text(languages.to.flag)
                    .font(.title)
            }
            .onTapGesture {
                isLanguagesPresented = true
            }

            Button {
                dismiss()
                source = .camera
            } label: {
                button(text: "Open Camera")
            }
            .padding()

            Button {
                dismiss()
                source = .library
            } label: {
                button(text: "Open Library")
            }
            .padding(.horizontal)
        }
    }

    private func button(text: String) -> some View {
        HStack {
            Spacer()

            Text(text)
                .foregroundStyle(.white)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .padding()

            Spacer()
        }
        .background(Assets.Colors.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
