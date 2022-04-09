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
    @State var text: String = ""
    @State var selectedFilter: MealTimesOptions = .ogle
    @State var editMode = false
    
    @State private var savedToast: Bool = false
    
    @State var value: CGFloat = 0
    
    @ObservedObject var monitor = NetworkMonitor()
    
    enum FocusField: Hashable {
        case field
      }

      @FocusState private var focusedField: FocusField?
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ScrollView {
            VStack {
                NetworkControlView()
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
                                        } else {
                                            self.editMode = true
                                        }
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                            .foregroundColor(monitor.isConnected ? Color.red : Color.gray)
                                            .font(.system(size: 18, weight: .bold, design: .default))
                                    }.disabled(monitor.isConnected ? false : true)
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
                                    TextEditor(text: $text)
                                        .font(.system(size: 15))
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(5.0)
                                        .focused($focusedField, equals: .field)
                                                  .onAppear {
                                                    self.focusedField = .field
                                                }
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
                            .background(monitor.isConnected ? Color.green : Color.gray)
                            .foregroundColor(.black)
                    })
                    .disabled(monitor.isConnected ? false : true)
                    .cornerRadius(20)
                }
                
                
                
                Spacer()
            }
            
            .offset(y: -self.value)
            .animation(.easeInOut(duration: 0.5), value: self.value)
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
                self.text = ""
            }
            
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { noti in
                let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                
                self.value = height-20
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { noti in
                self.value = 0
            }
        }
        .toast(isPresenting: $savedToast, message: "Yemekler Kaydedildi!", icon: .success, backgroundColor: Color.green, autoDismiss: .after(2))
        
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
    
    static let displayDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    static let displayMonthName: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }()
}
