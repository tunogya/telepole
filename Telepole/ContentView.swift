//
//  AboutView.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.
//

import SwiftUI
import MapKit

var SCREENWIDTH = UIScreen.main.bounds.width
var SCREENHEIGHT = UIScreen.main.bounds.height

// 显示
private let OFFSET_S = CGSize(width: 0, height: SCREENHEIGHT - 240)
private let OFFSET_M = CGSize(width: 0, height: 100)
// 触摸保持距离
private let KEEPDISTENCE: CGFloat = 100

struct ContentView: View {
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    @ObservedObject var userSetting = UserSettings()
    @ObservedObject var locationManager = LocationManager()
    var userLatitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    var userLongitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.6, longitude: -122),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    )
    @State private var dragOffset = OFFSET_S
    @State private var varOffset = CGSize.zero
    @State private var currentOffset = OFFSET_S
    @State private var isShowDetail = false
    @State private var isShowSetting = false
    @State private var isShowArea = false
    @State private var isShowPetList = false
    @State private var trackingMode = MapUserTrackingMode.none
    
//    @State private var pickPet: PetModel = PetModel
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                varOffset = value.translation
                
                if currentOffset == OFFSET_M {
                    if varOffset.height < 0 {
                        dragOffset.height = currentOffset.height
                    }else{
                        dragOffset.height = currentOffset.height + varOffset.height
                    }
                }else if currentOffset == OFFSET_S {
                    if varOffset.height > 0 {
                        dragOffset.height = currentOffset.height
                    }else{
                        dragOffset.height = currentOffset.height + varOffset.height
                    }
                }
            }
            .onEnded { value in
                // 控制滑动
                if currentOffset == OFFSET_M {
                    if varOffset.height <= KEEPDISTENCE && varOffset.height >= 0{
                        dragOffset = OFFSET_M
                    }else if varOffset.height > KEEPDISTENCE {
                        dragOffset = OFFSET_S
                    }else{
                        dragOffset = OFFSET_M
                    }
                }else if currentOffset == OFFSET_S {
                    if varOffset.height >= -KEEPDISTENCE && varOffset.height <= 0 {
                        dragOffset = OFFSET_S
                    }else if varOffset.height < -KEEPDISTENCE {
                        dragOffset = OFFSET_M
                    }else{
                        dragOffset = OFFSET_S
                    }
                }else{
                    dragOffset = OFFSET_S
                }
                // 将滑动写入当前的Offset
                currentOffset = dragOffset
            }
    }
    
    fileprivate func updateMapCenter(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        )
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: $trackingMode)
//                .onAppear(perform: {
//                    updateMapCenter(latitude: userLatitude, longitude: userLongitude)
//                })
                .onReceive(timer) { (time) in
                    if userSetting.isShareMyLocation{
                        GeoApi().postMyGeo(GeoModel(pet: PetModel(id: "测试", name: "test", username: "test", description: "test", profile_image_url: "sss", protected: true, verified: true, variety: "杜宾", gender: "boy"), name: "测试地址", latitude: userLatitude, longitude: userLongitude))
                    }else{
                        print("no")
                    }
                }
            
            Tool(isShowSetting: $isShowSetting, region: $mapRegion, isShowPetList: $isShowPetList, trackingMode: $trackingMode)
            
            VStack{
                HStack {
                    Text("userLocation: ")
                    Text("\(userLatitude),")
                    Text("\(userLongitude)")
                }
                
                HStack {
                    Text("mapRegion:")
                    Text("\(mapRegion.center.latitude),")
                    Text("\(mapRegion.center.longitude)")
                }
                Text("isShareMyLocation:" + String(describing: userSetting.isShareMyLocation))
                Text("trackingMode:" + String(describing: userSetting.trackingMode))
            }
            
            // 关心的地区列表
            AreaListView(mapRegion: $mapRegion, isShowArea: $isShowArea)
                .ignoresSafeArea(.all)
                .animation(.easeInOut)
                .offset(y: dragOffset.height)
                .gesture(drag)
                .animation(.spring())
            
            AreaDetailView(isShowArea: $isShowArea, mapRegin: $mapRegion)
                .ignoresSafeArea(.all)
                .animation(.easeInOut)
                .offset(y: dragOffset.height)
                .gesture(drag)
                .offset(y: isShowArea ? 0 : SCREENHEIGHT)
                .animation(.spring())
            
            PetListView(isShowPetList: $isShowPetList)
                .ignoresSafeArea(.all)
                .animation(.easeInOut)
                .offset(y: dragOffset.height)
                .gesture(drag)
                .offset(y: isShowPetList ? 0 : SCREENHEIGHT)
                .animation(.spring())
            
            SettingView(isShowSetting: $isShowSetting, trackingMode: $trackingMode)
                .ignoresSafeArea(.all)
                .animation(.easeInOut)
                .offset(y: dragOffset.height)
                .gesture(drag)
                .offset(y: isShowSetting ? 0 : SCREENHEIGHT)
                .animation(.spring())
        }
        .ignoresSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
