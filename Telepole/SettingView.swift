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
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.id, ascending: true)],
        animation: .default) private var pets: FetchedResults<Pet>
    
    @Binding var isShareMyLocation: Bool
    @Binding var isShowSetting: Bool
    
    private func deletePets(offsets: IndexSet) {
        withAnimation {
            offsets.map { pets[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
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
                
                Section(header: Text("我的宠物列表")) {
                    // 呈现宠物集合
                    List {
                        ForEach(pets) { item in
                            Text("\(item.name ?? "神秘宝贝")")
                        }
                        .onDelete(perform: deletePets)
                    }
                    //                        if items.isEmpty{
                    ButtonRegister()
                    //                        }
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

struct ButtonRegister: View {
    @State var isShowAddPetView: Bool = false
    var body: some View {
        Button(action: {
            debugPrint("跳转到AddPetView:\(isShowAddPetView)")
            isShowAddPetView.toggle()
        }) {
            Text("增加一个宠物")
                .font(.body)
        }
        .sheet(isPresented: $isShowAddPetView, content: {
            SettingAddPetView(isShowAddPetView: $isShowAddPetView)
        })
    }
}
