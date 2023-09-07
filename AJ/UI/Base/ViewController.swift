//
//  ViewController.swift
//  texy
//
//  Created by Denis Khabarov on 25.11.2022.
//

import Photos
import SafariServices
import UIKit

class _ViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        bind()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func bind() {}
}

extension _ViewController {

    func openBrowser(url: URL) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
    }
}

// MARK: - Image saving

extension _ViewController {

    func saveImageToLibrary(_ image: UIImage?) {
        guard let image else { return }

        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized:
            saveImage(image: image)
        case .denied, .restricted :
            showAllowAccessToLibraryAlert()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self?.saveImage(image: image)
                    }
                case .denied, .restricted:
                    DispatchQueue.main.async {
                        self?.showAllowAccessToLibraryAlert()
                    }
                default:
                    break
                }
            }
        default:
            break
        }
    }

    private func saveImage(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        showImageSavedAlert()
    }

    private func showAllowAccessToLibraryAlert() {
        let alert = UIAlertController(title: nil, message: "Allow us to save photos on your phone", preferredStyle: .alert)
        alert.addAction(.init(title: "Open settings", style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {  return }

             if UIApplication.shared.canOpenURL(settingsUrl) {
                 UIApplication.shared.open(settingsUrl)
             }
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func showImageSavedAlert() {
        let alert = UIAlertController(title: nil, message: "Image saved", preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - Share

extension _ViewController {

    func share(items: [Any]) {
        let activityViewController = UIActivityViewController(activityItems: items , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true)
    }
}
