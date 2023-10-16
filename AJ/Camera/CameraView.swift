//
//  CameraView.swift
//  Camera
//
//  Created by Денис on 09.10.2023.
//

import SwiftUI

struct CameraView: View {

    @StateObject private var model = CameraViewModel()
    @State private var isLanguagesPresented: Bool = false
    @Environment(\.dismiss) private var dismiss

    private static let barHeightFactor = 0.15

    var body: some View {
        NavigationStack {
            if let image = model.translatedImage, !model.isShowOriginalPhoto {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if let image = model.originalImage, model.isShowOriginalPhoto {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        VStack {
                            HStack { Spacer () }

                            if model.isTranslating {
                                Spacer()
                                ProgressView()
                                    .controlSize(.extraLarge)
                                Spacer()
                            }
                        }
                            .background(model.isTranslating ? Color.black.opacity(0.2) : .clear)
                    )
            } else {
                GeometryReader { geometry in
                    CameraPreviewView(image: $model.preview)
                        .overlay(alignment: .bottom) {
                            buttonsView()
                                .frame(height: geometry.size.height * Self.barHeightFactor)
                                .background(.clear)
                        }
                        .overlay(alignment: .center)  {
                            Color.clear
                                .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
                        }
                }
            }
        }
        .overlay(
            VStack {
                navBar()
                Spacer()
            }
        )
        .task {
            try? await model.camera.start()
            await model.loadPhotos()
            await model.loadThumbnail()
        }
        .onDisappear {
            model.camera.stop()
        }
    }

    private func buttonsView() -> some View {
        HStack {
            Spacer()

            Button {
                model.camera.takePhoto()
            } label: {
                ZStack {
                    Circle()
                        .strokeBorder(.white, lineWidth: 3)
                        .frame(width: 62, height: 62)
                    Circle()
                        .fill(.white)
                        .frame(width: 50, height: 50)
                }
            }

            Spacer()
        }
        .padding()
        .buttonStyle(.plain)
        .overlay(
            HStack {
                if let thumbnail = model.libraryThumbnail {
                    NavigationLink {
                        LibraryView(photoCollection: model.library, image: $model.originalImage)
                    } label: {
                        ZStack {
                            Color.white
                            thumbnail
                                .resizable()
                                .scaledToFill()
                        }
                        .frame(width: 41, height: 41)
                        .cornerRadius(11)
                    }
                    .padding()
                }
                Spacer()
            }
        )
        .overlay(
            HStack {
                Spacer()

                Button {
                    model.torchIsOn.toggle()
                } label: {
                    Image(systemName: model.torchIsOn ? "flashlight.on.fill" : "flashlight.off.fill")
                        .font(.system(size: 28, weight: .bold))
                        .padding()
                        .foregroundColor(model.torchIsOn ? .black : .white)
                        .background(model.torchIsOn ? Color.white : .clear)
                        .clipShape(Circle())
                }
                .padding()
            }
        )
        .fullScreenCover(isPresented: $isLanguagesPresented) {
            LanguagesView()
        }
    }

    private func navBar() -> some View {
        HStack {
            Button(action: { dismiss() }, label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.gray)
            })
            .padding()
            .opacity(0)

            Spacer()

            HStack(spacing: 4) {
                Text(model.languages.from.flag)
                    .font(.title2)
                Image(._2)
                Text(model.languages.to.flag)
                    .font(.title2)
            }
            .onTapGesture {
                isLanguagesPresented = true
            }

            Spacer()
            
            Button(action: { dismiss() }, label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.gray)
            })
            .padding()
        }
    }
}
