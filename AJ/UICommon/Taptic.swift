//
//  Taptic.swift
//  AJ
//
//  Created by Денис on 16.10.2023.
//

import UIKit

final class Taptic {

    private init() {}

    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
