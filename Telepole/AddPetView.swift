//
//  RegisterView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/1.
//

import SwiftUI

struct AddPetView: View {
    @State var codeInput: String = "b45a21d55ff9c845043f6ce61eaba5de"
    @Binding var isShowAddPetView: Bool
    @State var selectedIndex: Int = 2
    @State var isShowCode: Bool = false
    
    @State var name = ""
    @State var username = ""
    @State var genderIndex = 1
    @State var variety = ""
//    @State var color = Color(red: 1.0, green: 1.0, blue: 1.0)
    
    var is_name_valid: Bool {
        if name.isEmpty{
            return false
        }else{
            return true
        }
    }
    
    var is_username_valid: Bool  {
        if username.isEmpty{
            return false
        }else{
            return true
        }   
    }
    
    let gender: [String] = ["boy", "girl"]
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0) {
                Picker(selection: $selectedIndex, label: Text("Picker")) {
                    Text("已注册").tag(1)
                    Text("新注册").tag(2)
                }
                .padding()
                .pickerStyle(SegmentedPickerStyle())
                .background(Color(.systemGroupedBackground))
                
                Form {
                    if selectedIndex == 1 {
                        Section {
                            HStack {
                                if isShowCode {
                                    TextField("请输入已注册宠物的Code地址", text: $codeInput)
                                        .foregroundColor(.black)
                                } else {
                                    SecureField("请输入已注册宠物的Code地址", text: $codeInput)
                                        .foregroundColor(.black)
                                }
                                
                                Button(action: {
                                    isShowCode.toggle()
                                }) {
                                    Image(systemName: isShowCode ? "eye" : "eye.slash.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .font(.body)
                            
                            Button(action: {
                                UsersApi().getUserByCode(code: codeInput) { (user) in
                                    print(user)
                                }
                            }) {
                                Text("提交")
                            }
                        }
                    }else if selectedIndex == 2 {
                        Section(header: Text("宠物信息")) {
                            TextField("请输入宠物姓名", text: $name)
                            HStack {
                                Text("@")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                TextField("请输入唯一标识的域名", text: $username)
                            }
                            Picker(selection: $genderIndex, label: Text("性别")) {
                                ForEach(0 ..< gender.count) {
                                    Text(self.gender[$0])
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                            TextField("品种", text: $variety)
                        }
                        
//                        Section(header: Text("地图设置")) {
//                            ColorPicker("自定义标识色", selection: $color)
//                        }
                        
                        Section {
                            Button(action: {
                                print("\(name)")
                                print("\(username)")
                                print("\(genderIndex)")
                                
//                                print("\(color.description)")
                            }) {
                                Text("立即注册该宠物")
                            }
                        }
                    }
                    
                }
            }
            .navigationBarTitle(Text("增加宠物"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Dismissing sheet view...")
                self.isShowAddPetView = false
            }) {
                Text("完成").bold()
            })
        }
    }
    
    
}

struct AddPetView_Previews: PreviewProvider {
    static var previews: some View {
        AddPetView_Previews_Test()
    }
}

struct AddPetView_Previews_Test: View {
    @State var isShowAddPetView = true
    var body: some View {
        AddPetView(isShowAddPetView: $isShowAddPetView)
    }
}
