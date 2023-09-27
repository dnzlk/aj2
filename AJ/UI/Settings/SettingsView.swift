//
//  SettingsView.swift
//  AJ
//
//  Created by Денис on 27.09.2023.
//

import SwiftUI

struct SettingsView: View {

    private enum Row: String {
        case favourites

        var icon: String {
            switch self {
            case .favourites:
                return "⭐"
            }
        }

        var title: String {
            switch self {
            case .favourites:
                return "Favourites"
            }
        }
    }

    var body: some View {
        List {
            Section {
                row(.favourites)
            } header: {
                AppIconView()
                    .listRowInsets(.init(top: 8, leading: -16, bottom: 16, trailing: -16))
            } footer: {
                version()
            }
        }
    }

    private func row(_ row: Row) -> some View {
        HStack {
            Text(row.icon)
            Text(row.title)
                .fontWeight(.regular)
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundStyle(.gray)
        }
        .contentShape(Rectangle())
        .id(row.rawValue)
        .onTapGesture {
            handleTap(row: row)
        }
    }

    @ViewBuilder
    private func version() -> some View {
        let v = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        HStack {
            Spacer()

            Text(v)
                .font(.subheadline)
                .foregroundStyle(.gray)

            Spacer()
        }
        .padding()
    }

    // MARK: - Private Methods

    private func handleTap(row: Row) {

    }
}

#Preview {
    SettingsView()
}
