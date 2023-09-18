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

        static let white = Color("Colors/White")
        static let black = Color("Colors/Black")
        static let accentColor = Color("Colors/AccentColor")
        static let solidBlack = Color("Colors/SolidBlack")
        static let solidWhite = Color("Colors/SolidWhite")
        static let mediumGray = Color("Colors/MediumGray")
        static let dark = Color("Colors/Dark")
        static let gray = Color("Colors/Gray")
        static let lightGray = Color("Colors/LightGray")
        static let textOnAccent = Color.white
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
