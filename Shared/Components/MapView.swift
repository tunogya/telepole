//
//  MapView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/16.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var mapRegion = MKCoordinateRegion()
    @State private var trackingMode = MapUserTrackingMode.none
    @State private var isOnlyShowLatest: Bool = true
    @EnvironmentObject private var model: TelepoleModel
    
    var geos: [Geo] {
        if isOnlyShowLatest {
            return [model.lastGeos.first!]
        }
        return model.lastGeos
    }
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $mapRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: $trackingMode, annotationItems: geos) { geo in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: geo.latitude, longitude: geo.longitude),
                    anchorPoint: CGPoint(x: 0.5, y: 0.5)
                ) {
                    VStack{
                        Text("🐕")
                        Text(updateTimeToCurrennTime(timeStamp: geo._createTime))
                    }
                    .font(.body)
                }
            }
            .onAppear(perform: {
                self.trackingMode = MapUserTrackingMode.follow
            })
            
            VStack {
                Spacer()
                HStack{
                    Button {
                        isOnlyShowLatest.toggle()
                    } label: {
                        Text(!isOnlyShowLatest ? "最新足迹" : "所有足迹")
                            .font(.footnote)
                            .padding(8)
                            .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                            .cornerRadius(10)
                    }

                    Spacer()
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
