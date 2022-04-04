//
//  PhotoPicker.swift
//
//  Created by Alessandro Di Maio on 03/04/22.
//

import SwiftUI
import PhotosUI

@available(iOS 14.0, macCatalyst 14.0, *)
struct PhotoPicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PHPickerViewController
    @Binding var isPresented: Bool
    @Binding var images: [UIImage]
    let limit: Int
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = limit
        
        let viewController = PHPickerViewController(configuration: configuration)
        viewController.delegate = context.coordinator
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

@available(iOS 14.0, macCatalyst 14.0, *)
extension PhotoPicker {
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        private func save(results items: [NSItemProvider]) {
            for item in items {
                if item.canLoadObject(ofClass: UIImage.self) {
                    item.loadObject(ofClass: UIImage.self) { image, error in
                        DispatchQueue.main.async {
                            if let image = image as? UIImage, error == nil {
                                self.parent.images.append(image)
                            }
                        }
                    }
                }
            }
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isPresented = false
            save(results: results.map(\.itemProvider))
        }
    }
}
