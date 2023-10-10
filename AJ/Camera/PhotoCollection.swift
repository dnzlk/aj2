//
//  PhotoCollection.swift
//  Camera
//
//  Created by Денис on 09.10.2023.
//

import Photos

final class PhotoCollection: NSObject, ObservableObject {

    // MARK: - Types

    enum E: Error {
        case loadFailed
    }

    // MARK: - Public Properties

    @Published var photoAssets: PhotoAssetCollection = PhotoAssetCollection(PHFetchResult<PHAsset>())
    let cache = CachedImageManager()

    // MARK: - Private Properties

    private var assetCollection: PHAssetCollection?

    // MARK: - Public Methods

    func load() async throws {
        let fetchOptions = PHFetchOptions()
        let collections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: fetchOptions)

        guard let assetCollection = collections.firstObject else { throw E.loadFailed }

        self.assetCollection = assetCollection
        await refreshPhotoAssets()
    }

    // MARK: - Private Methods

    private func refreshPhotoAssets(_ fetchResult: PHFetchResult<PHAsset>? = nil) async {

        var newFetchResult = fetchResult

        if newFetchResult == nil {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            if let assetCollection, let fetchResult = (PHAsset.fetchAssets(in: assetCollection, options: fetchOptions) as AnyObject?) as? PHFetchResult<PHAsset> {
                newFetchResult = fetchResult
            }
        }
        if let newFetchResult {
            await MainActor.run {
                photoAssets = PhotoAssetCollection(newFetchResult)
            }
        }
    }
}
