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

struct MapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region)
            
            PetListView()
                .offset(y: 200)
            
            PetDetailView()
                .offset(y: 200)
            
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
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.secondary)
                .frame(width: 46, height: 6, alignment: .center)
                .padding(.top, 12)
            
            Form {
                Section(header: Text("附近")) {
                    Text("七喜")
                }
                
                Section(header: Text("更远")) {
                    Text("贝贝")
                }
                
            }
        }
        .background(Color(.systemGroupedBackground))
        .cornerRadius(20)
    }
}


struct PetDetailView: View {
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
                
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
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
                            .foregroundColor(.accentColor)
                        Text("喵喵币")
                            .padding(.leading, -4)
                            .padding(.trailing, 6)
                    }
                    
                    Group {
                        Text("2000")
                            .bold()
                            .foregroundColor(.accentColor)
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
