//
//  LazyView.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 12.04.2022.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping() -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}
