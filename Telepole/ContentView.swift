//
//  AboutView.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.
//

import SwiftUI
import MapKit

// 显示
private let OFFSET_S = CGSize(width: 0, height: SCREENHEIGHT - 240)
private let OFFSET_M = CGSize(width: 0, height: 100)
// 触摸保持距离
private let KEEPDISTENCE: CGFloat = 100

struct ShowStatus {
    var isShowSetting: Bool
    var isShowPetList: Bool
    var isShowPetDetail: Bool
    var isShowPetInfo: Bool
}

struct ContentView: View {
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    @ObservedObject var userSetting = UserSettings()
    @ObservedObject var locationManager = LocationManager()
    
    @State private var mapRegion = MKCoordinateRegion()
    @State private var dragOffset = OFFSET_S
    @State private var varOffset = CGSize.zero
    @State private var currentOffset = OFFSET_S
    @State private var showStatus = ShowStatus(isShowSetting: false, isShowPetList: false, isShowPetDetail: false, isShowPetInfo: false)
    @State private var trackingMode = MapUserTrackingMode.none
    
    @State private var currentPetID = ""
    
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
                    dragOffset.height = currentOffset.height + varOffset.height
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
                    if varOffset.height >= -KEEPDISTENCE && varOffset.height <= KEEPDISTENCE {
                        dragOffset = OFFSET_S
                    }else if varOffset.height < -KEEPDISTENCE {
                        dragOffset = OFFSET_M
                    }else{
                        dragOffset = OFFSET_S
                        closedAllCard()
                    }
                }else{
                    dragOffset = OFFSET_S
                }
                // 将滑动写入当前的Offset
                currentOffset = dragOffset
            }
    }
    
    fileprivate func closedAllCard() {
        withAnimation {
            showStatus = ShowStatus(isShowSetting: false, isShowPetList: false, isShowPetDetail: false, isShowPetInfo: false)
        }
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: $trackingMode)
                .onAppear(perform: {
                    self.trackingMode = MapUserTrackingMode.follow
                })
            
            Tool(showStatus: $showStatus, region: $mapRegion, trackingMode: $trackingMode, pickPetID: $currentPetID)
            
            PetListView(showStatus: $showStatus, petID: $currentPetID)
                .ignoresSafeArea(.all)
                .animation(.easeInOut)
                .offset(y: dragOffset.height)
                .gesture(drag)
                .offset(y: showStatus.isShowPetList ? 0 : SCREENHEIGHT)
                .animation(.spring())
            
            SettingView(showStatus: $showStatus, trackingMode: $trackingMode)
                .ignoresSafeArea(.all)
                .animation(.easeInOut)
                .offset(y: dragOffset.height)
                .gesture(drag)
                .offset(y: showStatus.isShowSetting ? 0 : SCREENHEIGHT)
                .animation(.spring())
            
            PetInfoView(showStatus: $showStatus, pickPetID: $currentPetID)
                .ignoresSafeArea(.all)
                .animation(.easeInOut)
                .offset(y: dragOffset.height)
                .gesture(drag)
                .offset(y: showStatus.isShowPetInfo ? 0 : SCREENHEIGHT)
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
