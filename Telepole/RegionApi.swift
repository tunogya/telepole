//
//  RegionModel.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/20.
//

import Foundation

struct RegionModel: Codable {
    var name: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var latitudeDelta: Double = 0.03
    var longitudeDelta: Double = 0.03
}
