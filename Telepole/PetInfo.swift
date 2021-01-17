//
//  PetInfo.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/17.
//

import SwiftUI

struct PetInfo: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("贝贝的介绍")
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.body)
            
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "location")
                    Text("距离你25km")
                        .padding(.leading, -4)
                        .padding(.trailing, 6)
                    Image(systemName: "calendar")
                    Text("2020年8月加入")
                        .padding(.leading, -4)
                    Spacer()
                }
                HStack {
                    Group {
                        Text("500")
                            .bold()
                            .foregroundColor(.black)
                        Text("喵喵币")
                            .padding(.leading, -4)
                            .padding(.trailing, 6)
                    }
                    
                    Group {
                        Text("2000")
                            .bold()
                            .foregroundColor(.black)
                        Text("关注者")
                            .padding(.leading, -4)
                    }
                    
                    Spacer()
                }
            }
            .font(.footnote)
            .foregroundColor(.secondary)
            
        }
        .padding(.vertical, 10)
    }
}

//struct PetInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        PetInfo()
//    }
//}
