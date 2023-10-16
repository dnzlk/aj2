//
//  LibraryView.swift
//  Camera
//
//  Created by Денис on 10.10.2023.
//

import SwiftUI

struct LibraryView: View {

    // MARK: - Types

    private enum Const {
        static let itemSpacing = 12.0
        static let itemCornerRadius = 15.0
        static let itemSize = CGSize(width: 90, height: 90)
    }

    // MARK: - Public Properties

    @ObservedObject var photoCollection: PhotoCollection
    @Binding var image: UIImage?
    @Binding var isPresented: Bool

    // MARK: - Private Properties

    private let cache = CachedImageManager()

    @Environment(\.displayScale) private var displayScale
    @Environment(\.dismiss) private var dismiss

    private let columns = [
        GridItem(.adaptive(minimum: Const.itemSize.width, maximum: Const.itemSize.height), spacing: Const.itemSpacing)
    ]

    private var imageSize: CGSize {
        return CGSize(width: Const.itemSize.width * min(displayScale, 2), height: Const.itemSize.height * min(displayScale, 2))
    }

    // MARK: - Views

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Const.itemSpacing) {
                ForEach(photoCollection.photoAssets, id: \.id) { asset in
                    Button {
                        Task {
                            await select(asset: asset)
                        }
                    } label: {
                        photoItemView(asset: asset)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .padding([.vertical], Const.itemSpacing)
        }
        .navigationTitle("Gallery")
        .navigationBarTitleDisplayMode(.inline)
        .statusBar(hidden: false)
        .onAppear {
            isPresented = true
        }
        .onDisappear {
            isPresented = false
        }
    }

    private func photoItemView(asset: PhotoAsset) -> some View {
        PhotoItemView(asset: asset, cache: photoCollection.cache, imageSize: imageSize)
            .frame(width: Const.itemSize.width, height: Const.itemSize.height)
            .clipped()
            .cornerRadius(Const.itemCornerRadius)
            .onAppear {
                Task {
                    await photoCollection.cache.startCaching(for: [asset], targetSize: imageSize)
                }
            }
            .onDisappear {
                Task {
                    await photoCollection.cache.stopCaching(for: [asset], targetSize: imageSize)
                }
            }
    }

    private func select(asset: PhotoAsset) async {
        _ = await cache.requestImage(for: asset, targetSize: .init(width: 1024, height: 1024)) { result in
            Task {
                if let result {
                    self.image = result.image
                }
            }
        }
        dismiss()
    }
}
