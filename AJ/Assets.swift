//
//  Assets.swift
//  AskJoe
//
//  Created by Денис on 14.02.2023.
//

import SwiftUI
import UIKit

// TODO: SwiftGen

struct Assets {

    struct Colors {

        static let white = Color(UIColor(named: "Colors/White") ?? .white)
        static let black = UIColor(named: "Colors/Black")
        static let accentColor = Color(UIColor(named: "Colors/AccentColor") ?? .blue)
        static let solidBlack = UIColor(named: "Colors/SolidBlack")
        static let solidWhite = UIColor(named: "Colors/SolidWhite")
        static let mediumGray = UIColor(named: "Colors/MediumGray")
        static let dark = UIColor(named: "Colors/Dark")
        static let gray = UIColor(named: "Colors/Gray")
        static let lightGray = UIColor(named: "Colors/LightGray")
        static let textOnAccent = UIColor.white
    }
}

extension UIFont {

    static func regular(_ size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .regular)
    }

    static func medium(_ size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .medium)
    }

    static func bold(_ size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .bold)
    }

    static func heavy(_ size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .heavy)
    }
}

extension UIFont {
    
    var bold: UIFont {
        return with(.traitBold)
    }

    var italic: UIFont {
        return with(.traitItalic)
    }

    var boldItalic: UIFont {
        return with([.traitBold, .traitItalic])
    }

    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
