//
//  PhotoView.swift
//  AJ
//
//  Created by Денис on 07.10.2023.
//

import SwiftUI

struct PhotoView: View {

    // MARK: - Private Properties

    @StateObject private var model = PhotoViewModel()
    @State private var source: ImagePicker.Source?
    @Environment(\.dismiss) var dismiss

    // MARK: - Views

    var body: some View {
        ZStack {
            image()
            VStack {
                navBar()
                Spacer()
            }
        }
//        .sheet(item: $source) { source in
//            ImagePicker(source: source, image: $model.originalPhoto)
//        }
    }

    private func image() -> some View {
        VStack {
            let image: UIImage? = {
                if let image = model.originalPhoto, model.isShowOriginalPhoto {
                    return image
                }
                if let image = model.translatedPhoto {
                    return image
                }
                return nil
            }()
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
    }

    private func navBar() -> some View {
        HStack {
            Spacer()
            Button(action: { dismiss() }, label: {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundStyle(.gray)
            })
        }
        .foregroundStyle(.red)
        .padding(.horizontal)
    }
}
