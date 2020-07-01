//
//  OrderCell.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 01/07/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var commentsTextView: UITextView! /// Only initiated if present
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /// Configures the cell data
    func setCell(order: Order){
        nameLabel.text = order.coffeeShopID
        dateLabel.text = order.date
        
        /// Determines the imageviews image and color dependant on the status of the order
        statusLabel.text = determineOrderStatus(order: order)
        
        /// Gets the time from the order and formats it to make it easier to read for the user
        if let time = order.time{
           timeLabel.text = NumberFormatter.formatTimeFromFirebase(time: time)
        }
        
        totalLabel.text = NumberFormatter.formatPrice(price: order.total, currency: "dkk")
        
        /// If the order has a comment
        if order.hasComment(){
            commentsTextView.text = order.comments
        }
        
        /// Sets the number of lines for the productlabel to 0 to allow infinite number of lines
        productLabel.numberOfLines = 0
        priceLabel.numberOfLines = 0
        
        /// Clears the to labels for any text added in the storyboard
        productLabel.text = ""
        priceLabel.text = ""
        
        /// For each product in the order, we add the name and price to the labels on a new line
        for product in order.products{
            productLabel.text! += "\(product.name)\n"
            priceLabel.text! += "\(NumberFormatter.formatPrice(price: product.price, currency: "dkk"))\n"
            
        }
    }
    
    /// Sets the imageviews image and returns the string which displays the status
    /// Function that determines the image and text of the order status depending on how far the order is in the process
    func determineOrderStatus(order: Order) -> String{
        
        switch (order.orderStatus, order.archived){
        
        /// If the order is confirmed and not picked up
        case (true, false):
            /// Creates an UIImage with an icon and makes the image able to change color aka tintable
            statusImageView.image = createTintableImage(systemName: "smiley")!

            /// Sets the color of the image
            statusImageView.tintColor = .systemGreen
        
            /// Returns the text
            return "Order accepted"
        
        /// If the order is confirmed and not picked up
        case (true, true):
            statusImageView.image = createTintableImage(systemName: "checkmark.circle")!

            statusImageView.tintColor = .systemGreen

            return "Order picked up"
        
        /// If the order wasn't confirmed and deleted
        case (false, true):
            statusImageView.image = createTintableImage(systemName: "xmark.circle")!
            
            statusImageView.tintColor = .systemRed
            
            return "Order denied"
            
        /// If the order hasn't been accepted yet
        case (false, false):
            statusImageView.image = createTintableImage(systemName: "questionmark.circle")!
            
            statusImageView.tintColor = .systemOrange
            
            return "Order waiting response"
            
        default:
            return "n/a"
        }
/*
        /// If the order is confirmed and not picked up
        if order.orderStatus == true && order.archived == false{
            
            /// Creates an UIImage with an icon and makes the image able to change color aka tintable
            statusImageView.image = createTintableImage(systemName: "smiley")!

            /// Sets the color of the image
            statusImageView.tintColor = .systemGreen
        
            /// Returns the text
            return "Order accepted"
            
        /// If the order is accepted and has been picked up
        }else if order.orderStatus == true && order.archived == true{
            
            statusImageView.image = createTintableImage(systemName: "checkmark.circle")!

            statusImageView.tintColor = .systemGreen

            return "Order picked up"
            
        /// If the order wasn't confirmed and deleted
        }else if order.orderStatus == false && order.archived == true{
            
            statusImageView.image = createTintableImage(systemName: "xmark.circle")!
            
            statusImageView.tintColor = .systemRed
            
            return "Order denied"
            
        /// If the order hasn't been accepted yet
        }else if order.orderStatus == false{
            statusImageView.image = createTintableImage(systemName: "questionmark.circle")!
            
            statusImageView.tintColor = .systemOrange
            
            return "Order waiting response"
        
        /// Something wen't wrong
        }else{
            return "n/a"
        }
*/
    }
 
    
    func createTintableImage(systemName: String) -> UIImage?{
        if let myImage = UIImage(systemName: systemName){
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            return tintableImage
        }else{
            return nil
        }
    }
}
