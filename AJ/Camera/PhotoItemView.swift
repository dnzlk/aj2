//
//  PhotoItemView.swift
//  Camera
//
//  Created by Денис on 10.10.2023.
//

import SwiftUI
import Photos

struct PhotoItemView: View {
    
    var asset: PhotoAsset
    var cache: CachedImageManager?
    var imageSize: CGSize

    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?

    var body: some View {

        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .scaleEffect(0.5)
            }
        }
        .task {
            guard image == nil, let cache = cache else { return }

            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result {
                        self.image = Image(uiImage: result.image)
                    }
                }
            }
        }
    }
}
