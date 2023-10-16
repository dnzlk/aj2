//
//  LanguagesView.swift
//  AJ
//
//  Created by Денис on 21.09.2023.
//

import SwiftUI

struct LanguagesView: View {

    @Environment(\.dismiss) private var dismiss

    @AppStorage(Storage.languages.key) private var languages: Languages = .defaultValues

    @State private var editingLanguage: Language = .english

    var body: some View {
        List {
            Section {
                ForEach(Language.allCases, id: \.rawValue) { lng in
                    languageRow(language: lng)
                        .onTapGesture {
                            select(language: lng)
                        }
                }
            } header: {
                selectedLanguages()
            } footer: {
                Spacer()
                    .frame(height: 100)
            }
        }
        .scrollIndicators(.hidden)
        .overlay(
            VStack {
                Spacer()
                doneButton()
            }
        )
        .navigationTitle("")
        .onViewDidLoad {
            editingLanguage = languages.from
        }
    }

    private func selectedLanguages() -> some View {
        VStack {
            HStack(spacing: 32) {
                Spacer()

                bigFlag(language: languages.from)

                Image(systemName: "arrow.left.arrow.right")
                    .imageScale(.large)
                    .symbolEffect(.bounce, options: .speed(2), value: editingLanguage)
                    .onTapGesture {
                        toggleSelection()
                    }

                bigFlag(language: languages.to)

                Spacer()
            }
            Spacer()
        }
    }

    private func bigFlag(language: Language) -> some View {
        Text(language.flag)
            .font(.system(size: 60))
            .padding(6)
            .background(editingLanguage.rawValue == language.rawValue ? Assets.Colors.accentColor.opacity(0.3) : nil)
            .clipShape(Circle())
            .onTapGesture {
                if editingLanguage != language {
                    toggleSelection()
                }
            }
    }

    @ViewBuilder
    private func languageRow(language: Language) -> some View {
        let isSelected = editingLanguage.rawValue == language.rawValue
        HStack {
            Text(language.flag)
            Text(language.localizedName)
                .fontWeight(isSelected ? .semibold : .regular)
            Spacer()
            Image(systemName: "checkmark")
                .opacity(isSelected ? 1 : 0)
                .foregroundStyle(.blue)
        }
        .contentShape(Rectangle())
    }

    private func doneButton() -> some View {
        Button(action: {
            dismiss()
        }) {
            HStack {
                Spacer()

                Text("Done")
                    .foregroundStyle(.white)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .padding()

                Spacer()
            }
            .background(Assets.Colors.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            .background(.regularMaterial)
        }
    }

    // MARK: - Actions

    private func select(language: Language) {
        withAnimation(.spring(duration: 0.4)) {
            if language == languages.from && editingLanguage == languages.to {
                languages = .init(from: languages.to, to: language)
            } else if language == languages.to && editingLanguage == languages.from {
                languages = .init(from: language, to: languages.from)
            } else {
                if languages.from == editingLanguage {
                    languages = .init(from: language, to: languages.to)
                } else if languages.to == editingLanguage {
                    languages = .init(from: languages.from, to: language)
                }
            }
            editingLanguage = language
        }
    }

    private func toggleSelection() {
        if editingLanguage == languages.from {
            editingLanguage = languages.to
        } else {
            editingLanguage = languages.from
        }
    }
}

#Preview {
    struct ContentView: View {

        var body: some View {
            LanguagesView()
        }
    }
    return ContentView()
}
