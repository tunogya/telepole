//
//  UserDefaults.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/24.
//

import Foundation
import Combine
import MapKit
import SwiftUI

let HOSTNAME = "https://app.wakanda.vip"

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

final class UserSettings: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("user", defaultValue: "")
    var user: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("email", defaultValue: "")
    var email: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("fullName", defaultValue: "")
    var fullName: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("_id", defaultValue: "")
    var _id: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("pickPetID", defaultValue: "")
    var pickPetID: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("myPets", defaultValue: [])
    var myPets: [String] {
        willSet {
            objectWillChange.send()
        }
    }
}
