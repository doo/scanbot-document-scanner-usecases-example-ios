//
//  DetectionOnImageViewController.swift
//  Scanbot Document Usecases
//
//  Created by Rana Sohaib on 24.08.23.
//

import PhotosUI
import ScanbotSDK

final class DetectionOnImageViewController: UIViewController {
    
    @IBOutlet private var uploadImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImageButton.layer.cornerRadius = 8
    }
    
    private func showResult(for pickedImages: [UIImage]) {
        
        // If only one image is picked
        if pickedImages.count == 1,
            let image = pickedImages.first {
            
            // Create a document page by passing the image
            // You can pass the polygon of the area where the document is located within the pages image
            // You can also pass the type of the filter you want to apple on the page
            let page = SBSDKUIPage(image: image, polygon: nil, filter: SBSDKImageFilterTypeNone)
            
            // Detect a document on the page and check if the detection was successful
            guard let result = page.detectDocument(true), result.isDetectionStatusOK else { return }
            
            // Set the detected polygon on the document page
            page.polygon = result.polygon
            
            // Create an instance of a document
            let document = SBSDKUIDocument()
            
            // Insert the page in the document
            document.insert(page, at: 0)
            
            // Process the document
            let resultViewController = SingleScanResultViewController.make(with: document)
            self.navigationController?.pushViewController(resultViewController, animated: true)
            
            
        // If multiple images are picked
        } else if pickedImages.count > 1 {
            
            // Make an instance of the document
            let document = SBSDKUIDocument()
            
            // Iterate over multiple picked images
            pickedImages.forEach { image in
                
                // Create a document page by passing the image
                // You can pass the polygon of the area where the document is located within the pages image
                // You can also pass the type of the filter you want to apple on the page
                let page = SBSDKUIPage(image: image, polygon: nil, filter: SBSDKImageFilterTypeNone)
                
                // Detect a document on the page and check if the detection was successful
                guard let result = page.detectDocument(true), result.isDetectionStatusOK else { return }
                
                // Set the detected polygon on the document page
                page.polygon = result.polygon
                
                // Insert the page in the document
                document.insert(page, at: document.numberOfPages())
            }
            
            // Process the document
            let resultViewController = MultiScanResultViewController.make(with: document)
            self.navigationController?.pushViewController(resultViewController, animated: true)
        }
    }
}

extension DetectionOnImageViewController {
    
    @IBAction private func uploadImageButtonTapped(_ sender: UIButton) {
        
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
