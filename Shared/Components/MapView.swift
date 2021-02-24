//
//  MapView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/16.
//

import SwiftUI
import MapKit
import Foundation

struct MapView: View {
    @State private var mapRegion = MKCoordinateRegion()
    @State private var trackingMode = MapUserTrackingMode.none
    @State private var percent: Double = 10
    @EnvironmentObject private var model: TelepoleModel
    
    func getOpacity(timeInterval: Double) -> Double {
        let diff = (Date().timeIntervalSince1970 - timeInterval) / 86400 * percent
        return 1 - 2 * atan(diff) / Double.pi
    }
    
    var speedSlider: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color(#colorLiteral(red: 0.5759999752, green: 0.5839999914, blue: 0.5920000076, alpha: 1)))
                    .opacity(0.5)
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: geometry.size.width * CGFloat(self.percent / 100))
                    .opacity(0.8)
                HStack{
                    Image(systemName: "tortoise.fill")
                    Spacer()
                    Image(systemName: "hare.fill")
                }
                .padding(.horizontal, 8)
                .font(.footnote)
            }
            .cornerRadius(8)
            .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            self.percent = min(max(10, Double(value.location.x / geometry.size.width * 100)), 100)
                        }))
        }
    }
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $mapRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: $trackingMode, annotationItems: model.lastGeos) { geo in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: geo.latitude, longitude: geo.longitude),
                    anchorPoint: CGPoint(x: 0.5, y: 0.5)
                ) {
                    VStack{
                        Text("🐕")
                            .font(.body)
                        Text(updateTimeToCurrennTime(timeStamp: geo._createTime))
                            .font(Font.custom("Herculanum", size: 10))
                            .fontWeight(.heavy)
                            .foregroundColor(Color(#colorLiteral(red: 0.9789028764, green: 0.8711864352, blue: 0.06549777836, alpha: 1)))
                    }
                    .opacity(getOpacity(timeInterval: geo._createTime))
                }
            }
            .onAppear(perform: {
                self.trackingMode = MapUserTrackingMode.follow
            })
            
            VStack {
                Spacer()
                HStack(alignment: .bottom){
                    VStack(alignment: .leading, spacing: 4){
                        Text("消逝速度")
                            .font(Font.custom("Herculanum", size: 10))
                            .fontWeight(.heavy)
                            .padding(.horizontal, 8)
                        speedSlider
                            .frame(height: 28)
                    }
                    Button(action: {
                        self.trackingMode = MapUserTrackingMode.follow
                    }, label: {
                        Image(systemName: "scope")
                            .font(.body)
                            .padding(8)
                            .foregroundColor(Color(#colorLiteral(red: 0.9787401557, green: 0.8706828952, blue: 0.06605642289, alpha: 1)))
                            .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                            .clipShape(Circle())
                    })
                }
                .padding()
            }
        }
        .cornerRadius(24)
        .frame(height: SCREENHEIGHT*0.4)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
