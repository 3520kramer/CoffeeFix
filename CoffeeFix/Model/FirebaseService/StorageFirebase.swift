//
//  ImageRepo.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 29/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import FirebaseStorage


class StorageFirebase{

    private static let storage = Storage.storage() /// Gets the instance
        
    static func downloadImageOLD(logoUUID: String, completion: @escaping (UIImage) -> ()){
        
        let imgRef = storage.reference(withPath: logoUUID) /// Get file ref from firebase storage module
        
        /// Sets the limit on the size of the image to be downloaded with maxSixe
        /// Makes sure that the file is downloaded before moving going in the "function"
        imgRef.getData(maxSize: 4000000){ (data, error) in
            if error == nil{
                print("success in downloading img")
                
                if let image = UIImage(data: data!){
                    completion(image)
                }
                
            }else{
                print("Error: \(error.debugDescription)")
            }
        }
        
    }
    
    static func getLogoURL(logoUUID: String, completion: @escaping (URL?) -> ()){
        
        let imgRef = storage.reference(withPath: logoUUID) /// Get file ref from firebase storage module
        
        /// Downloads the url of the image from Storage
        imgRef.downloadURL { (URL, error) in
            /// We don't need to handle errors. The SDWebImage library will display a placeholder image if any error occurs
            completion(URL)
                
            /// Prints error message if there is one for debugging purposes
            if let error = error{
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    
    
    /*
    var downloadLogo: (String, UIImage) -> () = { logoUID, image in
        
    
    }
    
    // listens for changes and updates if changes are made to db
    static func startListener(completion: @escaping ([Note]) -> ([Note])){
        print("starting listener")
        db.collection(notesCollection).addSnapshotListener { (snap, error ) in
            print("yes")
            if error == nil{
                self.noteList.removeAll()
                for note in snap!.documents {
                    let map = note.data()
                    
                    // Lige nu fucker den fordi den har gemt noget lokalt så den kan ikke læse ordenligt fra firebase
                    let dateTime = map["dateTime"] as! String
                    let title = map["title"] as! String
                    let text = map["text"] as! String
                    let image = map["image"] as! String

                    let newNote = Note(id: note.documentID, dateTime: dateTime, title: title, text: text, image: image)
                    self.noteList.append(newNote)
                }
                //print(noteList[0].title)
                completion(noteList)
            }
        }
    }
    
    // simple closure saved in variable
    var greetSomeone: (String) -> () = { val in
        print("Hello \(val)")
    }
    greetSomeone("Søren")

    // closure that takes two arguments, and saved in variable
    var askSomeoneAboutSomeoneElse: (String, String) -> (String) = { val, val2 in
        return "Hi \(val), how is \(val2)?"
    }
    print(askSomeoneAboutSomeoneElse("Susanne", "Michael"))

    //
    var copyOfAskSomeoneAboutSomeoneElse = askSomeoneAboutSomeoneElse
    print(copyOfAskSomeoneAboutSomeoneElse("Søren", "Hans"))
 */
}
/*
 /// A precation which updates the imageview when possible. Prevents background thread from interrupting the main thread, which handles user input
 DispatchQueue.main.async {
     imageView.image = image
 }
 */
