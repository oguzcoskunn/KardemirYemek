//
//  MainPageView.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 10.04.2022.
//

import SwiftUI
import ToastSwiftUI

struct MainPageView: View {
    @ObservedObject var viewModel = MoveDaysViewModel()
    @ObservedObject var mealViewModel = MealViewModel()
    @ObservedObject var monitor = NetworkMonitor()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var selectedFilter: MealTimesOptions = .kahvalti
    @State var text = ""
    @State var editMode = false
    @State var saveAnnounce = false
    
    @State var value: CGFloat = 0
    
    
    var body: some View {
        NavigationView {
                VStack {
                    NetworkControlView()
                    
                    FilterButtonView(selectedOption: $selectedFilter)
                        .padding(.top, 30)

                    ScrollView {
                        VStack(spacing: 5) {
                            Text(DateFormatter.displayDateDetail.string(from: viewModel.currentDate))
                                .font(.system(size: 18, weight: .heavy, design: .rounded))
                            Text(DateFormatter.displayDay.string(from: viewModel.currentDate))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                            Text("(\(selectedFilter.title))")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                            Text(mealViewModel.currentMealText)
                                .font(.system(size: 16, design: .serif))
                                .multilineTextAlignment(.center)
                                .lineSpacing(5.0)
                                .padding(.top, 10)
                            
                        }
                    }.padding(.top, 20)
                    
                    Spacer()
                    
                    BannerVC()
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 60, alignment: .center)
                    
                    HStack {
                        Button {
                            viewModel.getPrevDay(comingDate: viewModel.currentDate)
                        } label: {
                            Image(systemName: "arrowshape.turn.up.left.fill")
                                .font(.system(size: 40))
                        }
                        
                        Spacer()
                        
                        VStack {
                            if DateFormatter.displayDate.string(from: viewModel.currentDate) != DateFormatter.displayDate.string(from: Date())
                            {
                                Button {
                                    viewModel.currentDate = Date()
                                } label: {
                                    VStack {
                                        Image(systemName: "arrow.counterclockwise.circle.fill")
                                            .font(.system(size: 40, weight: .bold, design: .default))
                                        Text("Bugüne Dön")
                                            .font(.system(size: 18, weight: .bold, design: .default))
                                    }
                                }
                            }
                        }.frame(width: 150, height: 50)
                        
                        
                        Spacer()
                        
                        Button {
                            viewModel.getNextDay(comingDate: viewModel.currentDate)
                        } label: {
                            Image(systemName: "arrowshape.turn.up.right.fill")
                                .font(.system(size: 40))
                        }
                    }
                    .foregroundColor(Color.blue)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    
                    if editMode {
                        FocusedTextEditorView(text: $text, height: 40)
                        
                    } else {
                        if !self.mealViewModel.announce.isEmpty {
                            Text("📣 \(self.mealViewModel.announce)")
                                .font(.system(size: 15, design: .rounded))
                                .frame(width: 350, height: 50)
                        }
                    }
                    
                    HStack(spacing: 30) {
                        if editMode {
                            Button(action: {
                                self.mealViewModel.setAnnounce(newAnnounce: self.text)
                                self.mealViewModel.announce = self.text
                                self.saveAnnounce.toggle()
                                self.editMode.toggle()
                            }, label: {
                                Text("Kaydet")
                                    .font(.system(size: 15))
                                    .frame(width: 90, height: 30)
                                    .background(monitor.isConnected ? Color.blue : Color.gray)
                                    .foregroundColor(.black)
                            })
                            .disabled(monitor.isConnected ? false : true)
                            .cornerRadius(20)
                        }
                        
                        if authViewModel.userSession != nil {
                            Button {
                                self.editMode.toggle()
                            } label: {
                                Text(self.editMode ? "İptal" : "Düzenle")
                                    .font(.system(size: 15))
                                    .frame(width: 80, height: 30)
                                    .background(monitor.isConnected ? Color.green : Color.gray)
                                    .foregroundColor(.black)
                            }
                            .disabled(monitor.isConnected ? false : true)
                            .cornerRadius(20)
                            
                        }
                    }
                    TabBarView()
                }
                .offset(y: -self.value)
                .animation(.easeInOut(duration: 0.5), value: self.value)
                .padding()
                .padding(.bottom, 10)
                .padding(.top, 20)
                .onChange(of: viewModel.currentDate) { _ in
                    fetchMeals()
                }
                .onChange(of: selectedFilter) { _ in
                    fetchMeals()
                }
                .onChange(of: editMode, perform: { _ in
                    self.text = ""
                })
                .toast(isPresenting: $saveAnnounce, message: "Duyuru Kaydedildi!", icon: .success, backgroundColor: Color.green, autoDismiss: .after(2))
                .navigationBarHidden(true)
                .navigationTitle("Ana Sayfa")
                .background(Image("background").resizable().scaledToFill())
                .edgesIgnoringSafeArea(.all)
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
        .gesture(DragGesture()
            .onEnded { value in
                let direction = detectDirection(value: value)
                if direction == .left {
                    viewModel.getPrevDay(comingDate: viewModel.currentDate)
                } else if direction == .right {
                    viewModel.getNextDay(comingDate: viewModel.currentDate)
                }
            }
        )
        
        
        
    }
    
    func fetchMeals() {
        let dateInformation = "\(selectedFilter.value)-\(DateFormatter.displayDate.string(from: viewModel.currentDate))"
        let monthName = DateFormatter.displayMonthName.string(from: viewModel.currentDate)
        mealViewModel.fetchMeals(dateInformation: dateInformation, monthName: monthName)
    }
}
