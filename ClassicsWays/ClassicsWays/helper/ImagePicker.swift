//
//  ImagePicker.swift
//  ClassicsWays
//
//  Created by Михаил Прозорский on 13.03.2024.
//

import UIKit
class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePickerController: UIImagePickerController?
    var completion: ((UIImage, Any) -> ())?
    
    func showImagePicker(in viewController: UIViewController, completion: ( (UIImage, Any) -> ())?) {
        self.completion = completion
        imagePickerController = UIImagePickerController ()
        imagePickerController?.delegate = self
        viewController.present(imagePickerController!, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
                                [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage, let url = info[.imageURL] {
            self.completion?(image, url)
            picker.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
