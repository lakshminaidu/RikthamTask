//
//  LocationService.swift
//  ChingariTask
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func locationDidUpdate(_ service: LocationService, location: CLLocation)
    func locationDidFail(withError error: AppError)
}

final class LocationService: NSObject {
    
    var delegate: LocationServiceDelegate?
    
    private (set) var userLocation: CLLocation = CLLocation(latitude: 37.7670169511878, longitude: -122.23456)
    
    static let shared = LocationService()
    
    fileprivate let locationManager = CLLocationManager()
    
    static var isLocationServicesEnabled: Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        return (CLLocationManager.locationServicesEnabled() &&
                (authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways))
    }
    
    private override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
        authorizeUser()
    }
    // MARK: Helper
    
    func authorizeUser(){
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if LocationService.isLocationServicesEnabled {
            locationManager.startUpdatingLocation()
        }
    }
    // to start location services
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
}

//MARK: CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation = locations.first else {
            return
        }
        print("Current location: \(userLocation)")
        delegate?.locationDidUpdate(self, location: userLocation)
        self.userLocation = userLocation
        stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // do on error
        delegate?.locationDidFail(withError: .unableToFindLocation)
        print("Error finding location: \(error.localizedDescription)")
    }
}
