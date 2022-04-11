//
//  test.swift
//  NewWorldSocial
//
//  Created by Oğuz Coşkun on 30.09.2021.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

final class AdsManager: NSObject, ObservableObject {
    
    private struct AdMobConstant {
        static let interstitial1ID = "..."
        static let banner1ID = "..."
    }

    final class BannerVC: UIViewControllerRepresentable  {
        
        init(size: CGSize) {
            self.size = size
        }
        var size: CGSize

        func makeUIViewController(context: Context) -> UIViewController {
            let view = GADBannerView(adSize: GADAdSizeFromCGSize(size))
            let viewController = UIViewController()
            view.adUnitID = AdMobConstant.banner1ID
            view.rootViewController = viewController
            viewController.view.addSubview(view)
            viewController.view.frame = CGRect(origin: .zero, size: size)
            
            
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                let gadRequest = GADRequest()
                DispatchQueue.main.async {
                    gadRequest.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                }
                view.load(gadRequest)
            })
            return viewController
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
    
    final class Interstitial: NSObject, GADFullScreenContentDelegate, ObservableObject {

        private var interstitial: GADInterstitialAd?
        
        override init() {
            super.init()
            requestInterstitialAds()
        }

        func requestInterstitialAds() {
            let request = GADRequest()
            request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                GADInterstitialAd.load(withAdUnitID: AdMobConstant.interstitial1ID, request: request, completionHandler: { [self] ad, error in
                    if let error = error {
                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                        return
                    }
                    interstitial = ad
                    interstitial?.fullScreenContentDelegate = self
                })
            })
        }
        func showAd() {

            let root = UIApplication.shared.windows.last?.rootViewController
            if let fullScreenAds = interstitial {
                fullScreenAds.present(fromRootViewController: root!)
            } else {
                print("not ready")
            }
        }
        
    }
    
    
}


class AdsViewModel: ObservableObject {
    static let shared = AdsViewModel()
    @Published var interstitial = AdsManager.Interstitial()
    @Published var showInterstitial = false {
        didSet {
            if showInterstitial {
                interstitial.showAd()
                showInterstitial = false
            } else {
                interstitial.requestInterstitialAds()
            }
        }
    }
}

@main
struct YourApp: App {
    let adsVM = AdsViewModel.shared
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(adsVM)
    }
}
}
