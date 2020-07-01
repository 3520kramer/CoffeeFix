//
//  SignInView.swift
//  CoffeeAppForUser
//
//  Created by Oliver Kramer on 12/05/2020.
//  Copyright © 2020 Kea. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInView: UIView {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createUserButton: UIButton!
    
    /// Declares two buttonhandlers which gets initiated in the showLogInOption
    var signInButtonHandler: ((String, String) -> Void)?
    var createUserButtonHandler: ((String, String) -> Void)?
    
    /// Declares the parent view controller
    var parentVC: ProfileViewController?

    /// ViewDidLoad() aka init -  shows the log in option
    func showLogInOption(parentVC: ProfileViewController){
        
        /// sets the parent view controller
        self.parentVC = parentVC
        
        /// Creates a new view with a blurry effect
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        /// Assigns it a tag as identifier
        blurEffectView.tag = 1
        
        /// Sets the frame of the view to be the bounds of the viewcontroller (everything except tab bar controller)
        blurEffectView.frame = parentVC.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        /// The view is added as a subview
        parentVC.view.addSubview(blurEffectView)
        
        /// Assigns it a tag as identifier
        self.tag = 2
        
        // set it to center and adds it to the view
        self.center = parentVC.view.center
        parentVC.view.addSubview(self)
        
        
        // if the sign in button is pressed, we need to perform the signing in at firebase
        signInButtonHandler = { email, password in
            parentVC.authManager?.signIn(email: email, password: password, parent: self)
        }
        
        // NEW
        // The closure which was declared earlier now gets initiated and is ready to be called as a closure
        createUserButtonHandler = { email, password in
            parentVC.authManager?.createUser(email: email, password: password, parent: self)
        }
    }
    
    /// Handles when the user presses the sign in button
    @IBAction func signInPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            signInButtonHandler?(email, password)
        }
    }
    
    /// Handles when the user presses the create user button
    @IBAction func createUserPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            createUserButtonHandler?(email, password)
        }
    }
    
    
    /// Function that hides the view
    func hideLogInOption(){
        if let parentVC = parentVC{
            
            parentVC.checkIfUserHasName()
            
            parentVC.setEmail()

            UIView.transition(with: parentVC.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                
                parentVC.view.viewWithTag(1)?.removeFromSuperview() // removes sign in box
                parentVC.view.viewWithTag(2)?.removeFromSuperview() // removes blur effect
                
            }, completion: nil)
        }
    }

}

