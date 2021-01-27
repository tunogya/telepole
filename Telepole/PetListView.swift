//
//  PetListView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/23.
//

import SwiftUI

struct PetListView: View {
    @Binding var showStatus: ShowStatus
    @ObservedObject var userSettings = UserSettings()
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.id, ascending: true)],
        animation: .default) private var pets: FetchedResults<Pet>
    
    private func deletePets(offsets: IndexSet) {
        withAnimation {
            offsets.map { pets[$0] }.forEach(viewContext.delete)
            
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
            CardHeader(flag: $showStatus.isShowPetList, hasEditButton: true, title: "我的宠物")
            
            Form {
                Section(header: Text("我的宠物列表")) {
                    // 呈现宠物集合
                    List {
                        ForEach(pets) { item in
                            Button(action: {
                                userSettings.pickPetID = item.id ?? ""
                                print(userSettings.pickPetID)
                            }, label: {
                                Text("\(item.name ?? "神秘宝贝")")
                            })
                        }
                        .onDelete(perform: deletePets)
                    }
                    //                        if items.isEmpty{
                    ButtonRegister()
                    //                        }
                }
            }
        }
        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
        .cornerRadius(20)
    }
}

//struct PetListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PetListView()
//    }
//}

struct ButtonRegister: View {
    @State var isShowAddPetView: Bool = false
    var body: some View {
        Button(action: {
            debugPrint("跳转到AddPetView:\(isShowAddPetView)")
            isShowAddPetView.toggle()
        }) {
            Text("增加一个宠物")
                .font(.body)
        }
        .sheet(isPresented: $isShowAddPetView, content: {
            PetRegisterView(isShowAddPetView: $isShowAddPetView)
        })
    }
}
