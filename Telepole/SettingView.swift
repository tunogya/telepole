//
//  HomeView.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SettingView: View {
    @State var isShareMyLocation: Bool = false
    @State var isAnonymous: Bool = false
    @Binding var isShowSetting: Bool
    var pets = ["贝贝", "七喜"]
    @State private var selectedPets = 0
    
    var body: some View {
            VStack{
                SliderIndicator()
                    .padding(.top, 12)
                Form{
                    Section {
                        Toggle(isOn: $isShareMyLocation) {
                            Text("共享我的位置")
                                .font(.body)
                        }
                    }
                    
                    Section {
                        Toggle(isOn: $isAnonymous) {
                            Text(isAnonymous ? "匿名登陆" : "实名登陆")
                                .font(.body)
                        }
                        if isAnonymous{
                            // 显示匿名登录的 Session
                            TipsAnonymous()
                        }else{
                            // 呈现宠物集合
                            Picker(selection: $selectedPets, label: Text("已注册宠物")) {
                                ForEach(0 ..< pets.count) {
                                    Text(self.pets[$0])
                                }
                            }
                            ButtonRegister()
                        }
                    } 
                }
            }
            .ignoresSafeArea(.all)
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
                .foregroundColor(Color("AccentColor"))
                .font(.body)
                .sheet(isPresented: $isShowAddPetView, content: {
                    AddPetView(isShowAddPetView: $isShowAddPetView)
                })
        }
    }
}
