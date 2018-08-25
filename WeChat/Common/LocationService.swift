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
    
    private(set) var currentLocation: String = ""
    
    private(set) var currentCity: String = ""
    
    private(set) var street: String = ""
    
    private(set) var name: String = ""
    
    private(set) var area: String = ""
    
    private(set) var province: String = ""
    
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
                if let currentPlace = places?.first {
                    
                    if let addressInfo = currentPlace.addressDictionary {
                        self.street = addressInfo["Street"] as? String ?? ""
                        
                        if let addressLines = addressInfo["FormattedAddressLines"] as? Array<String> {
                            if !addressLines.isEmpty {
                                self.currentLocation = addressLines.first!
                            }
                        }
                        
                        self.currentCity = addressInfo["City"] as? String ?? ""
                        self.name = addressInfo["Name"] as? String ?? ""
                        self.area = addressInfo["SubLocality"] as? String ?? ""
                        self.province = addressInfo["State"] as? String ?? ""
                        
                        print("street \(String(describing: self.street)) \n currentLocation  \(String(describing: self.currentLocation)) \n currentCity \(String(describing: self.currentCity)) \n name  \(String(describing: self.name)) \n  area  \(String(describing: self.area))  \n  privince  \(String(describing: self.province))")
                    }
                }
            }
        }
    }
    
}
