//
//  KardemirYemekApp.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 9.04.2022.
//

import SwiftUI
import Firebase

@main
struct KardemirYemekApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
