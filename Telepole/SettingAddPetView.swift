//
//  RegisterView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/1.
//

import SwiftUI

struct SettingAddPetView: View {
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
    @State var profile_image_url = ""
    //    @State var color = Color(red: 1.0, green: 1.0, blue: 1.0)
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.id, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Pet>
    
    private func addPet(name: String, description: String, username: String, id: String, profile_image_url: String, protected: Bool, verified: Bool, variety: String, gender: String) {
        withAnimation {
            let newPet = Pet(context: viewContext)
            newPet.name = name
            newPet.username = username
            newPet.desc = description
            newPet.id = id
            newPet.profile_image_url = profile_image_url
            newPet.protected = protected
            newPet.verified = verified
            newPet.variety = variety
            newPet.gender = gender
            
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
        VStack(spacing: 0) {
            CardTitleClosed(flag: $isShowAddPetView, title: "增加宠物")
            
            Picker(selection: $pageIndex, label: Text("Picker")) {
                ForEach(0 ..< page.count) {
                    Text(self.page[$0])
                }
            }
            .padding()
            .pickerStyle(SegmentedPickerStyle())
            
            Form {
                if pageIndex == 0 {
                    Section(header: Text("请确保宠物已经注册")) {
                        HStack {
                            if isShowCode {
                                TextField("请输入已注册宠物的Id地址", text: $IdInput)
                            } else {
                                SecureField("请输入已注册宠物的Id地址", text: $IdInput)
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
                            PetApi().getPetById(id: IdInput) { (pet) in
                                if !pet.id.isEmpty{
                                    addPet(name: pet.name,
                                           description: pet.description,
                                           username: pet.username,
                                           id: pet.id,
                                           profile_image_url: pet.profile_image_url,
                                           protected: pet.protected,
                                           verified: pet.verified,
                                           variety: pet.variety,
                                           gender: pet.gender)
                                }else{
                                    debugPrint("添加失败")
                                }
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
                            PetApi().createUser(name: name, username: username, description: description, profile_image_url: profile_image_url, protected: false, verified: false, gender: gender[genderIndex], variety: variety) { (pet) in
                                if !pet.id.isEmpty{
                                    addPet(name: pet.name,
                                           description: pet.description,
                                           username: pet.username,
                                           id: pet.id,
                                           profile_image_url: pet.profile_image_url,
                                           protected: pet.protected,
                                           verified: pet.verified,
                                           variety: pet.variety,
                                           gender: pet.gender)
                                }else{
                                    debugPrint("添加失败")
                                }
                            }
                        }) {
                            Text("立即注册该宠物")
                        }
                    }
                }
            }
        }
        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
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
        SettingAddPetView(isShowAddPetView: $isShowAddPetView)
    }
}
