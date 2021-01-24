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
    @Binding var isShowSetting: Bool
    @Binding var isShowPetList: Bool
    @Binding var isShowAreaList: Bool
    @Binding var region: MKCoordinateRegion
    @Binding var trackingMode: MapUserTrackingMode
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var userSetting = UserSettings()
    
    var userLatitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    var userLongitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    var body: some View {
        HStack {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        isShowPetList.toggle()
                    }) {
                        Image(systemName: "person.circle")
                            .frame(width: 44, height: 44, alignment: .center)
                            .font(.title)
                    }
                   
                    VStack(alignment: .leading){
                        Text("贝贝")
                        Text("200000000币")
                    }
                    .font(.footnote)
                    .padding(.trailing)
                }
                .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                .cornerRadius(44)
               
                
                Spacer()
            }
            Spacer()
            VStack(spacing: 20) {
                Button(action: {
                    isShowSetting.toggle()
                }) {
                    Image(systemName: "person.circle")
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
                        isShowAreaList.toggle()
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
