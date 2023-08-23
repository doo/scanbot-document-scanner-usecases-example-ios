//
//  SinglePageScanning.swift
//  Scanbot Document Usecases
//
//  Created by Rana Sohaib on 24.08.23.
//

import UIKit
import ScanbotDocumentScannerSDK

final class SinglePageScanning: NSObject {
        
    private static var delegateHandler: SinglePageScanningHandler?
    
    static func present(on parent: UIViewController) {
        
        let configuration = SBSDKUIDocumentScannerConfiguration.default()
        configuration.behaviorConfiguration.isMultiPageEnabled = false
        configuration.uiConfiguration.isMultiPageButtonHidden = true
        configuration.uiConfiguration.isAutoSnappingButtonHidden = true
        
        delegateHandler = SinglePageScanningHandler()
        
        SBSDKUIDocumentScannerViewController.present(on: parent,
                                                     with: configuration,
                                                     andDelegate: delegateHandler)
    }
}
