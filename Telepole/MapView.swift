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

private let OFFSET_S = CGSize(width: 0, height: SCREENHEIGHT - 240)
// 半屏显示
private let OFFSET_M = CGSize(width: 0, height: 160)

// 触摸保持距离
private let KeepDistance: CGFloat = 100



struct MapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var dragOffset = OFFSET_S                // 每次拖拽
    @State var varOffset = CGSize.zero
    @State var currentOffset = OFFSET_S
    @State var isShowDetail = true
    
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
                    if varOffset.height <= KeepDistance && varOffset.height >= 0{
                        dragOffset = OFFSET_M
                    }else if varOffset.height > KeepDistance {
                        dragOffset = OFFSET_S
                    }else{
                        dragOffset = OFFSET_M
                    }
                }else if currentOffset == OFFSET_S {
                    if varOffset.height >= -KeepDistance && varOffset.height <= 0 {
                        dragOffset = OFFSET_S
                    }else if varOffset.height < -KeepDistance {
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
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region)
            
            PetListView(isShowDetail: $isShowDetail)
                .ignoresSafeArea(.all)
                .animation(.easeInOut)
                .offset(y: dragOffset.height)
                .gesture(drag)
                .animation(.spring())
            
            PetDetailView(isShowDetail: $isShowDetail)
                .ignoresSafeArea(.all)
                .animation(.easeInOut)
                .offset(y: dragOffset.height)
                .gesture(drag)
                .offset(y: isShowDetail ? 0 : SCREENHEIGHT)
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

struct PetListView: View {
    @Binding var isShowDetail: Bool
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.secondary)
                .frame(width: 46, height: 6, alignment: .center)
                .padding(.top, 12)
            
            Form {
                Section(header: Text("附近")) {
                    Button(action: {
                        isShowDetail = true
                    }) {
                        Text("七喜")
                    }
                }
                
                Section(header: Text("更远")) {
                    Button(action: {
                        isShowDetail = true
                    }) {
                        Text("贝贝")
                    }
                }
                
            }
        }
        .background(Color(.systemGroupedBackground))
        .cornerRadius(20)
    }
}

struct PetDetailView: View {
    @Binding var isShowDetail: Bool
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.secondary)
                .frame(width: 46, height: 6, alignment: .center)
                .padding(.top, 12)
            
            // 标题
            HStack(spacing: 20) {
                Text("贝贝")
                    .bold()
                    .foregroundColor(.black)
                
                Text("关注")
                    .font(.body)
                    .foregroundColor(.accentColor)
                Spacer()
                
                Button(action: {
                    isShowDetail = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            .font(.title2)
            .padding(.horizontal)
            
            
            Divider()
                
            // 信息介绍
            PetInfo()
                .padding(.horizontal)
            
            // 我的动态
            MyLife()
                .padding(.horizontal)
            
        
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .cornerRadius(20)
    }
}

struct PetInfo: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("贝贝的介绍")
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.body)
            
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "location")
                    Text("距离你25km")
                        .padding(.leading, -4)
                        .padding(.trailing, 6)
                    Image(systemName: "calendar")
                    Text("2020年8月加入")
                        .padding(.leading, -4)
                    Spacer()
                }
                HStack {
                    Group {
                        Text("500")
                            .bold()
                            .foregroundColor(.black)
                        Text("喵喵币")
                            .padding(.leading, -4)
                            .padding(.trailing, 6)
                    }
                    
                    Group {
                        Text("2000")
                            .bold()
                            .foregroundColor(.black)
                        Text("关注者")
                            .padding(.leading, -4)
                    }
                    
                    Spacer()
                }
            }
            .font(.footnote)
            .foregroundColor(.secondary)
            
        }
        .padding(.vertical, 10)
    }
}

struct MyLife: View {
    @State var pickerIndex = 1
    
    var body: some View {
        Picker(selection: $pickerIndex, label: Text("Picker")) {
            Text("朋友圈").tag(1)
            Text("照片").tag(2)
            Text("直播").tag(3)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}
