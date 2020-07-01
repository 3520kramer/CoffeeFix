//
//  ProfileViewController.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 30/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var authManager: AuthorizationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        authManager = AuthorizationManager(parentVC: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = authManager.auth.currentUser{
            emailTextField.text = user.email
        }else{
            showSignInView()
        }
        checkIfUserHasName()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        authManager.closeListener()
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        authManager.signOut()
        showSignInView()
        
    }
    
    @IBAction func updateProfilePressed(_ sender: Any) {
        if let name = nameTextField.text{
            authManager.updateUsersName(name: name, parentVC: self, completion: {
                AlertControllers.showUpdateProfileConfirmation(parentVC: self, name: name)
            })
        }
    }
    
    /// checks if the user has a name and display relevant information based on the condition
    func checkIfUserHasName(){
        if let name = authManager.auth.currentUser?.displayName{
            infoLabel.text = "Your name"
            nameTextField.text = name
        }else{
            infoLabel.text = "You need to enter your name to be able to place an order"
            self.nameTextField.text = nil
            self.nameTextField.placeholder = "Enter name..."
        }
    }
    
    func setEmail(){
        if let user = authManager.auth.currentUser{
            emailTextField.text = user.email
        }
    }

    
    func showSignInView(){
        /// loads the view and assign it as a SignInView
        let signInView = Bundle.main.loadNibNamed("SignInView", owner: nil, options: nil)?[0] as! SignInView
        
        signInView.showLogInOption(parentVC: self)
    }
    
}
