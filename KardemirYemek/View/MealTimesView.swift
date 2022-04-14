//
//  MealTimes.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 9.04.2022.
//

import SwiftUI

enum MealTimesOptions: Int, CaseIterable {
    case kahvalti
    case ogle
    case kumanya
    
    var title: String {
        switch self {
        
        case .kahvalti: return "Kahvaltı"
        case .ogle: return "Öğle"
        case .kumanya: return "Kumanya"
        }
    }
    
    var value: Int {
        switch self {
        
        case .kahvalti: return 0
        case .ogle: return 1
        case .kumanya: return 2
        }
    }
    
}

struct FilterButtonView: View {
    @Binding var selectedOption: MealTimesOptions
    
    private let underlineWidth = UIScreen.main.bounds.width / CGFloat(MealTimesOptions.allCases.count)
    
    private var padding: CGFloat {
        let rawValue = CGFloat(selectedOption.rawValue)
        let count = CGFloat(MealTimesOptions.allCases.count)
        return ((UIScreen.main.bounds.width / count) * rawValue) + 5
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(MealTimesOptions.allCases, id: \.self) { option in
                    Button(action: {
                        self.selectedOption = option
                    }, label: {
                        Text(option.title)
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .frame(width: underlineWidth)
                            .foregroundColor(Color(.black))
                    })
                }
            }
            
            Rectangle()
                .frame(width: underlineWidth, height: 3, alignment: .center)
                .foregroundColor(Color.red)
                .padding(.leading, padding)
                .animation(.spring(), value: selectedOption)
        }
        .frame(width: UIScreen.main.bounds.width - 40)
    }
}
