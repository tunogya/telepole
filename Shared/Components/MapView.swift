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
    
    @EnvironmentObject private var model: TelepoleModel
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $mapRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: $trackingMode)
                .onAppear(perform: {
                    self.trackingMode = MapUserTrackingMode.follow
                })
            
            VStack {
                Spacer()
                HStack{
                    Button {
                        let geo = Geo(pet: model.selectedPet, name: model.account.id, latitude: locationManager.lastLocation?.coordinate.latitude ?? 0, longitude: locationManager.lastLocation?.coordinate.longitude ?? 0)
                        Geo().postMyGeo(geo)
                    } label: {
                        Text("宠物辅助定位")
                            .font(.footnote)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
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
                    })
                }
                .padding()
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
