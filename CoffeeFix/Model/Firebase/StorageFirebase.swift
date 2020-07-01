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
    
    static func downloadImageOLD(logoUUID: String, imageView: UIImageView){
        
        let imgRef = storage.reference(withPath: logoUUID) /// Get file ref from firebase storage module
        
        /// Sets the limit on the size of the image to be downloaded with maxSixe
        /// Makes sure that the file is downloaded before moving going in the "function"
        imgRef.getData(maxSize: 4000000){ (data, error) in
            if error == nil{
                print("success in downloading img")
                
                if let image = UIImage(data: data!){
                    
                    /// A precation which updates the imageview when possible. Prevents background thread from interrupting the main thread, which handles user input
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
                
            }else{
                print("Error: \(error.debugDescription)")
            }
        }
    }
}
