//
//  ProductViewController.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 30/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var parentVC: CoffeeShopViewController?
    var product: Product?
    var order: Order?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = product {
            nameLabel.text = product.name
            priceLabel.text = NumberFormatter.formatPrice(price: product.price, currency: "dkk")
        }
    }
    
    @IBAction func addToOrder(_ sender: Any) {
        if let order = order, let product = product {
            order.addProductToOrder(product: product)
            self.dismiss(animated: true, completion: nil)
            parentVC?.badgeController.increment(animated: true)
        }
    }
}
