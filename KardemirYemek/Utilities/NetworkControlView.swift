//
//  NetworkControlView.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 10.04.2022.
//

import SwiftUI

struct NetworkControlView: View {
    @ObservedObject var monitor = NetworkMonitor()
    
    var body: some View {
        if !monitor.isConnected {
            Group {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 56))
                    .foregroundColor(Color.red)
                Text("İnternet bağlantınız bulunmuyor!")
                    .padding()
            }.padding(.top, 20)
        }
    }
}

