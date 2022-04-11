//
//  TabBarView.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 11.04.2022.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        HStack {
            VStack {
                if authViewModel.userSession != nil {
                    Button {
                        authViewModel.signOut()
                    } label: {
                        VStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 30))
                            Text("Çıkış Yap")
                                .font(.system(size: 10, weight: .heavy, design: .serif))
                        }
                    }
                    
                } else {
                    NavigationLink {
                        AdminLoginView()
                    } label: {
                        VStack {
                            Image(systemName: "lock.shield.fill")
                                .font(.system(size: 30))
                            Text("Yönetici Girişi")
                                .font(.system(size: 10, weight: .heavy, design: .serif))
                        }
                    }
                    
                }
            }
            .foregroundColor(Color.red)
            .frame(width: 80, height: 80)
            
            Spacer()
            
            VStack {
                if authViewModel.userSession != nil {
                    NavigationLink {
                        AdminView()
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        VStack {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 30))
                            Text("Menüleri Düzenle")
                                .font(.system(size: 10, weight: .heavy, design: .serif))
                        }.foregroundColor(Color.green)
                    }
                }
            }.frame(width: 80, height: 80)
            
            
            Spacer()
            
            VStack {
                NavigationLink {
                    CalendarView()
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    VStack {
                        Image(systemName: "calendar")
                            .font(.system(size: 30))
                        Text("Takvim Görünümü")
                            .font(.system(size: 10, weight: .heavy, design: .serif))
                    }.foregroundColor(Color.blue)
                }
            }.frame(width: 80, height: 80)
        }
    }
}
