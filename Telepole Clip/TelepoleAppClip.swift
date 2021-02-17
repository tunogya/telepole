//
//  TelepoleClip.swift
//  Telepole Clip
//
//  Created by 丁涯 on 2021/2/16.
//

import SwiftUI
import AppClip
import CoreLocation

@main
struct TelepoleAppClip: App {
    
    @ObservedObject var userSettings = TelepoleModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: handleUserActivity)
        }
    }
    
    func handleUserActivity(_ userActivity: NSUserActivity) {
        guard
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems
        else {
            return
        }
        
        if let petID = queryItems.first(where: { $0.name == "id" })?.value {
            userSettings.selectedPetID = petID
        }
        
        guard
            let latitudeValue = queryItems.first(where: { $0.name == "latitude" })?.value,
            let longitudeValue = queryItems.first(where: { $0.name == "longitude" })?.value,
            let latitude = Double(latitudeValue),
            let longitude = Double(longitudeValue)
        else {
            return
        }
        
        print(latitude, longitude)
    }
}
