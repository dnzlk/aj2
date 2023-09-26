//
//  ViewDidLoadModifier.swift
//  AJ
//
//  Created by Денис on 26.09.2023.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {

    @State private var viewDidLoad = false

    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}

extension View {

    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
}
