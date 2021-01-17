//
//  MyLife.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/17.
//

import SwiftUI

struct PetTelepole: View {
    @State var pickerIndex = 1
    
    var body: some View {
        Picker(selection: $pickerIndex, label: Text("Picker")) {
            Text("朋友圈").tag(1)
            Text("照片").tag(2)
            Text("直播").tag(3)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct PetTelepole_Previews: PreviewProvider {
    static var previews: some View {
        PetTelepole()
    }
}
