//
//  AppSingolView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/15.
//

import SwiftUI

var SCREENWIDTH = UIScreen.main.bounds.width
var SCREENHEIGHT = UIScreen.main.bounds.height

struct AppSingleView: View {
    @State private var isShowPetRegisterView = false
    @State private var isShowSettingView = false
    @State private var isShowWakanda = false
    @State private var isShowLostMode = false
    @State private var status: String = "😀"
    @State private var taps = 0
    @State private var pageIndex = 0
    @EnvironmentObject private var model: TelepoleModel
    @ObservedObject var locationManager = LocationManager()
    
    var friends: [Pet] {
        model.friendGeos.map { geo in
            geo.pet
        }.removeDuplicates()
    }
    
    var petInfo: some View {
        Button(action: {
            isShowLostMode.toggle()
        }) {
            HStack(spacing: 0){
                Text("🐶")
                    .frame(width: 30, height: 30, alignment: .center)
                    .background(Color(model.selectedPet.protected ? #colorLiteral(red: 0.9789028764, green: 0.8711864352, blue: 0.06549777836, alpha: 1)  :  .red))
                    .clipShape(Circle())
                    .frame(width: 44, height: 44, alignment: .center)
                
                VStack(alignment: .leading){
                    Text(model.selectedPet.id.isEmpty ? "未登陆" : model.selectedPet.name)
                        .bold()
                        .foregroundColor(Color(#colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1)))
                    Text(String(format: "%0.1f", model.selectedPet.coins) + " 币")
                        .foregroundColor(Color(#colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1)))
                }
                .font(.footnote)
                .padding(.trailing)
            }
            .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
            .cornerRadius(44)
            .frame(height: 44)
        }
        .disabled(model.selectedPet.id.isEmpty ? true : false)
        .actionSheet(isPresented: $isShowLostMode) {
            ActionSheet(
                title: Text("宠物丢失模式"),
                message: Text(model.selectedPet.protected ? "开启丢失模式后，你的电话号码会被公布。" : "停止丢失模式后，你的电话号码会被隐藏。"),
                buttons: [
                    .destructive(Text(model.selectedPet.protected ? "开启丢失模式" : "停止丢失模式"),action: {
                        if model.selectedPet.protected{
                            model.startLostMode()
                        }else{
                            model.stopLostMode()
                        }
                    }),
                    .cancel(Text("取消"))
                ]
            )
        }
    }
    
    var userStatus: some View {
        Button(action: {
            isShowSettingView = true
        }) {
            Text(status)
                .frame(width: 44, height: 44, alignment: .center)
                .font(.title)
                .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                .clipShape(Circle())
        }
    }
    
    var buttonRegisterPet: some View {
        Button {
            isShowPetRegisterView = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
                .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                .clipShape(Circle())
        }
    }
    
    var sendGeoButton: some View {
        HStack(){
            Spacer()
            Button {
                Hapitcs().simpleSuccess()
                withAnimation(Animation.easeInOut(duration: 1)) {
                    taps += 1
                }
                let geo = Geo(pet: model.selectedPet, name: model.account.id, latitude: locationManager.lastLocation?.coordinate.latitude ?? 0, longitude: locationManager.lastLocation?.coordinate.longitude ?? 0)
                Geo().postMyGeo(geo){
                    model.updateGeos(petID: model.selectedPet.id)
                }
            } label:{
                Image(systemName: "paperplane.circle.fill")
                    .font(.title2)
                    .modifier(Bounce(animCount: CGFloat(taps)))
                Text("记录足迹")
                    .font(.body)
                    .bold()
            }
            .disabled(model.selectedPet.id.isEmpty ? true : false)
           
            Spacer()
        }
        .padding(.vertical, 12)
        .foregroundColor(Color(#colorLiteral(red: 0.1490196078, green: 0.07058823529, blue: 0.3098039216, alpha: 1)))
        .background(Color(#colorLiteral(red: 0.9789028764, green: 0.8711864352, blue: 0.06549777836, alpha: 1)))
        .cornerRadius(28)
    }
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                HStack {
                    // 宠物图标
                    petInfo
                    
                    #if !APPCLIP
                    buttonRegisterPet
                        .sheet(isPresented: $isShowPetRegisterView) {
                            PetRegisterView(isShow: $isShowPetRegisterView)
                                .environmentObject(model)
                        }
                    #endif
                    Spacer()
                    // 个人图标
                    #if !APPCLIP
                    userStatus
                        .sheet(isPresented: $isShowSettingView) {
                            SettingView(isShow: $isShowSettingView)
                                .environmentObject(model)
                        }
                    #endif
                }
                .padding(.top)
                
                MapView()
                    .padding(.bottom)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("足迹发现")
                            .font(.title)
                            .bold()
                            .padding(.trailing)
                        
                        FormPicker(index: $pageIndex, page: ["我", "新朋友"])
                            .padding(.leading)
                    }
                    .padding(.bottom, 12)
                    
                    if pageIndex == 0 {
                        ForEach(model.lastGeos){ geo in
                            FindMyPetFootItem(geo: geo)
                                .padding(.bottom, 4)
                        }
                        if model.lastGeos.count >= 3 {
                            DeleteAllGeos(pet: model.selectedPet)
                        }
                    } else {
                        ForEach(friends){ pet in
                            FindFriendsListItem(pet: pet)
                                .padding(.bottom, 4)
                        }
                    }
                }
                .padding(.bottom, 80)
            }
            
            VStack(alignment: .leading){
                
                Spacer()
                
                sendGeoButton
                    .padding(.bottom)
                
            }
        }
        .padding(.horizontal)
    }
}

struct AppSingleView_Previews: PreviewProvider {
    static var previews: some View {
        AppSingleView()
    }
}

struct FindFriendsListItem: View {
    @State var pet: Pet
    var body: some View {
        HStack(){
            VStack(alignment: .leading, spacing: 4){
                Text(pet.variety + "，" + pet.gender + "，" + pet.description)
                    .font(.footnote)
                    .foregroundColor(Color(#colorLiteral(red: 0.5759999752, green: 0.5839999914, blue: 0.5920000076, alpha: 1)))
                    .lineLimit(2)
                
                HStack{
                    Text(pet.name)
                        .font(.callout)
                    
                    Text("(" + String(format: "%0.1f", pet.coins) + " 币)")
                        .font(.footnote)
                        .foregroundColor(Color(#colorLiteral(red: 0.5759999752, green: 0.5839999914, blue: 0.5920000076, alpha: 1)))
                }
                
                if !pet.protected {
                    Text("宠物已经走失，您若遇到请电话联系，谢谢！")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }
            
            Spacer()
            if !pet.protected {
                Button {
                    guard let number = URL(string: "tel://" + pet.phone) else { return }
                    UIApplication.shared.open(number)
                } label: {
                    Image(systemName: "phone.circle.fill")
                        .font(.title)
                }
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
        .cornerRadius(16)
    }
}

struct FindMyPetFootItem: View {
    let geo: Geo
    var time: String {
        return updateTimeToCurrennTime(timeStamp: geo._createTime)
    }
    @State var address: String = "获取地址中..."
    @EnvironmentObject private var model: TelepoleModel
    @State var isDeleted: Bool = false
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 4) {
                Text(time)
                    .font(.footnote)
                    .foregroundColor(Color(#colorLiteral(red: 0.5759999752, green: 0.5839999914, blue: 0.5920000076, alpha: 1)))
                Text(address)
                    .font(.callout)
                    .lineLimit(2)
            }
            .opacity(isDeleted ? 0.38 : 1)
            Spacer()
            Button {
                isDeleted = true
                Hapitcs().simpleSuccess()
                Hapitcs().simpleError()
                Geo().deleteOneGeo(geo) {
                    model.updateGeos(petID: model.selectedPet.id)
                }
            } label: {
                VStack{
                    Image(systemName: "trash.circle.fill")
                        .font(.title)
                        .foregroundColor(Color(#colorLiteral(red: 0.5759999752, green: 0.5839999914, blue: 0.5920000076, alpha: 1)))
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
        .cornerRadius(16)
        .onAppear {
            AMap().reverseGeocode(latitude: geo.latitude, longitude: geo.longitude) { (add) in
                self.address = add
            }
        }
        .offset(x: isDeleted ? 400 : 0)
        .animation(.easeOut)
    }
}

struct DeleteAllGeos: View {
    let pet: Pet
    @EnvironmentObject private var model: TelepoleModel
    @State private var showingSheet = false
    
    var body: some View {
        HStack {
            Button {
                showingSheet = true
                Hapitcs().simpleWarning()
            } label: {
                Text("批量删除 \(pet.name) 的足迹")
                    .foregroundColor(Color.red)
                    .font(.callout)
                    .bold()
            }
            .actionSheet(isPresented: $showingSheet, content: {
                ActionSheet(
                    title: Text("批量删除 \(pet.name) 的足迹"),
                    message: Text("永久删除，无法恢复"),
                    buttons: [
                        .default(Text("仅保留三天内足迹"), action: {
                            Geo().delete3daysAwayGeo(pet) {
                                model.updateGeos(petID: model.selectedPet.id)
                            }
                        }),
                        .destructive(Text("删除历史所有足迹"),action: {
                            Geo().deleteAllGeo(pet) {
                                model.updateGeos(petID: model.selectedPet.id)
                            }
                        }),
                        .cancel(Text("取消"))
                    ]
                )
            })
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
        .cornerRadius(16)
    }
}
