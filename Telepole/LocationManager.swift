//
//  LocationManager.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/12.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined : return "notDetermined"
        case .authorizedAlways: return "authorizedAlways"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
        
    }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    private let locationManager = CLLocationManager()
    
}


extension LocationManager: CLLocationManagerDelegate {
    
//    Responding to Authorization Changes
//    Tells the delegate when the app creates the location manager and when the authorization status changes.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, statusString)
    }
    
//    Handling Errors
//    Tells the delegate that the location manager was unable to retrieve a location value.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
//    Responding to Location Events
//    Tells the delegate that new location data is available.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
//        print(#function, location)
    }
    
//    Pausing Location Updates
//    Tells the delegate that location updates were paused.
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
//    Tells the delegate that the delivery of location updates has resumed.
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    
//    Responding to Visit Events
//    Tells the delegate that a new visit-related event was received.
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        
    }
    
}
