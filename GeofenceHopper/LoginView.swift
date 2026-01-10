//
//  LoginView.swift
//  GeofenceHopper
//
//  Created by AI Assistant on 2024/05/15.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // 赤い背景
                Color.red
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("GeofenceHopper")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 30)
                    
                    TextField("ユーザー名", text: $username)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    SecureField("パスワード", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    Button(action: {
                        // 簡単な認証シミュレーション
                        if !username.isEmpty && !password.isEmpty {
                            isLoggedIn = true
                        }
                    }) {
                        Text("ログイン")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
                .padding()
                
                NavigationLink(
                    destination: ContentView(modelContext: try! ModelContainer(for: LocationHistory.self).mainContext),
                    isActive: $isLoggedIn,
                    label: { EmptyView() }
                )
            }
        }
    }
}

#Preview {
    LoginView()
}