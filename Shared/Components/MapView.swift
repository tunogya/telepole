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
    @EnvironmentObject private var model: TelepoleModel
    
    func getOpacity(timeInterval: Double) -> Double {
        let diff = (Date().timeIntervalSince1970 - timeInterval) / 864000
        return 1 - 2 * atan(diff) / Double.pi
    }
    
    var wakandaSlogan: some View {
        HStack {
            Text("Telepole")
                .font(.body)
                .fontWeight(.bold)
            
            Text("@Wakanda")
                .font(.caption)
                .foregroundColor(Color(#colorLiteral(red: 0.5759999752, green: 0.5839999914, blue: 0.5920000076, alpha: 1)))
                .padding(.leading, 4)
        }
        .padding(4)
    }
    
    var annotation: [Geo] {
        model.myGeos + model.friendGeos
    }
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $mapRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: $trackingMode, annotationItems: annotation) { geo in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: geo.latitude, longitude: geo.longitude),
                    anchorPoint: CGPoint(x: 0.5, y: 0.5)
                ) {
                    VStack(spacing: 4){
                        Text(geo.pet.name + ", " + updateTimeToCurrennTime(timeStamp: geo._createTime) + (geo.pet.protected ? "": ", 丢失"))
                            .font(Font.custom("Herculanum", size: 10))
                            .fontWeight(.heavy)
                            .padding(6)
                            .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                            .cornerRadius(8)
                        Text("🐶")
                            .font(.footnote)
                            .padding(4)
                            .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                            .clipShape(Circle())
                    }
                    .opacity(getOpacity(timeInterval: geo._createTime))
                }
            }
            .onAppear(perform: {
                self.trackingMode = MapUserTrackingMode.follow
            })
            
            VStack(alignment: .leading) {
                wakandaSlogan
                Spacer()
                HStack(alignment: .bottom){
                    Spacer()
                    Button(action: {
                        self.trackingMode = MapUserTrackingMode.follow
                    }, label: {
                        Image(systemName: "scope")
                            .font(.body)
                            .padding(8)
                            .foregroundColor(Color(#colorLiteral(red: 0.1490196078, green: 0.07058823529, blue: 0.3098039216, alpha: 1)))
                            .background(Color.white)
                            .clipShape(Circle())
                    })
                }
                .padding()
            }
        }
        .cornerRadius(24)
        .frame(height: SCREENHEIGHT*0.5)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
