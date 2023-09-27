//
//  AppIconView.swift
//  AJ
//
//  Created by Денис on 27.09.2023.
//

import SwiftUI

struct AppIconView: View {

    @State private var isShowIconsCarousel = false

    @State private var appIcon: String = "🗿"

    var body: some View {
        VStack {
            HStack {
                Spacer()

                icon(title: appIcon, font: 100)
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 0.5)
                            .foregroundStyle(.gray)
                    )

                Spacer()
            }
            Spacer()

            if isShowIconsCarousel {
                carousel()
            }
        }
        .onViewDidLoad {
            updateAppIcon()
        }
        .onTapGesture {
            withAnimation {
                isShowIconsCarousel.toggle()
            }
        }
    }

    @ViewBuilder
    private func carousel() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                Spacer()
                    .frame(width: 8)
                icon(title: "🗿", font: 30)
                    .onTapGesture {
                        UIApplication.shared.setAlternateIconName(nil) { _ in
                            updateAppIcon()
                        }
                    }
                ForEach(Language.allCases, id: \.rawValue) { language in
                    icon(title: language.flag, font: 30)
                        .onTapGesture {
                            UIApplication.shared.setAlternateIconName(language.appIcon) { _ in
                                updateAppIcon()
                            }
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
        .transition(.identity)
    }

    private func icon(title: String, font: CGFloat) -> some View {
        Text(title)
            .font(.system(size: font))
            .padding()
            .background(Assets.Colors.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(lineWidth: 0.2)
                    .foregroundStyle(.gray)
                    .opacity(appIcon == title ? 1 : 0)
            )

    }

    private func updateAppIcon() {
        if let name = UIApplication.shared.alternateIconName {
            appIcon = Language.allCases.first(where: { $0.appIcon == name })?.flag ?? "🗿"
        } else {
            appIcon = "🗿"
        }
    }
}

#Preview {
    AppIconView()
}
