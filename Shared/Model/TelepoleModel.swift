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
    @Published private(set) var account = Account()
    @Published private(set) var selectedPet = Pet()
    @Published private(set) var myPets = [Pet]()
    
    @UserDefault("userCredential", defaultValue: "")
    private var userCredential: String
    
    @UserDefault("selectedPetID", defaultValue: "")
    private var selectedPetID: String
    
    @UserDefault("myPetIDs", defaultValue: [])
    var myPetIDs: [String]
    
    init() {
        selectPet(id: selectedPetID)
        updateAccount(id: userCredential)
    }
}

extension TelepoleModel {
    func updateAccount(user: Account) {
        account = user
    }
    
    func updateAccount(id: Account.ID) {
        Account().getUserByID(id) { account in
            self.updateAccount(user: account)
        }
    }
    
    func clearAccount() {
        account = Account()
 
        self.clearUserCredential()
    }
    
    func clearUserCredential() {
        userCredential = ""
    }
    
    func saveUserCredential(credential: String) {
        userCredential = credential
    }
}

extension TelepoleModel {
    func clearMyPetIDs() {
        myPetIDs.removeAll()
    }
    
    func selectPet(_ pet: Pet) {
        selectedPet = pet
        selectedPetID = pet.id
    }
    
    func selectPet(id: Pet.ID) {
        Pet().getPetByID(id) { pet in
            self.selectPet(pet)
        }
    }
}
