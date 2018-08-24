//
//  LocationService.swift
//  WeChat
//
//  Created by ysq on 2018/8/24.
//  Copyright © 2018年 ysq. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    
    static let sharedInstance = LocationService()
    
    private var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5.0
        return manager
    }()
    
    private var currentLocation: String?
    
    private var finished = false
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
}

extension LocationService {
    
    public func startLocation() {
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let currentLocation = locations.last {
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation) { (places, error) in
                guard let currentPlaces = places else {
                    return
                }
                for place in currentPlaces {
                    print(place.locality as Any)
                }
            }
        }
    }
    
}
