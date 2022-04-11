//
//  BannerViewController.swift
//  NewWorldSocial
//
//  Created by Oğuz Coşkun on 30.09.2021.
//

import SwiftUI
import GoogleMobileAds

final class BannerViewController: UIViewControllerRepresentable  {
    
    let adUnitID: String
    let adSize: GADAdSize
    @Binding var adStatus: AdStatus
    
    init(adUnitID: String, adSize: GADAdSize, adStatus: Binding<AdStatus>) {
        self.adUnitID = adUnitID
        self.adSize = adSize
        self._adStatus = adStatus
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(bannerViewController: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        let view = GADBannerView(adSize: adSize)
        view.delegate = context.coordinator
        view.adUnitID = adUnitID
        view.rootViewController = viewController
        view.load(GADRequest())
        
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: adSize.size)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        
        var bannerViewController: BannerViewController
        
        init(bannerViewController: BannerViewController) {
            self.bannerViewController = bannerViewController
        }
        
//        func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//            bannerViewController.adStatus = .failure
//        }
        
        func adViewDidReceiveAd(_ bannerView: GADBannerView) {
            bannerViewController.adStatus = .success
        }
    }
}
