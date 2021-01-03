//
//  RegisterView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/1.
//

import SwiftUI

struct AddPetView: View {
    @State var codeInput: String = ""
    @Binding var isShowAddPetView: Bool
    @State var selectedIndex: Int = 1
    @State var isShowCode: Bool = false
    
    
    
    var body: some View {
        NavigationView{
            Form {
                // Picker
                Section {
                    Picker(selection: $selectedIndex, label: Text("Picker")) {
                        Text("已注册").tag(1)
                        Text("新注册").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Form
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
                            debugPrint("提交信息")
                        }) {
                            Text("提交")
                        }
                    }
                }else if selectedIndex == 2 {
                    Section {
//                        TextField("Placeholder", text: )
                    }
                }
                
            }
            .navigationBarTitle(Text("增加宠物信息"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Dismissing sheet view...")
                self.isShowAddPetView = false
            }) {
                Text("完成").bold()
            })
        }
    }
}

//struct AddPetView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPetView(isShowAddPetView: )
//    }
//}
