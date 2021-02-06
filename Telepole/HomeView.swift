//
//  HomeView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/5.
//

import SwiftUI
import MapKit

var SCREENWIDTH = UIScreen.main.bounds.width
var SCREENHEIGHT = UIScreen.main.bounds.height

struct HomeView: View {
    @State private var isShowPetRegisterView = false
    @State private var isShowSettingView = false
    @State private var isSmallMap = true
    @State private var phoneNumber = 0
    @State private var pet: PetModel = PetModel()
    @State private var pickPetID: String = ""
    
    fileprivate func getPetInfo() {
        PetApi().getPetById(pickPetID) { (p) in
            pet = p
        }
    }
    
    var petname: String {
        if pet.name == "" {
            return "暂无宠物"
        }
        return pet.name
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // 宠物图标
                HomePetInfoView(name: petname, coins: pet.coins)
                    .onAppear(perform: {
                        self.getPetInfo()
                    })
                    .onChange(of: pickPetID, perform: { value in
                        self.getPetInfo()
                    })
                
                ButtonRegisterPet(isPresent: $isShowPetRegisterView)
                    .sheet(isPresented: $isShowPetRegisterView) {
                        PetRegisterView(isShow: $isShowPetRegisterView, pickPetID: $pickPetID)
                    }
                    
                Spacer()
                // 个人图标
                HomeUserInfoView(isPresent: $isShowSettingView)
                    .sheet(isPresented: $isShowSettingView) {
                        SettingView(isShow: $isShowSettingView)
                    }
            }
            .padding(.vertical)
            
            // 地图
            HomeMapView()
                .cornerRadius(24)
                .frame(height: isSmallMap ? SCREENWIDTH*0.618 : SCREENWIDTH*1.114)
            
            // 附近的人
            WakandaSlogan(isShowDetail: $isSmallMap)
                .padding(.vertical)
            
            Spacer()
            
            HStack {
                Spacer()
                CallMeButton(phoneNumber: $phoneNumber)
            }
        }
        .padding(.horizontal)
        .animation(.spring(dampingFraction: 0.618))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


struct HomePetInfoView: View {
    var name: String
    var coins: Double
    var body: some View {
        Button(action: {
        }) {
            HStack(spacing: 0){
                Text("🐶")
                    .frame(width: 30, height: 30, alignment: .center)
                    .background(Color(#colorLiteral(red: 0.9787401557, green: 0.8706828952, blue: 0.06605642289, alpha: 1)))
                    .clipShape(Circle())
                    .frame(width: 44, height: 44, alignment: .center)
                
                VStack(alignment: .leading){
                    Text(name)
                        .bold()
                    Text(String(format: "%0.1f", coins) + " 币")
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
}

struct HomeUserInfoView: View {
    @State var status: String = "😀"
    @Binding var isPresent: Bool
    var body: some View {
        Button(action: {
            isPresent = true
        }) {
            Text(status)
                .frame(width: 44, height: 44, alignment: .center)
                .font(.title)
                .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                .clipShape(Circle())
        }
    }
}


struct HomeMapView: View {
    @State private var mapRegion = MKCoordinateRegion()
    @State private var trackingMode = MapUserTrackingMode.none
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $mapRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: $trackingMode)
                .onAppear(perform: {
                    self.trackingMode = MapUserTrackingMode.follow
                })
            
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        self.trackingMode = MapUserTrackingMode.follow
                    }, label: {
                        Image(systemName: "scope")
                            .font(.body)
                            .padding(8)
                            .foregroundColor(Color(#colorLiteral(red: 0.9787401557, green: 0.8706828952, blue: 0.06605642289, alpha: 1)))
                            .background(Color.white)
                            .clipShape(Circle())
                            .padding()
                    })
                }
            }
        }
    }
}


struct ButtonRegisterPet: View {
    @Binding var isPresent: Bool
    
    var body: some View {
        Button {
            isPresent = true
        } label: {
            Image(systemName: "plus.circle")
                .font(.title3)
        }
        
    }
}

struct WakandaSlogan: View {
    @Binding var isShowDetail: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Telepole")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Button {
                    isShowDetail.toggle()
                } label: {
                    Text("#Wakanda")
                        .font(.caption)
                        .padding(.leading, 4)
                        .foregroundColor(Color(#colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1)))
                }
            }
           
            Text("Go wild, go beyond!")
                .font(.title)
                .fontWeight(.light)
        }
    }
}


struct CallMeButton: View {
    @Binding var phoneNumber: Int
    
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: "phone.circle.fill")
                .resizable()
                .frame(width: 60, height: 60, alignment: .center)
        }
    }
}

struct ShowAllPetButton: View {
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle")
                .font(.body)
        }
    }
}
