//
//  CustomSecureFieldView.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 10.04.2022.
//

import SwiftUI

struct CustomSecureField: View {
    @Binding var text: String
    let placeholder: Text
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .foregroundColor(.black)
                    .padding(.leading, 40)
            }
            
            HStack(spacing: 16) {
                Image(systemName: "lock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.black)
                
                SecureField("", text: $text)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(Color.gray)
        .cornerRadius(10)
    }
}
