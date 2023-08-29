//
//  MultiPageScanningHandler.swift
//  ScanbotDocumentSDKUseCasesDemo
//
//  Created by Rana Sohaib on 24.08.23.
//

import ScanbotSDK

final class MultiPageScanningHandler: NSObject, SBSDKUIDocumentScannerViewControllerDelegate {
    
    var presenter: UIViewController?
    
    func scanningViewControllerDidCancel(_ viewController: SBSDKUIDocumentScannerViewController) {
        
    }
    
    func scanningViewController(_ viewController: SBSDKUIDocumentScannerViewController,
                                didFinishWith document: SBSDKUIDocument) {
        
        let resultViewController = MultiScanResultViewController.make(with: document)
        presenter?.navigationController?.pushViewController(resultViewController, animated: true)
    }
}
