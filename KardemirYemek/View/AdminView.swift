//
//  ContentView.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 9.04.2022.
//

import SwiftUI
import ToastSwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = MealViewModel()
    @State private var date: Date = Date()
    @State var text: String = "Yeni Yemekler..."
    @State var selectedFilter: MealTimesOptions = .ogle
    @State var editMode = false
    
    @State private var savedToast: Bool = false
    @State private var editModeOn: Bool = false
    @State private var editModeOff: Bool = false
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ScrollView {
            VStack {
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                    .datePickerStyle(.graphical)
                    .padding(20)
                
                Divider()
                
                FilterButtonView(selectedOption: $selectedFilter)
                    .padding(.top, 20)
                
                ZStack {
                    Image("paper")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            VStack {
                                HStack {
                                    Spacer()
                                    
                                    Button {
                                        if self.editMode {
                                            self.editMode = false
                                            self.editModeOff = true
                                        } else {
                                            self.editMode = true
                                            self.editModeOn = true
                                        }
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                            .foregroundColor(Color.red)
                                            .font(.system(size: 18, weight: .bold, design: .default))
                                    }
                                }
                                .padding(.trailing, 40)
                                
                                Text(DateFormatter.displayDateDetail.string(from: date))
                                    .font(.system(size: 18, weight: .heavy, design: .default))
                                Text("(\(selectedFilter.title))")
                                    .padding(.top, 1)
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                
                                if editMode {
                                    TextEditor(text: $text)
                                        .font(.system(size: 15))
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(5.0)
                                } else {
                                    Text(viewModel.currentMealText)
                                        .font(.system(size: 15))
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(5.0)
                                        .padding(.top, 5)
                                    Spacer()
                                }
                                
                                
                            }
                                .padding(.leading, 20)
                                .padding(.top, 50)
                            
                            ,alignment: .center)
                }
                
                if editMode {
                    Button(action: {
                        let dateInformation = "\(selectedFilter.value)-\(DateFormatter.displayDate.string(from: date))"
                        let monthName = DateFormatter.displayMonthName.string(from: date)
                        viewModel.saveMealContent(dateInformation: dateInformation, mealDetails: text, monthName: monthName)
                        self.editMode.toggle()
                        self.savedToast.toggle()
                    }, label: {
                        Text("Kaydet")
                            .frame(width: 180, height: 40)
                            .background(Color.green)
                            .foregroundColor(.black)
                    })
                        .cornerRadius(20)
                }
                
                
                
                Spacer()
            }
            .onChange(of: selectedFilter) { newValue in
                let dateInformation = "\(selectedFilter.value)-\(DateFormatter.displayDate.string(from: date))"
                let monthName = DateFormatter.displayMonthName.string(from: date)
                viewModel.fetchMeals(dateInformation: dateInformation, monthName: monthName)
                self.editMode = false
            }
            .onChange(of: date) { newValue in
                let dateInformation = "\(selectedFilter.value)-\(DateFormatter.displayDate.string(from: date))"
                let monthName = DateFormatter.displayMonthName.string(from: date)
                viewModel.fetchMeals(dateInformation: dateInformation, monthName: monthName)
                self.editMode = false
            }
            .onChange(of: editMode) { newValue in
                self.text = "Yeni Yemekler..."
            }
        }
        .toast(isPresenting: $savedToast, message: "Yemekler Kaydedildi!", icon: .success, backgroundColor: Color.green, autoDismiss: .after(2))
        .toast(isPresenting: $editModeOn, message: "Düzenleme Açıldı!", icon: .info, backgroundColor: Color.green, autoDismiss: .after(1))
        .toast(isPresenting: $editModeOff, message: "Düzenleme Kapatıldı!", icon: .info, backgroundColor: Color.red, autoDismiss: .after(1))
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension DateFormatter {
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let displayDateDetail: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    static let displayMonthName: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
}
