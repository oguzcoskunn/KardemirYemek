//
//  AdFormat.swift
//  NewWorldSocial
//
//  Created by Oğuz Coşkun on 30.09.2021.
//

import Foundation
import GoogleMobileAds

enum AdFormat {
    
    case largeBanner
    case mediumRectangle
    case adaptiveBanner
    
    var adSize: GADAdSize {
        switch self {
        case .largeBanner: return kGADAdSizeLargeBanner
        case .mediumRectangle: return kGADAdSizeMediumRectangle
        case .adaptiveBanner: return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width)
        }
    }
    
    var size: CGSize {
        adSize.size
    }
}
