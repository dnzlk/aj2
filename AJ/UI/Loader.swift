//
//  Loader.swift
//  AJ
//
//  Created by Денис on 22.09.2023.
//

import SwiftUI

struct Loader: View {

    @State private var symbol = "sparkles"

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack {
            Image(systemName: symbol)
                .imageScale(.large)
                .foregroundStyle(Assets.Colors.accentColor)
                .contentTransition(.symbolEffect(.replace))
                .padding()
                .onReceive(timer) { input in
                    symbol = GC.natureSymbols.randomElement() ?? ""
            }
        }
        .frame(width: 30, height: 30)
    }
}

#Preview {
    return Loader()
}
