//
//  MultiPageScanning.swift
//  Scanbot Document Usecases
//
//  Created by Rana Sohaib on 24.08.23.
//

import ScanbotSDK

final class MultiPageScanning: NSObject {
    
    private static var delegateHandler: MultiPageScanningHandler?
    
    static func present(on parent: UIViewController) {
        
        let configuration = SBSDKUIDocumentScannerConfiguration.default()
        
        configuration.behaviorConfiguration.isMultiPageEnabled = true
        configuration.behaviorConfiguration.isAutoSnappingEnabled = true
        
        configuration.uiConfiguration.isMultiPageButtonHidden = true
        configuration.uiConfiguration.isAutoSnappingButtonHidden = true
        
        delegateHandler = MultiPageScanningHandler()
        delegateHandler?.presenter = parent
        
        SBSDKUIDocumentScannerViewController.present(on: parent,
                                                     with: configuration,
                                                     andDelegate: delegateHandler)
    }
}
