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
    
    fileprivate func updateMapCenter(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        regin = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
    
    var body: some View {
        VStack{
            SliderIndicator()
                .padding(.top, 12)
            
            Form {
                Section(header: Text("我的关注地区")) {
                    Button(action: {
                        let latitude: Double = 12.001
                        let longitude: Double = 120.03
                        updateMapCenter(latitude: latitude, longitude: longitude)
                    }) {
                        Text("地区1")
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
