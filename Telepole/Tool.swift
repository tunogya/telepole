//
//  MapToolSetting.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/17.
//

import SwiftUI
import MapKit

struct Tool: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showStatus: ShowStatus
    @Binding var region: MKCoordinateRegion
    @Binding var trackingMode: MapUserTrackingMode
    @Binding var pickPetID: String
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var userSetting = UserSettings()
    
    @State private var pet: PetModel = PetModel()
    @State private var metric: PetMetricsModel = PetMetricsModel()
    
    @State private var animationAmount: CGFloat = 1
    @State var isShowLocation = false
    
    var userLatitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    var userLongitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    fileprivate func closedAllCard() {
        withAnimation {
            showStatus = ShowStatus(isShowSetting: false, isShowAreaList: false, isShowPetList: false, isShowPetDetail: false, isShowPetInfo: false)
        }
    }
    
    fileprivate func getPetInfo() {
        PetApi().getPetById(pickPetID) { (p) in
            pet = p
        }
        PetApi().getPetMetricsModel(pickPetID) { (m) in
            metric = m
        }
    }
    
    fileprivate func getIsShowLocation() {
        isShowLocation = userSetting.isShareMyLocation
    }
    
    
    var petName: String {
        if pickPetID == "" {
            return "请选择宠物"
        }else {
            return pet.name
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Button(action: {
                        if showStatus.isShowPetList {
                            showStatus.isShowPetList = false
                        }else{
                            closedAllCard()
                            showStatus.isShowPetList = true
                        }
                    }) {
                        Text("🐶")
                            .frame(width: 30, height: 30, alignment: .center)
                            .background(Color(#colorLiteral(red: 0.9787401557, green: 0.8706828952, blue: 0.06605642289, alpha: 1)))
                            .clipShape(Circle())
                            .frame(width: 44, height: 44, alignment: .center)
                    }
                    Button(action: {
                        if showStatus.isShowPetInfo {
                            showStatus.isShowPetInfo = false
                        }else {
                            closedAllCard()
                            self.getPetInfo()
                            showStatus.isShowPetInfo = true
                        }
                    }) {
                        VStack(alignment: .leading){
                            Text(petName)
                                .bold()
                            Text("\(metric.meow_coin_count)币")
                        }
                        .font(.footnote)
                        .foregroundColor(Color(#colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1)))
                        .padding(.trailing)
                        .onAppear(perform: {
                            self.getPetInfo()
                        })
                        .onChange(of: pickPetID, perform: { value in
                            self.getPetInfo()
                        })
                    }
                }
                .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                .cornerRadius(44)
                .frame(height: 44)
                
                Text("🎆")
                    .padding()
                
                Spacer()
            }
            
            Spacer()
            VStack(alignment: .trailing, spacing: 20) {
                Button(action: {
                    if showStatus.isShowSetting {
                        showStatus.isShowSetting  = false
                    }else {
                        closedAllCard()
                        showStatus.isShowSetting = true
                    }
                }) {
                    Text("😀")
                        .frame(width: 44, height: 44, alignment: .center)
                        .font(.title)
                        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                        .clipShape(Circle())
                }
                
                VStack {
                    Button(action: {
                        trackingMode = MapUserTrackingMode.follow
                    }) {
                        Image(systemName: "location.fill")
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    
                    Divider()
                        .frame(width: 44, height: 1, alignment: .center)
                    
                    Button(action: {
                        addRegion(RegionModel(name: "\(region.center.latitude), \(region.center.longitude)", latitude: region.center.latitude, longitude: region.center.longitude, latitudeDelta: region.span.latitudeDelta, longitudeDelta: region.span.longitudeDelta))
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                }
                .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                .cornerRadius(8)
                
                VStack {
                    Button(action: {
                        if showStatus.isShowAreaList {
                            showStatus.isShowAreaList = false
                        }else {
                            closedAllCard()
                            showStatus.isShowAreaList = true
                        }
                    }) {
                        Image(systemName: "map.fill")
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                    .cornerRadius(8)
                }
                
                Spacer()
            }
        }
        .padding()
        .padding(.top, 30)
    }
    
    private func addRegion(_ region: RegionModel) {
        withAnimation {
            let newRegion = Region(context: viewContext)
            newRegion.title = region.name
            newRegion.latitude = region.latitude
            newRegion.longitude = region.longitude
            newRegion.latitudeDelta = region.latitudeDelta
            newRegion.longitudeDelta = region.longitudeDelta
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
}

//struct MapToolSetting_Previews: PreviewProvider {
//    static var previews: some View {
//        MapToolSetting()
//    }
//}
