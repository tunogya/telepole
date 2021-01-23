//
//  HomeView.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.
//

import SwiftUI
import SDWebImageSwiftUI
import AuthenticationServices

struct SettingView: View {
    @Binding var isShareMyLocation: Bool
    @Binding var isShowSetting: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            CardTitleClosed(flag: $isShowSetting, title: "设置")
            
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
                                UserApi().login(user: user) { (user) in
                                    print(user)
                                }
                            }else {
                                // 新注册
                                let fullName = String(describing: appleIDCredential.fullName?.familyName)
                                    + String(describing: appleIDCredential.fullName?.givenName)
                                let email = String(describing: appleIDCredential.email)
                                let user = appleIDCredential.user
                                let newUser = UserModel(user: user, fullName: fullName, email: email)
                                UserApi().register(newUser) { (user) in
                                    print(user)
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
            .signInWithAppleButtonStyle(.white)
            .frame(maxWidth: 375)
            .frame(height: 44)
            .padding()
            
            Form{
                Section(header: Text("设置定位权限")) {
                    Toggle(isOn: $isShareMyLocation) {
                        Text("共享我的位置")
                            .font(.body)
                    }
                }
            }
        }
        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
        .cornerRadius(20)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

struct TipsAnonymous: View {
    var body: some View {
        Text("Session:")
            .font(.body)
            .foregroundColor(Color("GrayColor"))
    }
}
