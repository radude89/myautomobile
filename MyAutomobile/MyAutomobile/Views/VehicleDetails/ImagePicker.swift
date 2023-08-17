//
//  ImagePicker.swift
//  MyAutomobile
//
//  Created by Radu Dan on 16.08.2023.
//

import PhotosUI
import SwiftUI

struct CameraImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: CameraImagePicker
        
        init(_ parent: CameraImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.cropRect] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
}

struct PhotoLibraryImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {

        let parent: PhotoLibraryImagePicker

        init(_ parent: PhotoLibraryImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    if let uiImage = image as? UIImage {
                        self.parent.selectedImage = uiImage
                    }
                }
            }
        }
    }
}
