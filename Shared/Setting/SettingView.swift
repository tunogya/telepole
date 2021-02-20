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
    @State var owner: Owner = Owner()
    @Binding var isShow: Bool
    @EnvironmentObject private var model: TelepoleModel
    
    var isShowLoginButton: Bool {
        if model.account.user == "" {
            return true
        }
        return false
    }
    
    var SignInButton: some View {
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
                            Account().login(user) { (user) in
                                model.loadAccount(user: user)
                                model.saveUserCredential(credential: user.id)
                                print("登陆完成")
                                print(isShowLoginButton)
                            }
                        }else {
                            // 新注册
                            let fullName = "\(appleIDCredential.fullName?.familyName ?? "")"
                                + "\(appleIDCredential.fullName?.givenName ?? "")"
                            let email = appleIDCredential.email
                            let user = appleIDCredential.user
                            let newUser = Account(user: user, fullName: fullName, email: email!)
                            Account().register(newUser) { (user) in
                                model.loadAccount(user: user)
                                model.saveUserCredential(credential: user.id)
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
    
    var body: some View {
        VStack(spacing: 0) {
            CardHeader(flag: $isShow, hasEditButton: false, title: "设置")
            
            if isShowLoginButton {
                SignInButton
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 44)
                    .padding()
                    .background(Color(.systemGroupedBackground))
            }
            
            Form{
                if !isShowLoginButton {
                    Section(header: Text("数据同步")) {
                        Button(action: {
                            if owner.id == "" {
                                Owner().initData(Owner(pets: model.myPetIDs, user_id: model.account.id)) { o in
                                    owner = o
                                }
                            }else{
                                Owner().patchData(_id: owner.id, owner: Owner(pets: model.myPetIDs, user_id: model.account.id)){
                                    Owner().getData(_id: owner.id) { o in
                                        owner = o
                                    }
                                }
                            }
                        }) {
                            HStack {
                                Text("备份我的宠物")
                                Spacer()
                                Text("(\(model.myPetIDs.count))")
                            }
                            
                        }
                        
                        Button(action: {
                            model.myPetIDs = owner.pets
                        }) {
                            HStack{
                                Text("恢复我的宠物")
                                Spacer()
                                Text("(\(owner.pets.count))")
                            }
                        }
                    }
                    
                    Section(header: Text("当前用户: \(model.account.email)")) {
                        Button(action: {
                            model.clearAccount()
                        }){
                            Text("注销")
                        }
                    }
                }
            }
            .onAppear(perform: {
                Owner().getDataByUser_id(_id: model.account.id) { o in
                    owner = o
                }
            })
        }
        .cornerRadius(20)
        .ignoresSafeArea()
    }
}
