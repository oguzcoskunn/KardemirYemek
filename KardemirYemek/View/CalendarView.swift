//
//  CalendarView.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 10.04.2022.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel = MealViewModel()
    @State private var date: Date = Date()
    @State var text: String = ""
    @State var selectedFilter: MealTimesOptions = .kahvalti
    
    @ObservedObject var monitor = NetworkMonitor()
    
    var body: some View {
        ScrollView {
            VStack {
                NetworkControlView()
                
                FilterButtonView(selectedOption: $selectedFilter)
                    .padding(.top, 30)
                
                VStack(spacing:5) {
                    Text(DateFormatter.displayDateDetail.string(from: date))
                        .font(.system(size: 18, weight: .heavy, design: .default))
                    Text(DateFormatter.displayDay.string(from: date))
                        .font(.system(size: 16, weight: .bold, design: .default))
                    Text("(\(selectedFilter.title))")
                        .padding(.top, 1)
                        .font(.system(size: 16, weight: .bold, design: .default))
                    
                    Text(viewModel.currentMealText)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5.0)
                        .padding(.top, 10)
                }.padding(.top, 20)
                
                Divider()
                    .padding(.top, 30)
                
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale.init(identifier: "tr"))
                .padding(20)
            }
            .onChange(of: selectedFilter) { _ in
                self.fetchMeals()
            }
            .onChange(of: date) { _ in
                self.fetchMeals()
            }
            .onAppear {
                self.fetchMeals()
            }
        }
        .padding(.top, 80)
        .background(Image("background").resizable().scaledToFill())
        .edgesIgnoringSafeArea(.all)
        
    }
    
    func fetchMeals() {
        let dateInformation = "\(selectedFilter.value)-\(DateFormatter.displayDate.string(from: date))"
        let monthName = DateFormatter.displayMonthName.string(from: date)
        viewModel.fetchMeals(dateInformation: dateInformation, monthName: monthName)
    }
}
