//
//  Formatter.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 30/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation

class NumberFormatter{

    static func formatPrice(price: Double, currency: String) -> String{
        let formatter: String
               
        // if-statement to check if the number contains relevant digits or not
        if (price - floor(price) > 0.01) {
           formatter = "%.1f" // allow one digit
        }else{
           formatter = "%.0f" // will not allow any digits
        }

        /// Returns the number in the correct format with in the wished currency
        return "\(String(format: formatter, price)) \(currency)"
    }
    
    static func formatDateTime(date: Date) -> (Int, String){
        /// Creates a dateformatter and changes format
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "HHmmss"

        let timeFormatted = Int(dateTimeFormatter.string(from: date))!

        dateTimeFormatter.dateFormat = "dd/MM-yyyy"

        let dateFormatted = dateTimeFormatter.string(from: date)
        
        return (timeFormatted, dateFormatted)
    }
    
    static func formatTimeFromFirebase(time:Int) -> String {
        
        let timeString = NSMutableString(string: String(time))
        timeString.insert(":", at: 4)
        timeString.insert(":", at: 2)

        return String(timeString)
    }
    
}
