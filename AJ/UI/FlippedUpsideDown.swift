//
//  FlippedUpsideDown.swift
//  AJ
//
//  Created by Денис on 19.09.2023.
//

import SwiftUI

struct FlippedUpsideDown: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(180))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

extension View{

    func flippedUpsideDown() -> some View {
        self.modifier(FlippedUpsideDown())
    }
}
