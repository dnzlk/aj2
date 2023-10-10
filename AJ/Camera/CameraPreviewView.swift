//
//  CameraPreviewView.swift
//  Camera
//
//  Created by Денис on 09.10.2023.
//

import SwiftUI

struct CameraPreviewView: View {

    @Binding var image: Image?

    var body: some View {
        GeometryReader { geometry in
            if let image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}
