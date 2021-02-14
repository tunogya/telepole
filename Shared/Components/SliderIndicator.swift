//
//  SliderIndicator.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/17.
//

import SwiftUI

struct SliderIndicator: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .foregroundColor(Color("GrayColor"))
            .frame(width: 46, height: 6, alignment: .center)
    }
}

struct SliderIndicator_Previews: PreviewProvider {
    static var previews: some View {
        SliderIndicator()
    }
}
