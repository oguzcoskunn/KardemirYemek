//
//  BannerAdView.swift
//  NewWorldSocial
//
//  Created by Oğuz Coşkun on 30.09.2021.
//

import SwiftUI

struct BannerAdView: View {
    
    let adUnit: AdUnit
    let adFormat: AdFormat
    @State var adStatus: AdStatus = .loading
    
    var body: some View {
        HStack {
            if adStatus != .failure {
                BannerViewController(adUnitID: adUnit.unitID, adSize: adFormat.adSize, adStatus: $adStatus)
                    .frame(width: adFormat.size.width, height: adFormat.size.height)
            }
        }.frame(maxWidth: .infinity)
    }
}
