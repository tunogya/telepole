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

let HOSTNAME = "https://app.wakanda.vip/api/telepole/v1.0"

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

class TelepoleModel: ObservableObject {
    @Published private(set) var account: Account?
    @Published private(set) var selectedPet = Pet()
    
    @UserDefault("user", defaultValue: "")
    var user: String
    
    @UserDefault("email", defaultValue: "")
    var email: String
    
    @UserDefault("fullName", defaultValue: "")
    var fullName: String
    
    @UserDefault("_id", defaultValue: "")
    var _id: String
    
    @UserDefault("selectedPetID", defaultValue: "")
    var selectedPetID: String
    
    @UserDefault("myPetIDs", defaultValue: [])
    var myPetIDs: [String]
    
    init() {
        Pet().getPetByID(selectedPetID) { pet in
            self.selectPet(pet)
        }
    }
}

extension TelepoleModel {
    func createAccount(_id: String, user: String, fullName: String, email: String) {
        guard account == nil else { return }
        account = Account(id: _id, user: user, fullName: fullName, email: email)
        
    }
    
    func clearMyPetIDs() {
        myPetIDs.removeAll()
    }
    
    func selectPet(_ pet: Pet) {
        selectPet(id: pet.id)
        selectedPet = pet
    }
    
    func selectPet(id: Pet.ID) {
        selectedPetID = id
    }
    
    func clearAccount() {
        user = ""
        email = ""
        fullName = ""
        _id = ""
    }
}
