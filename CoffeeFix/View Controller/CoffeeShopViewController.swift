//
//  ViewController2.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 26/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class CoffeeShopViewController: UIViewController {

    var coffeeShop: CoffeeShop?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(coffeeShop?.id)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
