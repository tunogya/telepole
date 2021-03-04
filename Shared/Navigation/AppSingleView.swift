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
    @State private var status: String = "😀"
    @EnvironmentObject private var model: TelepoleModel
    @ObservedObject var locationManager = LocationManager()
    
    @State var taps = 0
    @State var pageIndex = 0
    var petInfo: some View {
        Button(action: {
        }) {
            HStack(spacing: 0){
                Text("🐶")
                    .frame(width: 30, height: 30, alignment: .center)
                    .background(Color(#colorLiteral(red: 0.9787401557, green: 0.8706828952, blue: 0.06605642289, alpha: 1)))
                    .clipShape(Circle())
                    .frame(width: 44, height: 44, alignment: .center)
                
                VStack(alignment: .leading){
                    Text(model.selectedPet.petname)
                        .bold()
                    Text(String(format: "%0.1f", model.selectedPet.coins) + " 币")
                }
                .font(.footnote)
                .foregroundColor(Color(#colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1)))
                .padding(.trailing)
            }
            .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
            .cornerRadius(44)
            .frame(height: 44)
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
            Image(systemName: "plus.circle")
                .font(.title3)
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
                        
                        FormPicker(index: $pageIndex, page: ["我的", "新朋友"])
                            .padding(.leading)
                    }
                    .padding(.bottom, 12)
                    
                    if pageIndex == 0 {
                        ForEach(model.lastGeos){ geo in
                            FindMyPetFootItem(geo: geo)
                                .padding(.bottom, 4)
                        }
                    } else {
                        ForEach(model.lastGeos){ geo in
                            FindOtherPetFootItem(geo: geo)
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

struct FindOtherPetFootItem: View {
    let geo: Geo
    var time: String {
        return updateTimeToCurrennTime(timeStamp: geo._createTime)
    }
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 4){
                Text("姓名")
                    .font(.footnote)
                    .foregroundColor(Color(#colorLiteral(red: 0.5759999752, green: 0.5839999914, blue: 0.5920000076, alpha: 1)))
                Text(geo.pet.name)
                    .font(.callout)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 4){
                Text("品种")
                    .font(.footnote)
                    .foregroundColor(Color(#colorLiteral(red: 0.5759999752, green: 0.5839999914, blue: 0.5920000076, alpha: 1)))
                Text(geo.pet.variety)
                    .font(.callout)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 4){
                Text("时间")
                    .font(.footnote)
                    .foregroundColor(Color(#colorLiteral(red: 0.5759999752, green: 0.5839999914, blue: 0.5920000076, alpha: 1)))
                Text(time)
                    .font(.callout)
            }
            Spacer()
            Button {
                guard let number = URL(string: "tel://" + geo.pet.phone) else { return }
                UIApplication.shared.open(number)
            } label: {
                VStack{
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
//                Hapitcs().simpleSuccess()
                Hapitcs().simpleError()
                Geo().deleteMyGeo(geo) {
                    model.updateGeos(petID: model.selectedPet.id)
                }
            } label: {
                VStack{
                    Image(systemName: "trash.circle.fill")
                        .font(.title)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
        .cornerRadius(16)
        .onAppear {
            model.reverseGeocode(latitude: geo.latitude, longitude: geo.longitude) { (add) in
                self.address = add
            }
        }
        .offset(x: isDeleted ? 400 : 0)
        .animation(.easeOut)
    }
}
