//
//  AnimatableModifier.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/21.
//

import SwiftUI

struct Bounce: AnimatableModifier {
    var animCount: CGFloat = 0
    var amplitude: CGFloat = 10    // 振幅
    
    var animatableData: CGFloat {
        get { animCount }
        set { animCount = newValue }
    }
    
    func body(content: Content) -> some View {
        let offset: CGFloat = -abs(sin(animCount * .pi * 2) * amplitude)
        return content.offset(y: offset)
    }
}
