//
//  SingleScanResultViewController.swift
//  ScanbotDocumentSDKUseCasesDemo
//
//  Created by Rana Sohaib on 24.08.23.
//

import ScanbotSDK

final class SingleScanResultViewController: UIViewController {
    
    @IBOutlet private var blurLabel: UILabel!
    @IBOutlet private var singlePageImageView: UIImageView!
    @IBOutlet private var exportButton: UIButton!
    
    var document: SBSDKUIDocument!
    private var page: SBSDKUIPage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        page = document.page(at: 0)
        singlePageImageView.image = page.documentImage()
    }
    
    @IBAction private func doneButtonPressed(_sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // Apply Filter
    @IBAction private func filterButtonPressed(_ sender: UIButton) {
        let filterListViewController = FilterListViewController.make()
        filterListViewController.selectedFilter = { [weak self] selectedFilter in
            self?.page.filter = selectedFilter
            self?.singlePageImageView.image = self?.page.documentImage()
        }
        navigationController?.present(filterListViewController, animated: true)
    }
    
    // Manual Cropping
    @IBAction private func manualCropButtonPressed(_ sender: UIButton) {
        
        let configuration = SBSDKUICroppingScreenConfiguration.default()
        
        SBSDKUICroppingViewController.present(on: self,
                                              with: page,
                                              with: configuration,
                                              andDelegate: self)
    }
    
    // Blur Estimate
    @IBAction private func detectBlurButtonPressed(_ sender: UIButton) {
        
        guard let documentPageImage = document.page(at: 0)?.documentImage() else { return }
        
        let blurEstimator = SBSDKBlurrinessEstimator()
        let blurEstimate = blurEstimator.estimateImageBlurriness(documentPageImage)
        
        blurLabel.text = "Blur estimate: \(round(blurEstimate * 100)/100)"
    }
    
    // Export
    @IBAction private func exportButtonPressed(_ sender: UIButton) {
        showExportDialogue(sender)
    }
    
    // Export to PNG
    func exportPNG() {
        let name = "ScanbotSDK_PNG_Example.png"
        let pngURL = SBSDKStorageLocation.applicationDocumentsFolderURL().appendingPathComponent(name)
        
        guard let pngData = document.page(at: 0)?.documentImage()?.pngData() else { return }
        
        do {
            try pngData.write(to: pngURL)
        }
        catch {
            print(error)
        }
        
        share(url: pngURL)
    }
    
    // Export to JPG
    func exportJPG() {
        let name = "ScanbotSDK_JPG_Example.jpg"
        let jpgURL = SBSDKStorageLocation.applicationDocumentsFolderURL().appendingPathComponent(name)
        
        guard let jpgData = document.page(at: 0)?.documentImage()?.jpegData(compressionQuality: 0.8) else { return }
        
        do {
            try jpgData.write(to: jpgURL)
        }
        catch {
            print(error)
        }
        
        share(url: jpgURL)
    }
    
    // Export to PDF
    func exportPDF() {
        let name = "ScanbotSDK_PDF_Example.pdf"
        let pdfURL = SBSDKStorageLocation.applicationDocumentsFolderURL().appendingPathComponent(name)
        
        var error: Error?
        error = SBSDKUIPDFRenderer.renderDocument(document,
                                                  with: .auto,
                                                  output: pdfURL)
        if error == nil {
            share(url: pdfURL)
        } else {
            print(error as Any)
        }
    }
    
    // Export to TIFF
    func exportTIFF() {
        
        let name = "ScanbotSDK_TIFF_Example.tiff"
        let fileURL = SBSDKStorageLocation.applicationDocumentsFolderURL().appendingPathComponent(name)
        
        let images = (0..<document.numberOfPages()).compactMap { document.page(at: $0)?.documentImage() }
        let result = SBSDKTIFFImageWriter.writeTIFF(images,
                                                    fileURL: fileURL,
                                                    parameters: SBSDKTIFFImageWriterParameters.default())
        if result == true {
            share(url: fileURL)
        }
    }
}

extension SingleScanResultViewController: SBSDKUICroppingViewControllerDelegate {
    
    func croppingViewController(_ viewController: SBSDKUICroppingViewController,
                                didFinish changedPage: SBSDKUIPage) {
        self.page = changedPage
        self.singlePageImageView.image = changedPage.documentImage()
    }
}

extension SingleScanResultViewController {
    
    private func showExportDialogue(_ sourceButton: UIButton) {
        
        let alertController = UIAlertController(title: "Export Document",
                                                 message: nil,
                                                 preferredStyle: .alert)
        
        let pngAction = UIAlertAction(title: "Export to PNG", style: .default) { _ in self.exportPNG() }
        let jpgAction = UIAlertAction(title: "Export to JPG", style: .default) { _ in self.exportJPG() }
        let pdfAction = UIAlertAction(title: "Export to PDF", style: .default) { _ in self.exportPDF() }
        let tiffAction = UIAlertAction(title: "Export to TIFF", style: .default) { _ in self.exportTIFF() }
        let cancelActon = UIAlertAction(title: "Cancel", style: .cancel)
        
        let actions = [pngAction, jpgAction, pdfAction, tiffAction, cancelActon]
        actions.forEach { alertController.addAction($0) }
        
        self.present(alertController, animated: true)
    }
    
    private func share(url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url],
                                                              applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceItem = exportButton
        }
        present(activityViewController, animated: true)
    }
}

extension SingleScanResultViewController {
    static func make(with document: SBSDKUIDocument) -> SingleScanResultViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultViewController = storyboard.instantiateViewController(withIdentifier: "SingleScanResultViewController")
        as! SingleScanResultViewController
        resultViewController.document = document
        return resultViewController
    }
}
