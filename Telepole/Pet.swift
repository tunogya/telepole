//
//  Pets.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/27.
//

import Foundation

// Decodable用于解析JSON, Identifiable用于list呈现
struct Pet: Decodable, Identifiable {
    var _id: String
    var id: String
    var name: String
    var variety: String
    var address: String
    var avators: [String]
    var birthday: Data
    var gender: String
    
//    CoadingKey用于Json与模型键值对应
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case id = "id"
        case name = "name"
        case variety = "variety"
        case address = "address"
        case avators = "avators"
        case birthday = "birthday"
        case gender = "gender"
        
    }
}
