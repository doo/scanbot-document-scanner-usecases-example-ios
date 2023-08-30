//
//  MultiScanResultViewController.swift
//  ScanbotDocumentSDKUseCasesDemo
//
//  Created by Rana Sohaib on 29.08.23.
//

import ScanbotSDK

class MultiScanResultViewController: UIViewController {
    
    var document: SBSDKUIDocument!
    
    @IBOutlet private var exportButton: UIButton!
    @IBOutlet private var collectionView: UICollectionView!
    
    // Apply Filter
    @IBAction private func filterButtonPressed(_ sender: UIButton) {
        let filterListViewController = FilterListViewController.make()
        
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
    @IBAction private func exportButtonPressed(_ sender: UIButton) {
        showExportDialogue(sender)
    }
}

extension MultiScanResultViewController {
    
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

extension MultiScanResultViewController {
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiScanResultCollectionViewCell", for: indexPath) as! MultiScanResultCollectionViewCell
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
