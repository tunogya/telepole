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
    
    var body: some View {
        NavigationView{
            ZStack{
                Form{
                    Section{
                        Toggle(isOn: $isShareMyLocation) {
                            Text("共享我的位置")
                                .font(.body)
                        }
                    }
                    
                    Section{
                        Toggle(isOn: $isAnonymous) {
                            Text("匿名登陆")
                                .font(.body)
                        }
                        if isAnonymous{
                            TipsAnonymous()
                        }else{
                            Button(action: {
                                print("注册一个宠物")
                            }) {
                                Text("注册一个宠物")
                                    .font(.body)
                                    .foregroundColor(.accentColor)
                            }
                        }
                       
                    }
                  
                }
                
                VStack {
                    Spacer()
                    
                    ButtonEnter()
                 
                }
            }
         
            .navigationTitle("Telepole")
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

struct ButtonEnter: View {
    var body: some View {
        Button(action: {
            print("进入世界")
        }) {
            HStack{
                Spacer()
                Text("进入")
                    .font(.body)
                    .foregroundColor(.white)
                    .frame(height: 60)
                Spacer()
            }
            .padding(.bottom, 20)
            .background(Color.accentColor)
        }
    }
}

struct TipsAnonymous: View {
    var body: some View {
        Text("Session:")
            .font(.body)
            .foregroundColor(.secondary)
    }
}
