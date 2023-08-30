//
//  SinglePageFinderOverlayScanning.swift
//  ScanbotDocumentSDKUseCasesDemo
//
//  Created by Rana Sohaib on 30.08.23.
//

import ScanbotSDK

final class SinglePageFinderOverlayScanning: NSObject {
        
    private static var delegateHandler: SinglePageFinderOverlayScanningHandler?
    
    static func present(on parent: UIViewController) {
        
        let configuration = SBSDKUIFinderDocumentScannerConfiguration.default()
        configuration.behaviorConfiguration.isAutoSnappingEnabled = true
        
        delegateHandler = SinglePageFinderOverlayScanningHandler()
        delegateHandler?.presenter = parent
        
        SBSDKUIFinderDocumentScannerViewController.present(on: parent,
                                                           with: configuration,
                                                           andDelegate: delegateHandler)
    }
}

