//
//  LocationAuthorizationManager.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 26/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import MapKit

class LocationAuthorizationManager{
    
    let map: MKMapView
    let parentVC: NearbyViewController
    
    let locationManager: CLLocationManager
    let regionInMeters: Double
    
    init(map: MKMapView, parentVC: NearbyViewController) {
        self.map = map
        self.parentVC = parentVC
        
        locationManager = CLLocationManager() /// Core location manager used to query for gps data
        regionInMeters = 10000 /// How much we want the map to be zoomed in
    }
    
    // MARK: - User Location Setup With Authorization
    
    /// Function that checks if the location services of the device isn't turned off
    func checkLocationService(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationAuthorization()
        }else{
            // TODO: - create an alert that tells the user to turn on location services
            print("Location Services has not been enabled on this device")
            
        }
    }
    
    /// Function that sets up the location manager which handles the user location
    func setUpLocationManager(){
        locationManager.delegate = parentVC /// Sets the delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest /// Sets the desired accuracy to the best possible accuracy
    }
      
    // Checks what kind of authorization is given
    func checkLocationAuthorization(){
      
        switch CLLocationManager.authorizationStatus() {
          
        /// When the app is used, we are authorized to access the user location
        case .authorizedWhenInUse:
            print("when in use")
            startUpdatingUserLocationWhenAuthorized()
            break

        /// If we are denied access by the user
        case .denied:
            print("denied")
            // TODO: - show an alert to make the user know that it's device hasn't given permission
            break
          
        /// First time the app is opened, or if user chooese only to give access one time
        case .notDetermined:
            print("not determined")
            /// We set to setup the p-list to be able to ask for authorization
            locationManager.requestWhenInUseAuthorization() /// Requests the authorization
            break
          
        /// if the user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place
        case .restricted:
            print("restricted")
            // TODO: - Show alert
            break
          
        /// If it's always authorized it should start updating user location
        case .authorizedAlways:
            print("always")
            startUpdatingUserLocationWhenAuthorized()
            break

        /// If a new type of authorization should come in future updates we are covered by @unkown
        @unknown default:
            print("my default")
            break
        }
    }
      
    /// Function that we call when we have the right permission of user location
    func startUpdatingUserLocationWhenAuthorized(){
        map.showsUserLocation = true /// Shows the blue dot on the map
        parentVC.centerViewOnUserLocation() /// Centers the view
        locationManager.startUpdatingLocation() /// Calls the didUpdateLocation method in the parentVC's extension
        ///If the user moves, the locationmanager will update the location
    }
      
    
}
