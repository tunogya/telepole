//
//  AreaListView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/17.
//

import SwiftUI
import MapKit

struct AreaListView: View {
    @Binding var regin: MKCoordinateRegion
    
    @ObservedObject var locationManager = LocationManager()
    
    var userLatitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    
    var userLongitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    fileprivate func updateMapCenter(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        regin = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
    
    var body: some View {
        VStack(spacing: 0){
            SliderIndicator()
                .padding(.top, 12)
            
            VStack {
                HStack {
                    Text("Telepole")
                        .bold()
                    Spacer()
                    Button(action: {
                        print(regin.center.latitude)
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    
                }
                .font(.title2)
                .padding(.horizontal)
                
                Divider()
            }
            
            Form {
                Section(header: Text("我的关注地区")) {
                    Button(action: {
                        let latitude: Double = userLatitude
                        let longitude: Double = userLongitude
                        updateMapCenter(latitude: latitude, longitude: longitude)
                    }) {
                        HStack {
                            Image(systemName: "location.fill")
                            Text("我的位置")
                        }
                    }
                    
                    Button(action: {
                        let latitude: Double = 30.001
                        let longitude: Double = 100.03
                        updateMapCenter(latitude: latitude, longitude: longitude)
                    }) {
                        Text("地区2")
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .cornerRadius(20)
    }
}
//struct AreaListView_Previews: PreviewProvider {
//    static var previews: some View {
//        AreaListView()
//    }
//}
