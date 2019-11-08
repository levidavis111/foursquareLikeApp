////
////  LocationManager.swift
////  unit-five-project-one
////
////  Created by Levi Davis on 11/7/19.
////  Copyright © 2019 Levi Davis. All rights reserved.
////
//
//import Foundation
//import CoreLocation
//
//class LocationManager: NSObject {
//    private let locationManager = CLLocationManager()
//    
//    override init() {
//        super.init()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization()
//    }
//    
//}
//
//extension LocationManager: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("New Location: \(locations)")
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("Authorization status changed to \(status.rawValue)")
//        switch status {
//        case .authorizedAlways, .authorizedWhenInUse:
//            locationManager.requestLocation()
//        default:
//            break
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//}
