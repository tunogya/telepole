//
//  RegionModel.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/20.
//

import Foundation

struct RegionModel: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    var latitudeDelta: Double
    var longitudeDelta: Double
}
