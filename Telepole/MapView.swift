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
            
            DetailView()
            
            
        }
            .ignoresSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}


struct DetailView: View {
    var body: some View {
        VStack{
            HStack {
                Text("周围的人")
                    .font(.title3)
                Spacer()
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding(.top, 30)
    }
}
