//
//  RegisterView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/1.
//

import SwiftUI

struct SettingAddPetView: View {
    @State var IdInput: String = ""
    @Binding var isShowAddPetView: Bool
    @State var pageIndex: Int = 0
    let page: [String] = ["已注册", "新注册"]
    @State var isShowCode: Bool = false
    
    @State var pet = PetModel(id: "", name: "", username: "", description: "", profile_image_url: "", protected: false, verified: false, variety: "", gender: "boy")
    @State var genderIndex = 0
    let gender: [String] = ["boy", "girl"]
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.id, ascending: true)],
        animation: .default) private var items: FetchedResults<Pet>
    
    // 增加pet到数据库
    private func addPet(_ pet: PetModel) {
        withAnimation {
            let newPet = Pet(context: viewContext)
            newPet.name = pet.name
            newPet.username = pet.username
            newPet.desc = pet.description
            newPet.id = pet.id
            newPet.profile_image_url = pet.profile_image_url
            newPet.protected = pet.protected
            newPet.verified = pet.verified
            newPet.variety = pet.variety
            newPet.gender = pet.gender
            
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
        if pet.name.isEmpty{
            return false
        }else{
            return true
        }
    }
    
    var is_username_valid: Bool  {
        if pet.username.isEmpty{
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
                // 已经注册页面
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
                        
                        // 已经注册宠物添加按钮
                        Button(action: {
                            PetApi().getPetById(id: IdInput) { (pet) in
                                if !pet.id.isEmpty{
                                    addPet(pet)
                                }else{
                                    debugPrint("添加失败")
                                }
                            }
                        }) {
                            Text("提交")
                        }
                    }
                    
                // 未注册页面
                }else if pageIndex == 1 {
                    Section(header: Text("宠物信息")) {
                        TextField("请输入宠物姓名", text: $pet.name)
                        HStack {
                            Text("@")
                                .font(.body)
                                .foregroundColor(.secondary)
                            TextField("请输入唯一标识的域名", text: $pet.username)
                        }
                        Picker(selection: $genderIndex, label: Text("性别")) {
                            ForEach(0 ..< gender.count) {
                                Text(self.gender[$0])
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        TextField("品种", text: $pet.variety)
                        TextField("请输入描述", text: $pet.description)
                    }
                    
                    Section {
                        // 新注册按钮
                        Button(action: {
                            // 更新gender
                            pet.gender = gender[genderIndex]
                            print(pet)
                            PetApi().createPet(pet) { (pet) in
                                if !pet.id.isEmpty{
                                    addPet(pet)
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
