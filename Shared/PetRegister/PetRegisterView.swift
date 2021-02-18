//
//  RegisterView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/1.
//

import SwiftUI

struct PetRegisterView: View {
    @Binding var isShow: Bool
    @State var pageIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            CardHeader(flag: $isShow, hasEditButton: false, title: "增加宠物")
            
            RegisterFormPicker(index: $pageIndex)
                .background(Color(.systemGroupedBackground))
            
            Form {
                // 已经注册页面
                if pageIndex == 0 {
                    HadRegisterForm(isPresent: $isShow)
                    
                // 未注册页面
                }else if pageIndex == 1 {
                    NewRegisterForm(isPresent: $isShow)
                }
            }
        }
    }
}


struct HadRegisterForm: View {
    @EnvironmentObject private var model: TelepoleModel
    @State var IdInput: String = ""
    @Binding var isPresent: Bool
    
    var body: some View {
        Section(header: Text("请确保宠物已经注册")) {
            HStack {
                TextField("宠物ID地址", text: $IdInput)
            }
            .font(.body)
            
            // 已经注册宠物添加按钮
            Button(action: {
                Pet().getPetByID(IdInput) { (pet) in
                    if !pet.id.isEmpty{
                        model.myPetIDs.append(pet.id)
                        model.selectPet(pet)
                        isPresent = false
                    }else{
                        debugPrint("添加失败")
                    }
                }
            }) {
                Text("提交")
            }
        }
        
        Section(header: Text("我的宠物列表")) {
            ForEach(model.myPetIDs, id: \.self){ id in
                Button {
                    Pet().getPetByID(id) { pet in
                        model.selectPet(pet)
                    }
                    isPresent = false
                } label: {
                    PetListInfo(pet_id: id)
                }
            }
        }
    }
}

struct NewRegisterForm: View {
    @State var genderIndex = 0
    @State var pet = Pet()
    @Binding var isPresent: Bool
    
    @EnvironmentObject private var model: TelepoleModel
    
    
    let gender: [String] = ["boy", "girl"]
    var is_name_valid: Bool {
        if pet.name.isEmpty{
            return false
        }else{
            return true
        }
    }
    
    var body: some View {
        Section(header: Text("宠物信息")) {
            TextField("请输入宠物姓名", text: $pet.name)
            Picker(selection: $genderIndex, label: Text("性别")) {
                ForEach(0 ..< gender.count) {
                    Text(self.gender[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
            TextField("品种", text: $pet.variety)
            TextField("请输入描述", text: $pet.description)
            TextField("请输入联系电话", text: $pet.phone)
        }
        
        Section {
            // 新注册按钮
            Button(action: {
                // 更新gender
                pet.gender = gender[genderIndex]
                Pet().createPet(pet) { (pet) in
                    if !pet.id.isEmpty{
                        model.myPetIDs.append(pet.id)
                        model.selectPet(pet)
                        isPresent = false
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

struct RegisterFormPicker: View {
    @Binding var index: Int
    
    let page: [String] = ["已注册", "新注册"]
    var body: some View {
        Picker(selection: $index, label: Text("Picker")) {
            ForEach(0 ..< page.count) {
                Text(self.page[$0])
            }
        }
        .padding()
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct PetListInfo: View {
    var pet_id: String
    @State var pet: Pet = Pet()
    
    var body: some View {
        HStack {
            Image(systemName: "person")
                .background(Color("AccentColor"))
            Text("\(pet.name)")
                .font(.body)
                .bold()
            Spacer()
            
        }
        .onAppear(perform: {
            Pet().getPetByID(pet_id) { p in
                pet = p
            }
        })
    }
}
