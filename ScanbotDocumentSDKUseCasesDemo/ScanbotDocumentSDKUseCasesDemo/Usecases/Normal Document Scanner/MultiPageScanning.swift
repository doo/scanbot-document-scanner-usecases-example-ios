//
//  NormalDocumentScanning.swift
//  Scanbot Document Usecases
//
//  Created by Rana Sohaib on 24.08.23.
//

import ScanbotSDK

final class NormalDocumentScanning: NSObject, SBSDKUIDocumentScannerViewControllerDelegate {
    
    // The view controller on which the scanner is presented on
    private var presenter: UIViewController?
    
    init(presenter: UIViewController? = nil) {
        self.presenter = presenter
    }
    
    // The scanner view controller calls this delegate method when it has scanned document pages
    // and the scanner view controller has been dismissed
    func scanningViewController(_ viewController: SBSDKUIDocumentScannerViewController,
                                didFinishWith document: SBSDKUIDocument) {
        
        // Process the document
        let resultViewController = MultiScanResultViewController.make(with: document)
        presenter?.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    // The scanner view controller calls this delegate method to inform that it has been cancelled and dismissed
    func scanningViewControllerDidCancel(_ viewController: SBSDKUIDocumentScannerViewController) {
        
    }
}

extension NormalDocumentScanning {
    
    // To hold an instance of the delegate handler
    private static var delegateHandler: NormalDocumentScanning?
    
    static func present(presenter: UIViewController) {
        
        // Initialize delegate handler
        delegateHandler = NormalDocumentScanning(presenter: presenter)
        
        // Initialize document scanner configuration object using default configurations
        let configuration = SBSDKUIDocumentScannerConfiguration.default()
        
        // Enable the multi page behavior
        configuration.behaviorConfiguration.isMultiPageEnabled = true
        
        // Enable Auto Snapping behavior
        configuration.behaviorConfiguration.isAutoSnappingEnabled = true
        
        // Hide the multi page behavior enable/disable button
        configuration.uiConfiguration.isMultiPageButtonHidden = true
        
        // Hide the auto snapping enable/disable button
        configuration.uiConfiguration.isAutoSnappingButtonHidden = true
        
        // Present the document scanner on the presenter (presenter in our case is the UsecasesListTableViewController)
        SBSDKUIDocumentScannerViewController.present(on: presenter,
                                                     with: configuration,
                                                     andDelegate: delegateHandler)
    }
}
