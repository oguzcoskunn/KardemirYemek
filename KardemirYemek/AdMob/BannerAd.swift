//
//  BannerAd.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 30.09.2021.
//

import SwiftUI
import GoogleMobileAds
import UIKit

final class BannerVC: UIViewControllerRepresentable  {
    let unitNumber: Int
    
    init(unitNumber: Int) {
        self.unitNumber = unitNumber
    }
    
    let unitID = "ca-app-pub-9292618942784820/9612259077"

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)

        let viewController = UIViewController()
        view.adUnitID = self.unitID
        
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
