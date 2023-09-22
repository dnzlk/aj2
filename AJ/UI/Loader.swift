//
//  Loader.swift
//  AJ
//
//  Created by Денис on 22.09.2023.
//

import SwiftUI

struct Loader: View {

    @State private var symbol = GC.natureSymbols.randomElement()

    private let timer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack {
            Image(systemName: symbol ?? "globe")
                .imageScale(.large)
                .foregroundStyle(Assets.Colors.accentColor)
                .contentTransition(.symbolEffect(.replace))
                .padding()
                .onAppear {
                    symbol = GC.natureSymbols.randomElement()
                }
                .onReceive(timer) { input in
                    symbol = GC.natureSymbols.randomElement()
            }
        }
        .frame(width: 30, height: 30)
    }
}

#Preview {
    return Loader()
}
