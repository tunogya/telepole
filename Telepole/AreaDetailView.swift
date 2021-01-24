//
//  AreaView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/18.
//

import SwiftUI
import MapKit

struct AreaDetailView: View {
    @Binding var isShowArea: Bool
    @Binding var mapRegin: MKCoordinateRegion
    
    var body: some View {
        VStack(spacing: 0) {
            CardHeader(flag: $isShowArea, hasEditButton: false, title: "\(mapRegin.center.latitude)")
            Spacer()
        }
//        .background(Color(.systemGroupedBackground))
        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
        .cornerRadius(20)
    }
}

//struct AreaView_Previews: PreviewProvider {
//    static var previews: some View {
//        AreaView()
//    }
//}
