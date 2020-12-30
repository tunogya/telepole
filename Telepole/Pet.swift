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
    var avator: URL
    var birthday: String
    var gender: String
    var shortbirthday: String {
        return String(birthday.prefix(7))
    }
}
