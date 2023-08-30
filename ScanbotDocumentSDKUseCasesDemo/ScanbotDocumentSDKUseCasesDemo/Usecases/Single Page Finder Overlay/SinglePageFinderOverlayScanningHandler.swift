//
//  SinglePageFinderOverlayScanningHandler.swift
//  ScanbotDocumentSDKUseCasesDemo
//
//  Created by Rana Sohaib on 30.08.23.
//

import ScanbotSDK

final class SinglePageFinderOverlayScanningHandler: NSObject, SBSDKUIFinderDocumentScannerViewControllerDelegate {
    
    var presenter: UIViewController?
    
    func finderScanningViewController(_ viewController: SBSDKUIFinderDocumentScannerViewController,
                                didFinishWith document: SBSDKUIDocument) {
        
        let resultViewController = SingleScanResultViewController.make(with: document)
        presenter?.navigationController?.pushViewController(resultViewController, animated: true)
    }
}
