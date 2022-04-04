//
//  Camera.swift
//  
//
//  Created by Alessandro Di Maio on 04/04/22.
//

import SwiftUI

@available(iOS 14.0, macCatalyst 14.0, *)
struct Camera: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    @Binding var isPresented: Bool
    @Binding var image: UIImage?
    let device: UIImagePickerController.CameraDevice
    let flashMode: UIImagePickerController.CameraFlashMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let viewController = UIImagePickerController()
        viewController.sourceType = .camera
        viewController.delegate = context.coordinator
        viewController.cameraDevice = device
        viewController.cameraFlashMode = flashMode
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

@available(iOS 14.0, macCatalyst 14.0, *)
extension Camera {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: Camera
        
        init(_ parent: Camera) {
            self.parent = parent
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            guard let image = info[.originalImage] as? UIImage else { return }
            self.parent.image = image
            self.parent.isPresented = false
        }
    }
}
