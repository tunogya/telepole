//
//  RegisterView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/1.
//

import SwiftUI

struct AddPetView: View {
    @State var IdInput: String = "b45a21d55ff9c845043f6ce61eaba5de"
    @Binding var isShowAddPetView: Bool
    @State var pageIndex: Int = 0
    let page: [String] = ["已注册", "新注册"]
    @State var isShowCode: Bool = false
    
    @State var name = ""
    @State var username = ""
    @State var genderIndex = 0
    let gender: [String] = ["boy", "girl"]
    @State var variety = ""
    @State var description = ""
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
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0) {
                Picker(selection: $pageIndex, label: Text("Picker")) {
                    ForEach(0 ..< page.count) {
                        Text(self.page[$0])
                    }
                }
                .padding()
                .pickerStyle(SegmentedPickerStyle())
                .background(Color(.systemGroupedBackground))
                
                Form {
                    if pageIndex == 0 {
                        Section {
                            HStack {
                                if isShowCode {
                                    TextField("请输入已注册宠物的Id地址", text: $IdInput)
                                        .foregroundColor(.black)
                                } else {
                                    SecureField("请输入已注册宠物的Id地址", text: $IdInput)
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
                                UserApi().getUserById(id: IdInput) { (user) in
                                    print(user)
                                }
                                
                            }) {
                                Text("提交")
                            }
                        }
                    }else if pageIndex == 1 {
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
                            TextField("请输入描述", text: $description)
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
