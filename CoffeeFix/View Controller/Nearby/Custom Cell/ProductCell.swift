//
//  ProductTableCell.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 30/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import UIKit

class ProductCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // cell initializer
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // behaviour for the cell if it is selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // Configures the cell data
    func setCell(product: Product){
        nameLabel.text = product.name
        
        
        // sets the pricelabel in the correct format
        priceLabel.text = NumberFormatter.formatPrice(price: product.price, currency: "dkk")
    }

}
