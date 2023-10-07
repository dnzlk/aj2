//
//  PhotoView.swift
//  AJ
//
//  Created by Денис on 07.10.2023.
//

import SwiftUI

struct PhotoView: View {

    init(source: ImagePicker.Source) {
        _model = StateObject(wrappedValue: PhotoViewModel(source: source))
    }

    // MARK: - Private Properties

    @StateObject private var model: PhotoViewModel
    @State private var isOpenImagePicker = true

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
        .sheet(isPresented: $isOpenImagePicker) {
            ImagePicker(source: model.source, image: $model.originalPhoto)
        }
        .onChange(of: model.state) { oldValue, newValue in
            switch newValue {
            case .camera, .library:
                isOpenImagePicker = true
            case .chooseLanguage:
                break
            case .translating:
                break
            case .translationDone:
                break
            }
        }
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
