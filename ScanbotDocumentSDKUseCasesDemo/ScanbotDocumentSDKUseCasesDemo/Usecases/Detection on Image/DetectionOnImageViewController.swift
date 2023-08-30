//
//  DetectionOnImageViewController.swift
//  Scanbot Document Usecases
//
//  Created by Rana Sohaib on 24.08.23.
//

import PhotosUI
import ScanbotSDK

class DetectionOnImageViewController: UIViewController {
    
    private func showResult(for pickedImages: [UIImage]) {
        
        // If only one image is picked
        if pickedImages.count == 1,
            let image = pickedImages.first {
            
            let page = SBSDKUIPage(image: image, polygon: nil, filter: SBSDKImageFilterTypeNone)
            
            guard let result = page.detectDocument(true), result.isDetectionStatusOK
            else { return }
            
            let document = SBSDKUIDocument()
            
            document.insert(page, at: 0)
            
            let resultViewController = SingleScanResultViewController.make(with: document)
            self.navigationController?.pushViewController(resultViewController, animated: true)
            
        // If multiple images are picked
        } else if pickedImages.count > 1 {
            
            let document = SBSDKUIDocument()
            
            pickedImages.forEach { image in
                
                let page = SBSDKUIPage(image: image, polygon: nil, filter: SBSDKImageFilterTypeNone)
                
                guard let result = page.detectDocument(true), result.isDetectionStatusOK else { return }
                
                document.insert(page, at: document.numberOfPages())
            }
            
            let resultViewController = MultiScanResultViewController.make(with: document)
            self.navigationController?.pushViewController(resultViewController, animated: true)
        }
    }
}

extension DetectionOnImageViewController {
    
    @IBAction private func uploadImage(_ sender: UIButton) {
        
        if #available(iOS 14.0, *) {
            
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 0
            configuration.filter = .images
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            
            self.present(picker, animated: true)
            
        } else {
            
            let picker = UIImagePickerController()
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }
}

// Image Picker for iOS 14 and above
@available(iOS 14.0, *)
extension DetectionOnImageViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        var pickedImages = [UIImage]()
        
        let dispatchGroup = DispatchGroup()
        
        results.forEach { result in
            
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                
                dispatchGroup.enter()
                
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    
                    if let image = image as? UIImage {
                        pickedImages.append(image)
                    }
                    
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.showResult(for: pickedImages)
        }
    }
}

// Image picker for iOS 13
extension DetectionOnImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        self.showResult(for: [image])
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension DetectionOnImageViewController {
    static func make() -> DetectionOnImageViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController  = storyboard.instantiateViewController(identifier: "DetectionOnImageViewController")
        as! DetectionOnImageViewController
        return viewController
    }
}
