//
//  ImageScreenView.swift
//  Visionka
//
//  Created by Денис on 06.10.2023.
//

import SwiftUI

struct ImageScreenView: View {

    @State private var img = UIImage(named: "m")!

    var body: some View {
        Image(uiImage: img)
            .resizable()
            .scaledToFit()
            .onViewDidLoad {
                ImageTextRecognizer(image: $img).recognizeText()
            }
    }
}
