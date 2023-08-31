//
//  MultiScanResultViewController.swift
//  ScanbotDocumentSDKUseCasesDemo
//
//  Created by Rana Sohaib on 29.08.23.
//

import ScanbotSDK

final class MultiScanResultViewController: UIViewController {
    
    var document: SBSDKUIDocument!
    
    @IBOutlet private var exportButton: UIButton!
    @IBOutlet private var collectionView: UICollectionView!
    
    // Apply Filter
    @IBAction private func filterButtonTapped(_ sender: UIButton) {
        let filterListViewController = FilterListViewController.make()
        
        // Filter selection callback handler
        filterListViewController.selectedFilter = { [weak self] selectedFilter in
            
            let numberOfPages = self?.document.numberOfPages() ?? 0
            (0..<numberOfPages).forEach { index in
                self?.document.page(at: index)?.filter = selectedFilter
            }
            self?.collectionView.reloadData()
        }
        
        navigationController?.present(filterListViewController, animated: true)
    }
    
    // Export
    @IBAction private func exportButtonTapped(_ sender: UIButton) {
        showExportDialogue(sender)
    }
}

extension MultiScanResultViewController {
    
    // Export to PDF
    private func exportPDF() {
        
        // Set the name and path for the pdf file
        let name = "ScanbotSDK_PDF_Example.pdf"
        let pdfURL = SBSDKStorageLocation.applicationDocumentsFolderURL().appendingPathComponent(name)
        
        var error: Error?
        
        // Renders the document into a PDF at the specified file url
        error = SBSDKUIPDFRenderer.renderDocument(document,
                                                  with: .auto,
                                                  output: pdfURL)
        if error == nil {
            
            // Present the share screen
            share(url: pdfURL)
        } else {
            print(error as Any)
        }
    }
    
    // Export to TIFF
    private func exportTIFF() {
        
        // Set the name and path for the tiff file
        let name = "ScanbotSDK_TIFF_Example.tiff"
        let fileURL = SBSDKStorageLocation.applicationDocumentsFolderURL().appendingPathComponent(name)
        
        // Get the cropped images of all the pages of the document
        let images = (0..<document.numberOfPages()).compactMap { document.page(at: $0)?.documentImage() }
        let result = SBSDKTIFFImageWriter.writeTIFF(images,
                                                    fileURL: fileURL,
                                                    parameters: SBSDKTIFFImageWriterParameters.default())
        if result == true {
            
            // Present the share screen if file is successfully written
            share(url: fileURL)
        }
    }
}

extension MultiScanResultViewController {
    
    // To show export dialogue
    private func showExportDialogue(_ sourceButton: UIButton) {
        
        let alertController = UIAlertController(title: "Export Document",
                                                message: nil,
                                                preferredStyle: .alert)
        
        let pdfAction = UIAlertAction(title: "Export to PDF", style: .default) { _ in self.exportPDF() }
        let tiffAction = UIAlertAction(title: "Export to TIFF", style: .default) { _ in self.exportTIFF() }
        let cancelActon = UIAlertAction(title: "Cancel", style: .cancel)
        
        let actions = [pdfAction, tiffAction, cancelActon]
        actions.forEach { alertController.addAction($0) }
        
        self.present(alertController, animated: true)
    }
    
    // To show activity (share) screen
    private func share(url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url],
                                                              applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = exportButton
        }
        present(activityViewController, animated: true)
    }
}

extension MultiScanResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return document.numberOfPages()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiScanResultCollectionViewCell",
                                                      for: indexPath) as! MultiScanResultCollectionViewCell
        let pageImage = document.page(at: indexPath.row)?.documentImage()
        cell.resultImageView.image = pageImage
        return cell
    }
}

extension MultiScanResultViewController {
    static func make(with document: SBSDKUIDocument) -> MultiScanResultViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultViewController = storyboard.instantiateViewController(identifier: "MultiScanResultViewController") as! MultiScanResultViewController
        resultViewController.document = document
        return resultViewController
    }
}
