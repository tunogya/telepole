//
//  RegisterView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/1.
//

import SwiftUI

struct PetRegisterView: View {
    @State var IdInput: String = ""
    @Binding var isShow: Bool
    @Binding var pickPetID: String
    @State var pageIndex: Int = 0
    let page: [String] = ["已注册", "新注册"]
    
    @State var pet = PetModel()
    @State var genderIndex = 0
    let gender: [String] = ["boy", "girl"]
    
    @ObservedObject var userSettings = UserSettings()
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.id, ascending: true)],
        animation: .default) private var items: FetchedResults<Pet>
    
    // 增加pet到数据库
    private func addPet(_ pet: PetModel) {
        withAnimation {
            let newPet = Pet(context: viewContext)
            newPet.name = pet.name
            newPet.desc = pet.description
            newPet.id = pet.id
            newPet.profile_image_url = pet.profile_image_url
            newPet.protected = pet.protected
            newPet.verified = pet.verified
            newPet.variety = pet.variety
            newPet.gender = pet.gender
            newPet.phone = pet.phone
            newPet.coins = pet.coins
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
    
    var body: some View {
        VStack(spacing: 0) {
            CardHeader(flag: $isShow, hasEditButton: false, title: "增加宠物")
            
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
                            TextField("请输入已注册宠物的Id地址", text: $IdInput)
                        }
                        .font(.body)
                        
                        // 已经注册宠物添加按钮
                        Button(action: {
                            PetApi().getPetById(IdInput) { (pet) in
                                if !pet.id.isEmpty{
                                    addPet(pet)
                                    isShow = false
                                }else{
                                    debugPrint("添加失败")
                                }
                            }
                        }) {
                            Text("提交")
                        }
                    }
                    
                    Section(header: Text("我的宠物列表")) {
                        ForEach(items){ item in
                            Button {
                                userSettings.pickPetID = item.id!
                                pickPetID = item.id!
                                isShow = false
                            } label: {
                                Text(item.name ?? "null")
                            }

                            
                        }
                    }
                    
                // 未注册页面
                }else if pageIndex == 1 {
                    Section(header: Text("宠物信息")) {
                        TextField("请输入宠物姓名", text: $pet.name)
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
                                    isShow = false
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
    }
}
