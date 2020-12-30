//
//  AboutView.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/23.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit

var SCREENWIDTH = UIScreen.main.bounds.width
var SCREENHEIGHT = UIScreen.main.bounds.height

struct AboutView: View {
    let pet: Pet
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        Map(coordinateRegion: $region)
            .ignoresSafeArea(.all)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        let pet = Pet(id: "duchsjcsi", name: "贝贝", variety: "杜宾犬", address: "南通市 ", avator:URL(string: "https://6672-free-8ghoiy21db9c8ed0-1304586669.tcb.qcloud.la/cloudbase-cms/upload/2020-12-28/blbwbh8jfevpe6dpahcoik8uz1kc5o6f_.jpeg")!, birthday: "1996.05", gender: "Boy")
        AboutView(pet: pet)
    }
}
