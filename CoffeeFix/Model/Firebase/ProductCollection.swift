//
//  ProductCollection.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 30/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ProductCollection{
    
    private static let db = Firestore.firestore() /// Initiates the connection to firestore
    private static let parentCollectionName = "coffeeshops" /// We save our parent collection name in a variable
    private static let collectionName = "products" /// We save our collection name in a variable

    
    static var productList = [Product]() // the list of products from firestore
    
    // function that listens for changes in the db
    // we pass the id for the coffeeshop as an argument so we can query for the specific coffeshops products
    static func startListener(parentVC: CoffeeShopViewController, id: String){
        // snapshot listener creates a snapshot each time the database is modified
        db.collection("\(parentCollectionName)/\(id)/\(collectionName)").addSnapshotListener { (snap, error) in
            if let snap = snap {
                // empties the list before filling it to avoid duplicates
                productList.removeAll()
                
                 // iterates over the documents in the snapshot
                for doc in snap.documents{
                    
                    // creates a map to hold the data
                    let map = doc.data()
                    
                    // uses the map and document id to set the relevant constants
                    let id = doc.documentID
                    let name = map["name"] as? String ?? ""
                    let priceString = map["price"] as? String ?? "0"
                    let quantity = map["quantity"] as? String ?? ""
                    let size = map["size"] as? String ?? ""
                    
                    // casts the string to a double to be able to create the total price later
                    guard let price = Double(priceString) else {
                        print("Error getting price from Firebase")
                        return
                    }
                    
                    // creates a product object from the constants above
                    let product = Product(id: id, name: name, price: price, quantity: quantity, size: size)
                    
                    // appends the coffeeshop to the list
                    productList.append(product)
                }
                parentVC.productTableView.reloadData()
            }
        }
    }
}
