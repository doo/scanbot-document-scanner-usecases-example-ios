//
//  SinglePageScanningHandler.swift
//  ScanbotDocumentSDKUseCasesDemo
//
//  Created by Rana Sohaib on 24.08.23.
//

import ScanbotSDK

final class SinglePageScanningHandler: NSObject, SBSDKUIDocumentScannerViewControllerDelegate {
    
    var presenter: UIViewController?
    
    func scanningViewController(_ viewController: SBSDKUIDocumentScannerViewController,
                                didFinishWith document: SBSDKUIDocument) {
        
        let resultViewController = SingleScanResultViewController.make(with: document)
        presenter?.navigationController?.pushViewController(resultViewController, animated: true)
    }
}
