//
//  Unit.swift
//  NewWorldSocial
//
//  Created by Oğuz Coşkun on 30.09.2021.
//

import Foundation

enum AdUnit {
    
    case homeBanner
    
    // You should return your ad unit IDs here
    var unitID: String {
        switch self {
        case .homeBanner: return ""
        }
    }
}
