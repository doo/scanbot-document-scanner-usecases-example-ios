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
        
        let configuration = SBSDKUIDocumentScannerConfiguration()
        configuration.behaviorConfiguration.isMultiPageEnabled = true
        configuration.uiConfiguration.isMultiPageButtonHidden = true
        configuration.uiConfiguration.isAutoSnappingButtonHidden = true
        
        delegateHandler = MultiPageScanningHandler()
        
        SBSDKUIDocumentScannerViewController.present(on: parent,
                                                     with: configuration,
                                                     andDelegate: delegateHandler)
    }
}
