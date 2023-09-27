//
//  AppIconManager.swift
//  AJ
//
//  Created by Денис on 27.09.2023.
//

import UIKit

extension Bundle {

    var appIcon: String {
        guard
            let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String:Any],
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String:Any],
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last
        else {
            return "AppIcon"
        }
        return lastIcon
    }
}
