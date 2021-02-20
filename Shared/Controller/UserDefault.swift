//
//  UserDefaultManager.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/20.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    let defaults = UserDefaults(suiteName: "group.wakanda.telepole")
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return defaults?.object(forKey: key) as? T ?? defaultValue
        }
        set {
            defaults?.set(newValue, forKey: key)
        }
    }
}
