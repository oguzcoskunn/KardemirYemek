//
//  LoginView.swift
//  KardemirYemek
//
//  Created by Oğuz Coşkun on 10.04.2022.
//

import SwiftUI

struct AdminLoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var email = ""
    @State var password = ""
    @State private var showFirebaseError: Bool = false
    @State private var fireBaseError = ""
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Yönetici Girişi")
                        .font(.system(size: 45, weight: .bold, design: .serif))
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .padding(.top, 120)
                        .padding(.bottom, 32)
                        .foregroundColor(.white)
                    
                    VStack(spacing: 20) {
                        CustomTextField(text: $email, placeholder: Text("Email"), imageName: "envelope")  
                        
                        CustomSecureField(text: $password, placeholder: Text("Şifre"))
                    }
                    .padding(.horizontal, 20)
                    .frame(width: 400)
                    
                    
                    Button(action: {
                        viewModel.login(withEmail: email, password: password)
                    }, label: {
                        Text("Giriş Yap")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 360, height: 50)
                            .background(Color.red)
                            .clipShape(Capsule())
                            .padding()
                        
                    })
                    .padding(.top, 20)
                    
                    
                    Spacer()
                }
            }
            .background(Color.black.scaledToFill())
            .ignoresSafeArea()
            .navigationTitle("")
            
            .alert(isPresented: $showFirebaseError) {
                Alert(title: Text("\(self.fireBaseError)"))
            }
            .onChange(of: self.viewModel.error?.localizedDescription) { newValue in
                if let newValue = newValue {
                    if !newValue.isEmpty {
                        self.fireBaseError = newValue
                        self.showFirebaseError.toggle()
                        self.viewModel.error = nil
                    }
                }
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        AdminLoginView()
    }
}
