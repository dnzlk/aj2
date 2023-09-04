//
//  ButtonComponent.swift
//  AskJoe
//
//  Created by Денис on 15.02.2023.
//

import UIKit

class ButtonComponent: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Assets.Colors.accentColor
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? Assets.Colors.accentColor?.withAlphaComponent(0.8) : Assets.Colors.accentColor
        }
    }
}
