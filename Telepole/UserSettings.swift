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

class UserSettings: ObservableObject {
    @Published var user: UserModel {
        didSet {
            UserDefaults.standard.set(user, forKey: "user")
        }
    }
    
    @Published var isShareMyLocation: Bool {
        didSet {
            UserDefaults.standard.set(isShareMyLocation, forKey: "isShareMyLocation")
        }
    }
    
    @Published var trackingMode: MapUserTrackingMode {
        didSet {
            UserDefaults.standard.set(trackingMode, forKey: "trackingMode")
        }
    }
    
    init() {
        self.user = UserDefaults.standard.object(forKey: "user") as? UserModel ?? UserModel(user: "", fullName: "", email: "")
        self.isShareMyLocation = UserDefaults.standard.bool(forKey: "isShareMyLocation")
        self.trackingMode = UserDefaults.standard.object(forKey: "trackingMode") as? MapUserTrackingMode ?? MapUserTrackingMode.follow
    }
}
