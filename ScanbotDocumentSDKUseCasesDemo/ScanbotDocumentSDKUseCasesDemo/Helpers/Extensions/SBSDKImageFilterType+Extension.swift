//
//  SBSDKImageFilterType+Extension.swift
//  ScanbotDocumentSDKUseCasesDemo
//
//  Created by Rana Sohaib on 24.08.23.
//

import ScanbotSDK

extension SBSDKImageFilterType {
    
    static var allFilters: [SBSDKImageFilterType] {
        [SBSDKImageFilterTypeNone,
         SBSDKImageFilterTypeColor,
         SBSDKImageFilterTypeGray,
         SBSDKImageFilterTypePureGray,
         SBSDKImageFilterTypeBinarized,
         SBSDKImageFilterTypeColorDocument,
         SBSDKImageFilterTypePureBinarized,
         SBSDKImageFilterTypeBackgroundClean,
         SBSDKImageFilterTypeBlackAndWhite,
         SBSDKImageFilterTypeOtsuBinarization,
         SBSDKImageFilterTypeDeepBinarization,
         SBSDKImageFilterTypeEdgeHighlight,
         SBSDKImageFilterTypeLowLightBinarization,
         SBSDKImageFilterTypeSensitiveBinarization]
    }
    
    var name: String {
        switch self {
        case SBSDKImageFilterTypeNone:
            return "No Filter"
        case SBSDKImageFilterTypeColor:
            return "Color"
        case SBSDKImageFilterTypeGray:
            return "Optimized greyscale"
        case SBSDKImageFilterTypeBinarized:
            return "Binarized"
        case SBSDKImageFilterTypeColorDocument:
            return "Color document"
        case SBSDKImageFilterTypePureBinarized:
            return "Pure binarized"
        case SBSDKImageFilterTypeBackgroundClean:
            return "Background clean"
        case SBSDKImageFilterTypeBlackAndWhite:
            return "Black & white"
        case SBSDKImageFilterTypeOtsuBinarization:
            return "Otsu binarization"
        case SBSDKImageFilterTypeDeepBinarization:
            return "Deep binarization"
        case SBSDKImageFilterTypeEdgeHighlight:
            return "Edge highlight"
        case SBSDKImageFilterTypeLowLightBinarization:
            return "Low light binarization"
        case SBSDKImageFilterTypeLowLightBinarization2:
            return "Low light binarization 2"
        case SBSDKImageFilterTypeSensitiveBinarization:
            return "Sensitive binarization"
        case SBSDKImageFilterTypePureGray:
            return "Pure greyscale"
        default:
            return ""
        }
    }
}
