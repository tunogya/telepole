//
//  HomeView.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.
//

import SwiftUI
import SDWebImageSwiftUI
import AuthenticationServices
import MapKit

struct SettingView: View {
    @Binding var isShow: Bool
    @ObservedObject var userSettings = UserSettings()
    
    var isShowLoginButton: Bool {
        if userSettings.user == ""{
            return true
        }
        return false
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CardHeader(flag: $isShow, hasEditButton: false, title: "设置")
            
            if isShowLoginButton {
                SignInButton()
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 44)
                    .padding()
                    .background(Color(.systemGroupedBackground))
            }
            Form{
                if !isShowLoginButton {
                    Section(header: Text("数据同步")) {
                        Button(action: {
                            
                        }) {
                            Text("备份我的宠物")
                        }
                        
                        Button(action: {
                            print(userSettings.user_id)
                            OwnerApi().getPetByUser(userSettings.user_id) { (owner) in
                                print(owner)
                            }
                        }) {
                            Text("恢复我的宠物")
                        }
                    }
                    
                    Section(header: Text("当前用户: \(userSettings.email)")) {
                        Button(action: {
                            userSettings.user = ""
                            userSettings.email = ""
                            userSettings.fullName = ""
                            userSettings.user_id = ""
                        }){
                            Text("注销")
                        }
                    }
                }
            }
        }
        .cornerRadius(20)
        .ignoresSafeArea()
    }
}

struct TipsAnonymous: View {
    var body: some View {
        Text("Session:")
            .font(.body)
            .foregroundColor(Color("GrayColor"))
    }
}

struct SignInButton: View {
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        if appleIDCredential.email == nil{
                            // 已经注册过，直接登陆
                            let user = appleIDCredential.user
                            UserApi().login(user) { (user) in
                                print(user)
                                userSettings.user = user.user
                                userSettings.email = user.email
                                userSettings.fullName = user.fullName
                                userSettings.user_id = user.user_id
                            }
                        }else {
                            // 新注册
                            let fullName = String(describing: appleIDCredential.fullName?.familyName)
                                + String(describing: appleIDCredential.fullName?.givenName)
                            let email = String(describing: appleIDCredential.email)
                            let user = appleIDCredential.user
                            let newUser = UserModel(user: user, fullName: fullName, email: email)
                            UserApi().register(newUser) { (user) in
                                userSettings.user = user.user
                                userSettings.email = user.email
                                userSettings.fullName = user.fullName
                                userSettings.user_id = user.user_id
                            }
                        }
                        
                    case let passwordCredential as ASPasswordCredential:
                        let username = passwordCredential.user
                        let password = passwordCredential.password
                        print(username, password)
                    default:
                        break
                    }
                case .failure(let error):
                    print("failure", error)
                }
            }
        )
    }
}
