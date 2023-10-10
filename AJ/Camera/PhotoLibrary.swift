//
//  PhotoLibrary.swift
//  Camera
//
//  Created by Денис on 09.10.2023.
//

import Photos

class PhotoLibrary {

    enum E: Error {
        case denied
        case limited
    }

    static func checkAuthorization() async throws {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            return
        case .notDetermined:
            let auth = await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
            if !auth {
                throw E.denied
            }
        case .denied:
            throw E.denied
        case .limited:
            throw E.limited
        case .restricted:
            throw E.denied
        @unknown default:
            return
        }
    }
}
