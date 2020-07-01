//
//  OrdersViewController.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 01/07/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    /// Declares the authorization manager
    var authManager: AuthorizationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        
        /// Initiates the authorization manager
        authManager = AuthorizationManager(parentVC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // checks if the user is logged in
        if let userID = authManager.auth.currentUser?.uid{
            /// Starts the order listener
            OrderCollection.startListener(user_id: userID) {
                self.ordersTableView.reloadData()
            }
        }else{
            AlertControllers.presentMissingSigningInAlert(parentVC: self, hasCancel: false)
        }
    }
    

    // closes the listener when the view is removed
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        authManager.closeListener()
        OrderCollection.removeListener()
    }

}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // checks if the user has any orders
        // if not we return 1
        if OrderCollection.orderList.count == 0{
            return 1
        // or else we return the count of the order list
        }else{
            return OrderCollection.orderList.count
        }
        
    }
    
    // sets the cells at each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // if no orders we create a cell with the text "no orders yet"
        if OrderCollection.orderList.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            cell.textLabel!.text = "No orders yet"
            
            return cell
        }
        
        // if the user has orders then we set the order
        let order = OrderCollection.orderList[indexPath.row]
        
        let cell: OrderCell
        
        if order.hasComment(){
            cell = tableView.dequeueReusableCell(withIdentifier: "withComment", for: indexPath) as! OrderCell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "withoutComment", for: indexPath) as! OrderCell
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.setCell(order: order)
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if OrderCollection.orderList.count == 0{
            return 30
        }
        
        let order = OrderCollection.orderList[indexPath.row]
       
        if order.hasComment(){
            let height = CGFloat(integerLiteral: 200 + (order.products.count * 20))
            return height
        }else{
            let height = CGFloat(integerLiteral: 150 + (order.products.count * 20))
            return height
            
        }
    }
}
