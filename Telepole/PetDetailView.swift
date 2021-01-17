//
//  PetDetailView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/17.
//

import SwiftUI

struct PetDetailView: View {
    @Binding var isShowDetail: Bool
    
    var body: some View {
        VStack{
            SliderIndicator()
                .padding(.top, 12)
            // 标题
            HStack(spacing: 20) {
                Text("贝贝")
                    .bold()
                
//                Text("关注")
//                    .font(.body)
//                    .foregroundColor(Color("GrayColor"))
                Spacer()
                
                Button(action: {
                    isShowDetail = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            .font(.title2)
            .padding(.horizontal)
            
            
            Divider()
                
            // 信息介绍
            PetInfo()
                .padding(.horizontal)
            
            // 我的动态
            MyLife()
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
