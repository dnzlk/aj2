//
//  AJApp.swift
//  AJ
//
//  Created by Денис on 04.09.2023.
//

import SwiftData
import SwiftUI

@main
struct AJApp: App {

    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: Message.self)
        }
    }
}
