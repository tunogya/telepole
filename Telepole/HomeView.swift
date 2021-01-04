//
//  HomeView.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @State var isShareMyLocation: Bool = false
    @State var isAnonymous: Bool = false
    var pets = ["贝贝", "七喜"]
    @State private var selectedPets = 0
    
    var body: some View {
        NavigationView{
            ZStack{
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
                
                VStack {
                    Spacer()
                    
                    NavigationLink(destination: MapView()) {
                        ButtonEnterMap()
                    }
                }
            }
            .navigationBarTitle("Telepole", displayMode: .large)
            .navigationBarItems(trailing: StatusBar(isShareMyLocation: $isShareMyLocation, isAnonymous: $isAnonymous))
            .ignoresSafeArea(.all)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct StatusBar: View {
    @Binding var isShareMyLocation: Bool
    @Binding var isAnonymous: Bool
    var body: some View {
        HStack{
            // 如果是访客身份
            Image(systemName: isShareMyLocation ? "location.fill" : "location.slash.fill")
                .opacity(isShareMyLocation ? 1 : 0.2)
                .animation(.easeOut)
            
            Image(systemName: isAnonymous ? "face.smiling.fill" : "face.dashed")
                .opacity(isAnonymous ? 1 : 0.2)
                .animation(.easeOut)
        }
        .font(.body)
    }
}


struct TipsAnonymous: View {
    var body: some View {
        Text("Session:")
            .font(.body)
            .foregroundColor(.secondary)
    }
}

struct ButtonRegister: View {
    @State var isShowAddPetView: Bool = false
    var body: some View {
        Button(action: {
            debugPrint("跳转到AddPetView:\(isShowAddPetView)")
            isShowAddPetView.toggle()
        }) {
            Text("添加一个宠物")
                .font(.body)
                .foregroundColor(.accentColor)
                .sheet(isPresented: $isShowAddPetView, content: {
                    AddPetView(isShowAddPetView: $isShowAddPetView)
                })
        }
    }
}


struct ButtonEnterMap: View {
    var body: some View {
        Text("进入")
            .font(.body)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .padding(.bottom, 23)
            .background(Color.accentColor)
    }
}
