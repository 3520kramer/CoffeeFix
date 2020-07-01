//
//  OrderCollection.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 01/07/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import FirebaseFirestore

class OrderCollection{
    
    private static let db = Firestore.firestore() // initiates the connection to firestore
    private static let collectionName = "orders" // we save our collection name in a variable
    private static let subCollectionName = "products"// we save our subcollection name in a variable
    
    private static var listener: ListenerRegistration!

    static var orderList = [Order]() // the list of orders from firestore
        
    // function that listens for changes in the db
    // the viewcontroller is passed as argument so we can make changes to it from the function
    // the user_id is passed as well to be able to listen for orders from a specific user
    static func startListener(user_id: String, completion: @escaping ()->()){
        
        // snapshot listener creates a snapshot each time the database is modified
        listener = db.collection(collectionName).whereField("user_id", isEqualTo: user_id).addSnapshotListener { (snap, error) in
            if let snap = snap {
                
                // empties the list before filling it to avoid duplicates
                self.orderList.removeAll()
                
                // iterates over the documents in the snapshot
                for doc in snap.documents{
                    
                    // creates a map to hold the data
                    let map = doc.data()
                    
                    // uses the map and document id to set the relevant constants
                    let id = doc.documentID
                    let date = map["date"] as! String
                    let time = map["time"] as! Int
                    let total = map["total"] as! Double
                    let coffeeShopID = map["coffeeshop_id"] as! String
                    let userID = map["user_id"] as! String
                    let customerName = map["customer_name"] as! String
                    let orderStatus = map["order_status"] as! Bool
                    let archived = map["archived_status"] as! Bool
                    let comments = map["comments"] as! String
                    
                    // nested listener to fetch the products in the products subcollection
                    OrderCollection.startListenerForProducts(id: id){ productList in
                        
                        let order = Order(id: id, date: date, time: time, total: total, coffeeShopID: coffeeShopID, userID: userID, customerName: customerName, orderStatus: orderStatus, comments: comments, archived: archived, products: productList)
                        
                        self.orderList.append(order)
                        completion()
                    }
                    
                }
            }
        }
    }
    
    static func removeListener(){
        listener.remove()
    }
    
    // function that listens for changes in the db
    // we pass the id for the coffeeshop as an argument so we can query for the specific coffeshops products
    // uses a completion handler to let the caller know when we are finished iterating
    // the completion handler takes a list of products as argument
    static func startListenerForProducts(id: String, completion: @escaping ([Product])->()){
       
        // the list which we will pass as an argument when finished iterating
        var productList = [Product]()
        
        // snapshot listener creates a snapshot each time the collection is modified
        db.collection(collectionName).document(id).collection(subCollectionName).addSnapshotListener { (snap, error) in
            if let snap = snap{
                
                // iterates over the documents in the snapshot
                for doc in snap.documents{
                    
                    // creates a map to hold the data
                    let map = doc.data()
                    
                    // uses the map and document id to set the relevant constants
                    let name = map["name"] as! String
                    let priceString = map["price"] as! String
                    let quantity = map["quantity"] as! String
                    let size = map["size"] as! String
                    
                    // casts the string to a double to be able to create the total price later
                    guard let price = Double(priceString) else {
                        print("Error getting price from Firebase")
                        return
                    }
                    // creates a product object from the constants above
                    let product = Product(id: doc.documentID, name: name, price: price, quantity: quantity, size: size)
                    
                    // appends the coffeeshop to the list
                    productList.append(product)
                }
                // calls the completionhandler with the list as argument
                completion(productList)
            }
        }
    }
    
    /// Add order to collection
    static func addOrder(order:Order){
        /// Creates the new document in the order collection
        let docRef = db.collection(collectionName).document()
        
        /// Creates a map which holds the data we wan't to push to the document in firestore
        var orderMap = [String:Any]()
        
        order.setDateAndTime()
        
        /// Fills the map
        orderMap["date"] = order.date
        orderMap["time"] = order.time
        orderMap["total"] = order.total
        orderMap["coffeeshop_id"] = order.coffeeShopID
        orderMap["user_id"] = order.userID
        orderMap["customer_name"] = order.customerName
        orderMap["order_status"] = order.orderStatus
        orderMap["comments"] = order.comments
        orderMap["archived_status"] = order.archived
        
        /// Adds it to the database
        docRef.setData(orderMap)
        
        /// Iterates over the product list in orders
        for product in order.products{
            
            /// In the first iteration we add the sub collection and a new document in that subcollection
            /// After the first iteration, we only create new documents in the subcollection
            let subDocRef = db.collection(collectionName).document(docRef.documentID).collection(subCollectionName).document()
            
            /// Creates a map which holds the data we wan't to push to the document in the subcollection in firestore
            var productMap = [String:Any]()
            
            /// Fills the map
            productMap["name"] = product.name
            productMap["price"] = String(product.price)
            productMap["size"] = product.size
            productMap["quantity"] = product.quantity
            
            /// Adds it to the database
            subDocRef.setData(productMap)
        }
    }
    
}
