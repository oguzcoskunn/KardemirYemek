//
//  KardemirYemekApp.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 9.04.2022.
//

import SwiftUI
import Firebase
import FirebaseAnalytics
import GoogleMobileAds

@main
struct KardemirYemekApp: App {
    init() {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    var body: some Scene {
        WindowGroup {
            MainPageView()
                .environmentObject(AuthViewModel.shared)
        }
    }
}
