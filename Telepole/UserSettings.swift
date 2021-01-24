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

@propertyWrapper
struct UserDefault<T> {
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
    
    @UserDefault("user", defaultValue: UserModel(user: "", fullName: "", email: ""))
    var user: UserModel {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("isShareMyLocation", defaultValue: false)
    var isShareMyLocation: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @UserDefault("trackingMode", defaultValue: MapUserTrackingMode.follow)
    var trackingMode: MapUserTrackingMode {
        willSet {
            objectWillChange.send()
        }
    }
}
