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
    
    static var coffeeShopList = [CoffeeShop]() /// The list of coffeeshops from firestore
    
    static var coffeeShopListSortedByLocation = [CoffeeShop]() /// MIGHT DELETE!! The sorted list of coffeeshops from firestore
    
    /// Function that listens for changes in the db
    /// The viewcontroller is passed as argument so we can make changes to it from the function
    static func startListener(parentVC:NearbyViewController){
        
        /// Snapshot listener creates a snapshot each time the database is modified
        db.collection(collectionName).addSnapshotListener { (snap, error) in
            if let snap = snap {
                
                /// Empties the list before filling it to avoid duplicates
                self.coffeeShopList.removeAll()
                
                /// Iterates over the documents in the snapshot
                for doc in snap.documents{
                    
                    /// Creates a map to hold the data
                    let map = doc.data()
                    
                    /// Uses the map and document id to set the relevant constants
                    let id = doc.documentID
                    let timeEstimateMin = map["time_estimate_min"] as? Int ?? 99
                    let timeEstimateMax = map["time_estimate_max"] as? Int ?? 99
                    let rating = map["rating"] as? Int ?? 99
                    let geoPoint = map["coordinates"] as? GeoPoint ?? GeoPoint(latitude: 0.00, longitude: 0.00)
                    let logoUUID = map["logo_uuid"] as? String ?? ""
                    
                    /// Calls the function mapDataAdapter which returns an annotation. The annotation can be displayed on a MapView
                    let annotation = MapDataAdapter.convertDataToAnnotation(title: id, subtitle: doc.documentID, geoPoint: geoPoint)
                    
                    /// Creates a coffeeshop object from the constants above
                    let coffeeShop = CoffeeShop(id: id, timeEstimateMin: timeEstimateMin, timeEstimateMax: timeEstimateMax, rating: rating, logoUUID: logoUUID, marker: annotation)
                    
                    /// Appends the coffeeshop to the list
                    self.coffeeShopList.append(coffeeShop)
                }
                
                /// When the iteration is finished we call a function from the mapDataAdapter to update the annotations on the parentVCs map
                MapDataAdapter.updateMarkersOnMap(map: parentVC.map)
                
                /// Makes the table update it's data after list is filled, otherwise we would have an empty table
                parentVC.coffeeShopTableView.reloadData()
                print("DONE")
            }
        }
    }
    
    static func getCoffeeShop(with id: String) -> CoffeeShop?{
        return CoffeeShopCollection.coffeeShopList.first { $0.id == id }
    }
}
