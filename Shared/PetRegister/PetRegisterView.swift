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
            
            FormPicker(index: $pageIndex, page: ["已注册", "新注册"])
                .padding()
                .background(Color(.systemGroupedBackground))
            
            Form {
                // 已经注册页面
                if pageIndex == 0 {
                    HadRegisterForm(isPresent: $isShow)
                    
                // 未注册页面
                }else if pageIndex == 1 {
                    NewRegisterForm()
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
            .disabled(IdInput.isEmpty)
        }
        
        Section(header: HStack {
                    Text("我的宠物列表")
                    EditButton()
        }) {
            ForEach(model.myPetIDs, id: \.self){ id in
                Button {
                    model.selectPet(id: id)
//                    isPresent = false
                } label: {
                    PetListInfo(pet_id: id)
                }
            }
            .onDelete(perform: model.deleteMyPet)
        }
    }
}

struct NewRegisterForm: View {
    @State private var genderIndex = 0
    @State private var pet = Pet()
    @State private var pet_id = ""
    @EnvironmentObject private var model: TelepoleModel
    @State private var register_status = false
    let gender: [String] = ["boy", "girl"]
    
    var inputValid: Bool {
        pet.name.isEmpty || pet.phone.isEmpty || pet.description.isEmpty || pet.variety.isEmpty
    }
    
    var body: some View {
        if !register_status {
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
                            pet_id = pet.id
                            register_status = true
                        }else{
                            debugPrint("添加失败")
                        }
                    }
                }) {
                    Text("立即注册该宠物")
                }
                .disabled(inputValid)
            }
        }else {
            Text("Hello, \(pet.name) 🐶")
                .font(.title)
                .bold()
            
            Section(footer: Text("注册成功，点击复制宠物ID")) {
                Button {
                    UIPasteboard.general.string = pet.id
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: "doc.on.clipboard")
                        Text("\(pet_id)")
                    }
                    .font(.body)
                }
            }
        }
    }
}

struct FormPicker: View {
    @Binding var index: Int
    
    let page: [String]
    var body: some View {
        Picker(selection: $index, label: Text("Picker")) {
            ForEach(0 ..< page.count) {
                Text(self.page[$0])
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct PetListInfo: View {
    var pet_id: String
    @EnvironmentObject private var model: TelepoleModel
    @State var pet: Pet = Pet()
    
    var body: some View {
        HStack {
            Text("\(pet.name)")
                .font(.body)
                .bold()
            Spacer()
            if pet_id == model.selectedPet.id {
                Text("🐶")
                    .font(.body)
            }
        }
        .onAppear(perform: {
            Pet().getPetByID(pet_id) { p in
                pet = p
            }
        })
    }
}
