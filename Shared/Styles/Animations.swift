//
//  Animations.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/15.
//

import SwiftUI

extension Animation {
    static let openMap = Animation.spring(dampingFraction: 0.618)
    static let rotate = Animation.linear.repeatForever(autoreverses: true).speed(1/8)
}
