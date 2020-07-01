//
//  CoffeeShopRepo.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 26/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MapKit

class CoffeeShopCollection{
    
    private static let db = Firestore.firestore() /// initiates the connection to firestore
    private static let collectionName = "coffeeshops" /// The name of the collection
    
    private static var parentVC: NearbyViewController?
    
    private static var listener: ListenerRegistration!
    
    /// The list of coffeeshops from firestore
    static var coffeeShopList = [CoffeeShop]()
    
    /// Function that listens for changes in the db
    /// The viewcontroller is passed as argument so we can make changes to it from the function
    static func startListener(parentVC:NearbyViewController, completion: @escaping ()->()){
        
        /// Snapshot listener creates a snapshot each time the database is modified
        listener = db.collection(collectionName).addSnapshotListener { (snap, error) in
            if let snap = snap {
                
                /// Empties the list before filling it to avoid duplicates
                self.coffeeShopList.removeAll()
                
                /// Iterates over the documents in the snapshot
                for doc in snap.documents{
                    
                    /// Creates a map to hold the data
                    let map = doc.data()
                    
                    /// Uses the map and document id to set the relevant constants
                    let id = doc.documentID
                    let timeEstimateMin = map["time_estimate_min"] as! Int
                    let timeEstimateMax = map["time_estimate_max"] as! Int
                    let rating = map["rating"] as! Int
                    let geoPoint = map["coordinates"] as! GeoPoint
                    let logoUUID = map["logo_uuid"] as! String
                    
                    /// Calls the function mapDataAdapter which returns an annotation. The annotation can be displayed on a MapView
                    let annotation = MapDataAdapter.convertDataToAnnotation(title: id, subtitle: doc.documentID, geoPoint: geoPoint)
                    
    
                    /// Creates a coffeeshop object from the constants above
                    let coffeeShop = CoffeeShop(id: id, timeEstimateMin: timeEstimateMin, timeEstimateMax: timeEstimateMax, rating: rating, logoUUID: logoUUID, marker: annotation)
                    
                    /// Calculates the distance from the user to the coffeeshop and updates the coffeeShop-object. This value is used to sort the list on the nearby tab
                    calculateDistanceToUserFromCoffeeShop(userLocation: parentVC.locationAuthorizationManager.locationManager.location!, coffeeShop: coffeeShop)
                    
                    /// Appends the coffeeshop to the list
                    self.coffeeShopList.append(coffeeShop)
                }
                completion()
            }
        }
    }
    
    static func removeListener(){
        listener.remove()
    }
    
    static func getCoffeeShop(with id: String) -> CoffeeShop?{
        return CoffeeShopCollection.coffeeShopList.first { $0.id == id }
    }
    
    static func sortCoffeeShopListOnDistanceToUser(completion: () -> ()){
        coffeeShopList.sort(by: {$0.distanceToUser < $1.distanceToUser})
        completion()
    }
    
    static func calculateDistanceToUserFromCoffeeShop(userLocation: CLLocation, coffeeShop: CoffeeShop){
        // create a CLLocation from the coffeshops coordinates
        let coffeeShopLocation = CLLocation(latitude: coffeeShop.marker.coordinate.latitude,
                                            longitude: coffeeShop.marker.coordinate.longitude)
        
        // use the userlocation and the CLLoc
        let distance = userLocation.distance(from: coffeeShopLocation)
        
        // set the distance to the coffeshop object to be able to sort the list
        coffeeShop.distanceToUser = distance
    }

    
    static func updateDistanceToUserFromCoffeeShops(userLocation: CLLocation, completion: ()->()) {
        for coffeeShop in CoffeeShopCollection.coffeeShopList{
            calculateDistanceToUserFromCoffeeShop(userLocation: userLocation, coffeeShop: coffeeShop)
        }
        completion()
    }

}
