//
//  CoffeeShop.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 26/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import MapKit

class CoffeeShop{
    
    var id: String
    var timeEstimateMin: Int
    var timeEstimateMax: Int
    var rating: Int
    var logoUUID: String
    var marker: MKPointAnnotation
    var distanceToUser: Double
    
    init(id: String, timeEstimateMin: Int, timeEstimateMax: Int, rating: Int, logoUUID: String, marker: MKPointAnnotation) {
        self.id = id
        self.timeEstimateMin = timeEstimateMin
        self.timeEstimateMax = timeEstimateMax
        self.rating = rating
        self.logoUUID = logoUUID
        self.marker = marker
        self.distanceToUser = 0
    }
    
}
