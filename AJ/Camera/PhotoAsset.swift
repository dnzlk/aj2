//
//  PhotoAsset.swift
//  Camera
//
//  Created by Денис on 09.10.2023.
//

import Photos

struct PhotoAsset: Identifiable {

    // MARK: - Types

    typealias MediaType = PHAssetMediaType

    // MARK: - Public Properties

    var id: String { identifier }
    var identifier = UUID().uuidString
    var index: Int?
    var phAsset: PHAsset?

    var mediaType: MediaType {
        phAsset?.mediaType ?? .unknown
    }

    // MARK: - Init

    init(phAsset: PHAsset, index: Int?) {
        self.phAsset = phAsset
        self.index = index
        self.identifier = phAsset.localIdentifier
    }

    init(identifier: String) {
        self.identifier = identifier
        let fetchedAssets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
        self.phAsset = fetchedAssets.firstObject
    }
}

extension PhotoAsset: Equatable {

    static func ==(lhs: PhotoAsset, rhs: PhotoAsset) -> Bool {
        (lhs.identifier == rhs.identifier)
    }
}

extension PhotoAsset: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension PHObject: Identifiable {

    public var id: String { localIdentifier }
}
