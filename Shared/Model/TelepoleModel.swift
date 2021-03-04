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
    
    @Published private(set) var lastGeos = [Geo()] {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published private(set) var lastAddress: String = "" {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published private(set) var isLoading: Bool = false {
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
        lastGeos.removeAll()
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
    func updateGeos(_ geos: [Geo]) {
        lastGeos = geos
        guard let geo = geos.first else{
            return
        }
        getAddress(latitude: geo.latitude, longitude: geo.longitude)
        stopLoading()
    }
    
    func updateGeos(petID: Pet.ID) {
        Geo().getLastGeos(petID: petID) { geos in
            guard geos.first != nil else {
                self.lastGeos.removeAll()
                return
            }
            self.updateGeos(geos)
        }
    }
    
    func getAddress(latitude: Double, longitude: Double) {
        if ( Int(latitude) == 0 && Int(longitude) == 0 ){
            self.lastAddress = "没有可用的位置信息"
        }
        reverseGeocode(latitude: latitude, longitude: longitude) { address in
            self.lastAddress = address
        }
    }
    
    func reverseGeocode(latitude: Double, longitude: Double, completion: @escaping (String) -> ()) {
        let geocoder = CLGeocoder()
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            let array = NSArray(object: "zh-hans")
            UserDefaults.standard.set(array, forKey: "AppleLanguages")
            if error != nil {
                return
            }
            
            if let p = placemarks?[0]{
                var address = ""
                
                if let country = p.country {
                    address.append("\(country)")
                }
                if let administrativeArea = p.administrativeArea {
                    address.append("\(administrativeArea)")
                }
                if let subAdministrativeArea = p.subAdministrativeArea {
                    address.append("\(subAdministrativeArea)")
                }
                if let locality = p.locality {
                    address.append("\(locality)")
                }
                if let subLocality = p.subLocality {
                    address.append("\(subLocality)")
                }
                if let thoroughfare = p.thoroughfare {
                    address.append("\(thoroughfare)")
                }
                if let subThoroughfare = p.subThoroughfare {
                    address.append("\(subThoroughfare)")
                }
                if let name = p.name {
                    address.append("\(name)")
                }
                completion(address)
            } else {
                print("No placemarks!")
                completion("没有可用的位置信息")
            }
        }
    }
}

extension TelepoleModel {
    func startLoading() {
        isLoading = true
    }
    
    func stopLoading() {
        DispatchAfter(after: 1) {
            self.isLoading = false
        }
    }
}
