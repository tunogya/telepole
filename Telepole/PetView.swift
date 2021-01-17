//
//  PetDetailView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/17.
//

import SwiftUI

struct PetView: View {
    @Binding var isShowDetail: Bool
    
    var body: some View {
        VStack{
            SliderIndicator()
                .padding(.top, 12)
            // 标题
            CardTitle(flag: $isShowDetail, title: "贝贝")
                
            // 信息介绍
            PetInfo()
                .padding(.horizontal)
            
            // 我的动态
            PetTelepole()
                .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .cornerRadius(20)
    }
}

//struct PetDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PetDetailView()
//    }
//}
