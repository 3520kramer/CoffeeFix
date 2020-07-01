//
//  CoffeeShopCell.swift
//  CoffeeAppForUser
//
//  Created by Oliver Kramer on 07/05/2020.
//  Copyright © 2020 Kea. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class CoffeeShopCell: UITableViewCell {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeEstimateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
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

    // configures the cell
    func setCell(vc: NearbyViewController, coffeeShop: CoffeeShop){
        print(coffeeShop.logoUUID)
        StorageFirebase.getLogoURL(logoUUID: coffeeShop.logoUUID) { (URL) in
            
            self.logoView.sd_setImage(with: URL, placeholderImage: UIImage(named: "placeholder"),options: SDWebImageOptions.highPriority, completed: nil)
        }
        nameLabel.text = coffeeShop.id
        timeEstimateLabel.text = "\(coffeeShop.timeEstimateMin) - \(coffeeShop.timeEstimateMax) minutes"
        ratingLabel.text = "\(coffeeShop.rating) / 5 stars"
        distanceLabel.text = formatDistance(distance: coffeeShop.distanceToUser)
        
    }
    
    // formats the distance to meters or kilometers dependant on the input
    func formatDistance(distance: Double) -> String?{
        // If statement to configure the right output
        if distance < 1000{
            let distanceRounded = (distance / 10).rounded(.down)*10
            return "\(distanceRounded) m"
            
        } else if distance < 10000{
            let distanceRounded = (distance / 100).rounded(.down)/10
            return "\(distanceRounded) km"
            
        } else {
            return nil
        }
    }
}
