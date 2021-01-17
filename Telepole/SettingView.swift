//
//  HomeView.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SettingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.id, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Pet>
    
    @State private var isShareMyLocation: Bool = false
    @Binding var isShowSetting: Bool
        
    private func deletePets(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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

    var body: some View {
        VStack(spacing: 0){
                SliderIndicator()
                    .padding(.top, 12)
                
                CardTitle(flag: $isShowSetting, title: "设置")
                
                Form{
                    Section {
                        Toggle(isOn: $isShareMyLocation) {
                            Text("共享我的位置")
                                .font(.body)
                        }
                    }
                    
                    Section(header: Text("我的宠物列表")) {
                        // 呈现宠物集合
                        List {
                            ForEach(items) { item in
                                Text("\(item.name ?? "神秘宝贝")")
                            }
                            .onDelete(perform: deletePets)
                        }
//                        if items.isEmpty{
                            ButtonRegister()
//                        }
                    } 
                }
            }
            .ignoresSafeArea(.all)
        }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

struct TipsAnonymous: View {
    var body: some View {
        Text("Session:")
            .font(.body)
            .foregroundColor(Color("GrayColor"))
    }
}

struct ButtonRegister: View {
    @State var isShowAddPetView: Bool = false
    var body: some View {
        Button(action: {
            debugPrint("跳转到AddPetView:\(isShowAddPetView)")
            isShowAddPetView.toggle()
        }) {
            Text("增加一个宠物")
                .font(.body)
                .sheet(isPresented: $isShowAddPetView, content: {
                    SettingAddPetView(isShowAddPetView: $isShowAddPetView)
                })
        }
    }
}
