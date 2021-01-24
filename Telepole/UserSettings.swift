//
//  UserDefaults.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/24.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var user: UserModel {
        didSet {
            UserDefaults.standard.set(UserModel(user: "", fullName: "", email: ""), forKey: "user")
        }
    }
    
    init() {
        self.user = UserDefaults.standard.object(forKey: "user") as! UserModel
    }
}
