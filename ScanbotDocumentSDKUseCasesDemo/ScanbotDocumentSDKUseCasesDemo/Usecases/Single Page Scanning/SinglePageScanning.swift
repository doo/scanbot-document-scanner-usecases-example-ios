//
//  SinglePageScanning.swift
//  Scanbot Document Usecases
//
//  Created by Rana Sohaib on 24.08.23.
//

import ScanbotSDK

final class SinglePageScanning: NSObject {
        
    private static var delegateHandler: SinglePageScanningHandler?
    
    static func present(on parent: UIViewController) {
        
        let configuration = SBSDKUIDocumentScannerConfiguration.default()
        
        configuration.behaviorConfiguration.isMultiPageEnabled = false
        configuration.behaviorConfiguration.isAutoSnappingEnabled = true
        
        configuration.uiConfiguration.isMultiPageButtonHidden = true
        configuration.uiConfiguration.isAutoSnappingButtonHidden = true
        
        delegateHandler = SinglePageScanningHandler()
        delegateHandler?.presenter = parent
        
        SBSDKUIDocumentScannerViewController.present(on: parent,
                                                     with: configuration,
                                                     andDelegate: delegateHandler)
    }
}
