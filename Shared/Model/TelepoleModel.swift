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

class TelepoleModel: ObservableObject {
    @Published private(set) var account = Account() {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published private(set) var selectedPet = Pet() {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published private(set) var myGeos: [Geo] = [] {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published private(set) var isLoading: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published private(set) var friendGeos: [Geo] = [] {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("userCredential", defaultValue: "")
    private var userCredential: String
    
    @UserDefault("selectedPetID", defaultValue: "")
    private var selectedPetID: String
    
    @UserDefault("myPetIDs", defaultValue: [])
    var myPetIDs: [String] {
        willSet {
            objectWillChange.send()
        }
    }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    init() {
        selectPet(id: selectedPetID)
        loadAccount(id: userCredential)
    }
}

extension TelepoleModel {
    func loadAccount(user: Account) {
        account = user
    }
    
    func loadAccount(id: Account.ID) {
        Account().getUserByID(id) { account in
            self.loadAccount(user: account)
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
        myGeos.removeAll()
        friendGeos.removeAll()
    }
    
    func selectPet(_ pet: Pet) {
        selectedPet = pet
        selectedPetID = pet.id
        updateGeos(petID: pet.id)
    }
    
    func selectPet(id: Pet.ID) {
        Pet().getPetByID(id) { pet in
            self.selectPet(pet)
        }
    }
    
    func isMyPet(id: Pet.ID) -> Bool {
        myPetIDs.contains(id)
    }
    
    func addMyPets(id: Pet.ID) {
        guard !isMyPet(id: id) else {
            return
        }
        myPetIDs.append(id)
    }
}
extension TelepoleModel {
    func startLostMode() {
        // 上传数据库
        Pet().closedProtected(selectedPet){
            self.selectedPet.protected = false
        }
    }
    
    func stopLostMode(){
        Pet().openProtected(selectedPet){
            self.selectedPet.protected = true
        }
    }
}

extension TelepoleModel {
    func updateGeos(_ geos: [Geo]) {
        myGeos = geos
        var allFriendGeos: [Geo] = []
        for myGeo in geos {
            Geo().getNearbyGeos(geo: myGeo) { geos in
                allFriendGeos.append(contentsOf: geos)
            }
        }
        self.updateFriendGeos(geos)
    }
    
    func updateGeos(petID: Pet.ID) {
        Geo().getMyGeos(petID: petID) { geos in
            self.myGeos.removeAll()
            self.friendGeos.removeAll()
            guard geos.first != nil else {
                return
            }
            self.updateGeos(geos)
        }
    }
    
    func updateFriendGeos(_ geos: [Geo]) {
        friendGeos.removeAll()
        guard geos.first != nil else {
            return
        }
        friendGeos = geos
    }
}
