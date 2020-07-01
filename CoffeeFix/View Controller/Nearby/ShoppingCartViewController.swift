//
//  ShoppingCartViewController.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 30/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController {
   
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var orderCommentTextView: UITextView!
    
    /// Declares the authorization manager
    var authManager: AuthorizationManager!
    
    /// Declares an order object
    var order: Order!
    
    /// The parentVC
    var parentVC: CoffeeShopViewController!
    
    /// The placeholder text for the comment textView
    var placeHolderText = "Add a comment to your order..."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(order.coffeeShopID)
        /// Sets the delegates of the order table
        orderTableView.delegate = self
        orderTableView.dataSource = self
        
        /// Initiates the Authorizationmanager
        authManager = AuthorizationManager(parentVC: self)
        
        /// Sets the order total label to the total of the order
        orderTotalLabel.text = NumberFormatter.formatPrice(price: order.total, currency: "dkk")
        
        /// Sets the delegate of the textView
        orderCommentTextView.delegate = self
        
        /// Creates a placholder text in the textView and sets the color
        orderCommentTextView.text = placeHolderText
        orderCommentTextView.textColor = UIColor.lightGray
    }
    
    /// Closes the listener when the view is removed
    override func viewDidDisappear(_ animated: Bool) {
        authManager.closeListener()
    }
    
    @IBAction func placeOrderPressed(_ sender: Any) {
        
        /// Checks if the order comment textView is filled with the placeholder text, we won't add it to the order
        if orderCommentTextView.text != placeHolderText{
            order.comments = orderCommentTextView.text
        }
        
        /// Adds the order to firebase from the repo
        OrderCollection.addOrder(order: order)

        /// We need to reset the order, therefore we create a blank order
        parentVC.order = Order(userID: order.userID, customerName: order.customerName, coffeeShopID: order.coffeeShopID)

        /// Dismisses this view controller
        self.dismiss(animated: true, completion: nil)
        
        /// Removes the badge with current products in order from the checkout button
        parentVC.badgeController.remove(animated: true)
        
        /// Displays the order confirmation alert controller on the parentVC ie the CoffeeShop View Controller
        AlertControllers.showOrderConfirmation(parentVC: parentVC)
    }
}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.products.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = order.products[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        cell.setCell(product: product)
        return cell
    }
}

/// Textview setup
extension ShoppingCartViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
        }
    }
}
