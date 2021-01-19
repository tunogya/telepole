//
//  AreaView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/18.
//

import SwiftUI
import MapKit

struct AreaView: View {
    @Binding var isShowArea: Bool
    @Binding var regin: MKCoordinateRegion
    
    var body: some View {
        VStack(spacing: 0) {
            CardTitleClosed(flag: $isShowArea, title: "\(regin.center.latitude)")
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
