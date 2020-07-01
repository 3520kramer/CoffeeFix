//
//  AlertControllers.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 30/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import UIKit

class AlertControllers{
        
    /// Creates an alert controller and adds one or two actions depending on the argument
    static func presentMissingSigningInAlert(parentVC: UIViewController, hasCancel: Bool){
        let alertController = UIAlertController(title: "To be able to make an order you need to be signed in", message: "Please sign in", preferredStyle: .alert)
            
        /// Adds an action the the alert controller
        alertController.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { (action) in
            
            /// Creates a new profile viewcontroller
            let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "profileViewController") as ProfileViewController
            
            /// Presents it
            parentVC.present(profileViewController, animated: true, completion: nil)
            
        }))
        
        /// Depending on the argument we need to add a button to cancel the alert controller
        if hasCancel{
            alertController.addAction(UIAlertAction(title: "Never mind", style: .cancel, handler: nil))
        }
    
        parentVC.present(alertController, animated: true, completion: nil)
    }
    
    /// Presents the missing name alert
    static func presentMissingNameAlert(parentVC: UIViewController, hasCancel: Bool){
        let alertController = UIAlertController(title: "Name missing", message: "You need to update your profile with a name to be able to make an order", preferredStyle: .alert)
        
        /// Adds an action the the alert controller
        alertController.addAction(UIAlertAction(title: "Update profile", style: .default, handler: { (action) in
            /// Creates a new profile viewcontroller
            let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "profileViewController") as ProfileViewController
            
            /// Presents it
            parentVC.present(profileViewController, animated: true, completion: nil)
        }))
        
        /// Depending on the argument we need to add a button to cancel the alert controller
        if hasCancel{
            alertController.addAction(UIAlertAction(title: "Never mind", style: .cancel, handler: nil))
        }
        
        /// Presents the alertcontroller
        parentVC.present(alertController, animated: true, completion: nil)
     }
    
    // shows an alert controller with an order confirmation
    static func showOrderConfirmation(parentVC: UIViewController){
        
        let alertController = UIAlertController(title: "Success", message: "Your purchase has been confirmed", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Awesome", style: .default, handler: nil))
        
        parentVC.present(alertController, animated: true, completion: nil)
     }
    
    /// Shows a name confirmation
    static func showUpdateProfileConfirmation(parentVC: UIViewController, name: String){
        let alertController = UIAlertController(title: "Succes", message: "Your profile has been updated, \(name)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Move On", style: .cancel, handler: nil))
        parentVC.present(alertController, animated: true, completion: nil)
    }
    
    static func showBadInputAlert(parentVC: UIViewController){
        let alertController = UIAlertController(title: "Error", message: "You need to enter at least 6 characters", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        parentVC.present(alertController, animated: true, completion: nil)
    }
    
    

}
