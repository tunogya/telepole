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
    
    var time: String {
        return updateTimeToCurrennTime(timeStamp: model.lastGeos.first!._createTime)
    }
    
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
    
    var petGeoInfo: some View {
        VStack(alignment: .leading, spacing: 4){
            Button {
                model.autoUpdateGeos(petID: model.selectedPet.id)
            } label: {
                HStack(spacing: 4) {
                    Text("获取宠物足迹")
                        .padding(6)
                        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                        .cornerRadius(8)
                    Text(model.isLoading ? "Loading..." : "")
                        .foregroundColor(Color(#colorLiteral(red: 0.5759999752, green: 0.5839999914, blue: 0.5920000076, alpha: 1)))
                }
                .font(.footnote)
            }
            .disabled(model.selectedPet.id.isEmpty ? true : false)
            .animation(.easeIn)
            
            Text(model.lastAddress)
                .font(.callout)
            
            if !model.selectedPet.id.isEmpty && !model.lastGeos.first!._createTime.isZero {
//                Text("经度:\(model.lastGeos.first!.longitude)，纬度:\(model.lastGeos.first!.latitude)")
//                    .font(.footnote)
                Text(time)
                    .font(Font.custom("Herculanum", size: 10))
                    .foregroundColor(Color(#colorLiteral(red: 0.5759999752, green: 0.5839999914, blue: 0.5920000076, alpha: 1)))
            }
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
        Button {
            withAnimation(Animation.easeInOut(duration: 1)) {
                taps += 1
            }
            let geo = Geo(pet: model.selectedPet, name: model.account.id, latitude: locationManager.lastLocation?.coordinate.latitude ?? 0, longitude: locationManager.lastLocation?.coordinate.longitude ?? 0)
            Geo().postMyGeo(geo){
                model.autoUpdateGeos(petID: model.selectedPet.id)
            }
        } label:{
            VStack{
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .modifier(Bounce(animCount: CGFloat(taps)))
                    .foregroundColor(Color(model.selectedPet.id == "" ? #colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1) : #colorLiteral(red: 0.9787401557, green: 0.8706828952, blue: 0.06605642289, alpha: 1)))
                Text("上报位置")
                    .font(.footnote)
                    .foregroundColor(Color(#colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1)))
            }
        }
       
        .disabled(model.selectedPet.id.isEmpty ? true : false)
    }
    
    var callMeButton: some View {
        Button {
            guard let number = URL(string: "tel://" + model.selectedPet.phone) else { return }
            UIApplication.shared.open(number)
        } label: {
            VStack{
                Image(systemName: "phone.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .foregroundColor(Color(model.selectedPet.id == "" ? #colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1) : #colorLiteral(red: 0.9789028764, green: 0.8711864352, blue: 0.06549777836, alpha: 1)))
                Text("联系主人")
                    .font(.footnote)
                    .foregroundColor(Color(#colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1)))
            }
        }
        .disabled(model.selectedPet.id.isEmpty ? true : false)
    }
    
    var wakandaSlogan: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Telepole")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Button {
                    isShowWakanda.toggle()
                } label: {
                    Text("@Wakanda")
                        .font(.caption)
                        .padding(.leading, 4)
                        .foregroundColor(Color(#colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1)))
                }
            }
           
            Text("Go wild, go beyond!")
                .font(.title)
                .fontWeight(.light)
        }
        .padding(.vertical)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    MapView()
                        .padding(.top, 80)
                    
                    wakandaSlogan
                    
                    petGeoInfo
                }
                .animation(Animation.openMap)
            }
            
            VStack(alignment: .leading){
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
                .padding(.vertical)
                
                Spacer()
                
                HStack {
                    Spacer()
                    HStack(spacing: 24) {
                        sendGeoButton
                        callMeButton
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                    .cornerRadius(20)
                }
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
