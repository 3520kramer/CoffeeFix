//
//  ViewController2.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 26/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit
import BadgeControl

class CoffeeShopViewController: UIViewController {

    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var checkOutButton: UIButton!
    
    /// Declares the objects as optional, so we can check if it is initialized
    var coffeeShop: CoffeeShop?
    var selectedProduct: Product?
    var order: Order?
    
    /// Declares the badgeController which will show the current number of products in the order
    var badgeController: BadgeController!
    
    /// Declares the Authorization Manager
    var authManager: AuthorizationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Initiates the badgeController
        badgeController = BadgeController(for: checkOutButton)
        
        /// Initiates the authorization manager
        authManager = AuthorizationManager(parentVC: self)
        
        /// Unwraps the optional coffeeshop and starts the listener for products
        if let coffeeShop = coffeeShop{
            ProductSubCollection.startListener(id: coffeeShop.id) {
                self.productTableView.reloadData()
            }
            
        }
        
        /// Sets the delegate and datasource of the tableView to this viewcontroller
        productTableView.delegate = self
        productTableView.dataSource = self
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// We need to create an order object to keep track of which products the user wants to order
        checkSignInStatus { userID, customerName in
            print("in closure")
            print(userID, customerName)
            self.createOrder(userID: userID, customerName: customerName)
        }
        
    }
    
    /// When the view is not in the hierarchy then we must close the listener
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("did")
        authManager.closeListener()
        ProductSubCollection.removeListener()
    }
    
    @IBAction func checkoutPressed(_ sender: Any) {
        if order == nil {
            checkSignInStatus(completion: { userID, customerName in
                self.createOrder(userID: userID, customerName: customerName)
            })
        }
        self.performSegue(withIdentifier: "showShoppingCart", sender: nil)
    }
    
    func checkSignInStatus(completion: ((String, String) -> ())?){
        /// Checks if the user is signed in or else it returns from the function
        guard let userID = authManager.auth.currentUser?.uid else {
            AlertControllers.presentMissingSigningInAlert(parentVC: self, hasCancel: true)
            print("missing sign in")
            return
        }
        
        /// Checks if the user has a name or else it returns from the function
        guard let customerName = authManager.auth.currentUser?.displayName else {
            AlertControllers.presentMissingNameAlert(parentVC: self, hasCancel: true)
            print("missing name")
            return
        }
        
        if let completion = completion{
            completion(userID, customerName)
        }
    }
    
    func createOrder(userID: String, customerName: String){
        /// If the name and id is present then we can create an order
        if let coffeeShop = coffeeShop{
            print("creates order")
            order = Order(userID: userID, customerName: customerName, coffeeShopID: coffeeShop.id)
        }
    }
    
    // MARK: - Navigation
    func presentProductViewController(){
        // Creates a new viewcontroller which slides up from the bottom, when hitting the details button on an annotation
        let productViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "productViewController") as ProductViewController
        
        // A 'UIView' was created on the new view controller in the storyboard, and moved to the bottom of the view controller
        // The background of the pop up view controllers opacity is set to 0 and the presentation style is set to 'over current context' to make sure it's on top of the old view
        // This makes the rest of the view controller 'invisible' aka. when the 'UIView' pops up, the rest of the view controller isn't visible
        productViewController.modalPresentationStyle = .overCurrentContext

        // creates references in the productviewcontroller to this view controller
        productViewController.parentVC = self
        productViewController.product = selectedProduct
        productViewController.order = order
        
        
        // The new view is presented on top of the old view controller
        present(productViewController, animated: true, completion: {
            
            productViewController.view.viewWithTag(0)?.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            // When tapping outside of the view, the pop up will be dismissed
            productViewController.view.viewWithTag(1)?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }
    
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // pass object to next viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ShoppingCartViewController{
            
            destination.preferredContentSize = CGSize(width:250, height:400)
            
            let presentationController = destination.popoverPresentationController
            
            presentationController?.delegate = self
            
            destination.parentVC = self
            destination.order = order
        }
    }
    
}

extension CoffeeShopViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductSubCollection.productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = ProductSubCollection.productList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
        
        cell.setCell(product: product)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = ProductSubCollection.productList[indexPath.row]
        
        checkSignInStatus { userID, userName in
            /// Presents the product pop up from the bottom
            self.presentProductViewController()
        }
        
        /// Removes the grey 'selection' of the row
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// pop over presentation controller setup
extension CoffeeShopViewController: UIPopoverPresentationControllerDelegate{
        
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}

