//
//  MapDataAdapter.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 26/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import MapKit
import Firebase

class MapDataAdapter{

    /// Converts the data from firestore to an MKPointAnnotation to put on the map
    static func convertDataToAnnotation(title: String, subtitle: String, geoPoint: GeoPoint) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
        
        return annotation
        
    }
    
    /// Function that gets called every time the listener receives new data
    static func updateMarkersOnMap(map: MKMapView){
        /// Creates a list of markers
        var markers = [MKPointAnnotation]()

        /// Adds all the markers from the new list of coffeeshops
        for coffeeShop in CoffeeShopCollection.coffeeShopList{
            markers.append(coffeeShop.marker)
        }

        /// Removes the annotations that is already on the map
        map.removeAnnotations(map.annotations)

        /// Adds the new annotations to the map
        map.addAnnotations(markers)
    }
}
