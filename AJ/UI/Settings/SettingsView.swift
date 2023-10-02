//
//  SettingsView.swift
//  AJ
//
//  Created by Денис on 27.09.2023.
//

import SwiftUI

struct SettingsView: View {

    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss

    // MARK: - Types

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

    // MARK: - Private Properties

    @State private var isFavouritesOpen = false

    // MARK: - View

    var body: some View {
        NavigationStack {
            List {
                Section {
                    row(.favourites)

                } header: {
                    VStack {
                        navBar()
                        AppIconView()
                    }
                    .listRowInsets(.init(top: 8, leading: -16, bottom: 16, trailing: -16))
                } footer: {
                    version()
                }
            }
        }
    }

    private func navBar() -> some View {
        HStack {
            Spacer()
            Button(action: { dismiss() }, label: {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundStyle(.gray)
            })
        }
        .foregroundStyle(.red)
        .padding(.horizontal)
    }

    private func row(_ row: Row) -> some View {
        NavigationLink {
            switch row {
            case .favourites:
                return FavouritesView()
            }
        } label: {
            HStack {
                Text(row.icon)
                Text(row.title)
                    .fontWeight(.regular)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .id(row.rawValue)
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

//    let style: UIUserInterfaceStyle = {
//        if colorScheme == .dark {
//            return .light
//        } else {
//            return .dark
//        }
//    }()
//    (UIApplication.shared.connectedScenes.first as?
//      UIWindowScene)?.windows.first?.overrideUserInterfaceStyle = style
}

#Preview {
    SettingsView()
}
