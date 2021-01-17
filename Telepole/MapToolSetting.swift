//
//  MapToolSetting.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/17.
//

import SwiftUI

struct MapToolSetting: View {
    @Binding var isShowSetting: Bool
    var body: some View {
        HStack {
            Spacer()
            VStack{
                Button(action: {
                    isShowSetting.toggle()
                }) {
                    Image(systemName: "person.circle")
                        .frame(width: 44, height: 44, alignment: .center)
                        .font(.title)
                        .background(Color("GrayColor"))
                        .clipShape(Circle())
                }
                Spacer()
            }
        }
        .padding()
        .padding(.top, 30)
    }
}

//struct MapToolSetting_Previews: PreviewProvider {
//    static var previews: some View {
//        MapToolSetting()
//    }
//}
