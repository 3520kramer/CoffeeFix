//
//  AuthorizationManager.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 30/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthorizationManager{

    /// Declares a handle so we are able to close the auth listener later
    var handle: AuthStateDidChangeListenerHandle
    
    /// The auth object which holds the data
    var auth = Auth.auth()
    
    /// The view controller to which we need to update
    let parentVC: UIViewController
    
    /// When initializing the authorizationManager object, we add a listener which listens for updates to the auth object
    init(parentVC: UIViewController){
        self.parentVC = parentVC
        
        handle = auth.addStateDidChangeListener(){ (auth, user) in
            if let user = user {
                print("ID: \(user.uid)")
            }
        }
    }
    
    /// Responsible for closing the listener when we remove the view controller from the view hierarchy
    func closeListener(){
        self.auth.removeIDTokenDidChangeListener(handle)
    }

    /// Handles the signing in of a user
    func signIn(email: String, password: String, parent: SignInView){
        auth.signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let self = self else { return }
        
            if let error = error{
                print("Error: \(error.localizedDescription)")
               
            }else{
                parent.hideLogInOption()
            }
        }
    }
    
    // FOR DEMO PURPOSES - a sign out function
    func signOut(){
        do {
            try auth.signOut()
        } catch let error {
            print("Failed: \(error.localizedDescription)")
        }
    }
    
    
    // NEW
    // The create user function which updates the parent view as well
    func createUser(email:String, password: String, parent: SignInView){
        auth.createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error{
                print("Error: \(error.localizedDescription)")
            }else{
                parent.hideLogInOption()
            }
        }
    }
    
    func updateUsersName(name: String, parentVC: ProfileViewController, completion: @escaping () -> ()){
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        
        changeRequest?.displayName = name
        
        changeRequest?.commitChanges(completion: { (error) in
            if let error = error{
                print("Error: \(error.localizedDescription)")
            }else{
                completion()
            }
        })
    }
}
