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

final class TelepoleModel: ObservableObject {
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
    
    @UserDefault("selectedPetID", defaultValue: "")
    var selectedPetID: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("myPetIDs", defaultValue: [])
    var myPetIDs: [String] {
        willSet {
            objectWillChange.send()
        }
    }
}
