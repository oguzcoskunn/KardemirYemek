//
//  MealViewModel.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 9.04.2022.
//

import Foundation
import Firebase

class MealViewModel:ObservableObject {
    
    @Published var currentMealText = ""
    @Published var announce = ""
    
    init() {
        let dateInformation = "0-\(DateFormatter.displayDate.string(from: Date()))"
        self.fetchMeals(dateInformation: dateInformation, monthName: DateFormatter.displayMonthName.string(from: Date()))
        self.getAnnounce()
    }
    
    func setAnnounce(newAnnounce: String) {
        let data = [
            "announce": newAnnounce
        ]
        Firestore.firestore().collection("announce").document("announce").setData(data) { _ in
        }
    }
    
    func getAnnounce() {
        Firestore.firestore().collection("announce").document("announce").getDocument { document, _ in
            if let data = document?.data() {
                guard let announce = data["announce"] as? String else { return }
                self.announce = announce
            } else {
                self.announce = ""
            }
            
        }
    }
    
    func saveMealContent(dateInformation: String, mealDetails: String, monthName: String) {
        let data = [
            "dateInformation": dateInformation,
            "mealDetails": mealDetails
        ]
        
        Firestore.firestore().collection(monthName).document(dateInformation).setData(data) { _ in
            self.currentMealText = mealDetails
        }
    }
    
    func fetchMeals(dateInformation: String, monthName: String) {
        self.currentMealText = "Yükleniyor..."
        Firestore.firestore().collection(monthName).document(dateInformation).getDocument { document, _ in
            if let data = document?.data() {
                guard let mealDetailData = data["mealDetails"] as? String else { return }
                self.currentMealText = mealDetailData
            } else {
                self.currentMealText = "Yemek kaydı bulunmuyor."
            }
            
        }
    }
}
