//
//  ContentView.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 9.04.2022.
//

import SwiftUI
import ToastSwiftUI

struct AdminView: View {
    @ObservedObject var viewModel = MealViewModel()
    @State private var date: Date = Date()
    @State var text: String = ""
    @State var selectedFilter: MealTimesOptions = .kahvalti
    @State var editMode = false
    
    @State private var savedToast: Bool = false
    
    @ObservedObject var monitor = NetworkMonitor()
    
    var body: some View {
        ScrollView {
            VStack {
                NetworkControlView()
                
                FilterButtonView(selectedOption: $selectedFilter)
                    .padding(.top, 30)
                
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button {
                                if self.editMode {
                                    self.editMode = false
                                } else {
                                    self.editMode = true
                                }
                            } label: {
                                Text(self.editMode ? "İptal" : "Düzenle")
                                    .font(.system(size: 13))
                                    .frame(width: 80, height: 30)
                                    .background(monitor.isConnected ? Color.green : Color.gray)
                                    .foregroundColor(.black)
                            }
                            .cornerRadius(20)
                            .disabled(monitor.isConnected ? false : true)
                        }
                        .padding(.trailing, 40)
                        
                        Text(DateFormatter.displayDateDetail.string(from: date))
                            .font(.system(size: 18, weight: .heavy, design: .default))
                        Text(DateFormatter.displayDay.string(from: date))
                            .font(.system(size: 16, weight: .bold, design: .default))
                        Text("(\(selectedFilter.title))")
                            .padding(.top, 1)
                            .font(.system(size: 16, weight: .bold, design: .default))
                        
                        if editMode {
                            FocusedTextEditorView(text: $text, height: 150)
                        } else {
                            Text(viewModel.currentMealText)
                                .font(.system(size: 16))
                                .multilineTextAlignment(.center)
                                .lineSpacing(5.0)
                                .padding(.top, 10)
                        }
                        
                    }
                        .padding(.top, 20)
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
                            .font(.system(size: 13))
                            .frame(width: 80, height: 30)
                            .background(monitor.isConnected ? Color.green : Color.gray)
                            .foregroundColor(.black)
                    })
                    .disabled(monitor.isConnected ? false : true)
                    .cornerRadius(20)
                }
                
                Divider()
                    .padding(.top, 30)
                
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .environment(\.locale, Locale.init(identifier: "tr"))
                .datePickerStyle(.graphical)
                .padding(20)
            }
            .onChange(of: selectedFilter) { _ in
                fetchMeals()
                self.editMode = false
            }
            .onChange(of: date) { _ in
                fetchMeals()
                self.editMode = false
            }
            .onChange(of: editMode) { _ in
                self.text = ""
            }
            .onAppear {
                self.fetchMeals()
            }
            
        }
        .padding(.top, 80)
        .toast(isPresenting: $savedToast, message: "Yemekler Kaydedildi!", icon: .success, backgroundColor: Color.green, autoDismiss: .after(2))
        .background(Image("background").resizable().scaledToFill())
        .edgesIgnoringSafeArea(.all)
        
    }
    
    func fetchMeals() {
        let dateInformation = "\(selectedFilter.value)-\(DateFormatter.displayDate.string(from: date))"
        let monthName = DateFormatter.displayMonthName.string(from: date)
        viewModel.fetchMeals(dateInformation: dateInformation, monthName: monthName)
    }
}


