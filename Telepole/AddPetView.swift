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
    var body: some View {
        NavigationView{
            VStack {
                TextField("请输入已注册的宠物Code", text: $codeInput)
                    .font(.body)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
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
