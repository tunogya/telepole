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

struct MapView: View {
    @ObservedObject var locationManager = LocationManager()
    
    var userLatitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    
    var userLongitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var dragOffset = OFFSET_S
    @State private var varOffset = CGSize.zero
    @State private var currentOffset = OFFSET_S
    @State private var isShowDetail = false
    @State private var isShowSetting = false
    @State private var isShowArea = false
    
    @State private var trackingMode = MapUserTrackingMode.follow
    
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
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $trackingMode)
                .onAppear(perform: {
                    debugPrint("la: \(userLatitude), lo: \(userLongitude)")
                    updateMapCenter(latitude: userLatitude, longitude: userLongitude)
                })
            
            MapToolSetting(isShowSetting: $isShowSetting)
            
            // 关心的地区列表
            AreaListView(region: $region, isShowArea: $isShowArea)
                .ignoresSafeArea(.all)
                .animation(.easeInOut)
                .offset(y: dragOffset.height)
                .gesture(drag)
                .animation(.spring())
            
            AreaView(isShowArea: $isShowArea, regin: $region)
                .ignoresSafeArea(.all)
                .animation(.easeInOut)
                .offset(y: dragOffset.height)
                .gesture(drag)
                .offset(y: isShowArea ? 0 : SCREENHEIGHT)
                .animation(.spring())
            
            // 宠物信息
            PetView(isShowDetail: $isShowDetail)
                .ignoresSafeArea(.all)
                .animation(.easeInOut)
                .offset(y: dragOffset.height)
                .gesture(drag)
                .offset(y: isShowDetail ? 0 : SCREENHEIGHT)
                .animation(.spring())
            
            SettingView(isShowSetting: $isShowSetting)
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
        MapView()
    }
}
