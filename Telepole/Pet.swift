//
//  Pets.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/27.
//

import Foundation
import SwiftyJSON

struct Pet: Identifiable {
    var id: String
    var name: String
    var variety: String
    var address: String
    var avator: String
    var birthday: String
    var gender: String
    
    init(jsonData: JSON) {
        id = jsonData["_id"].stringValue
        name = jsonData["name"].stringValue
        variety = jsonData["variety"].stringValue
        address = jsonData["address"].stringValue
        birthday = jsonData["birthday"].stringValue
        gender = jsonData["gender"].stringValue
        avator = jsonData["avators"].stringValue
    }
}
