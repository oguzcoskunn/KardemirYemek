//
//  NextDayViewModel.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 10.04.2022.
//

import SwiftUI


class MoveDaysViewModel: ObservableObject {
    @Published var currentDate = Date()
    
    func getNextDay(comingDate: Date) {
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let theCalendar = Calendar.current
        if let nextDate = theCalendar.date(byAdding: dayComponent, to: comingDate) {
            self.currentDate = nextDate
        }
        
    }
    
    func getPrevDay(comingDate: Date) {
        var dayComponent = DateComponents()
        dayComponent.day = -1
        let theCalendar = Calendar.current
        if let nextDate = theCalendar.date(byAdding: dayComponent, to: comingDate) {
            self.currentDate = nextDate
        }
        
    }
}
