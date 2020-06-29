import UIKit

var str = "Hello, playground"

var coffeeShopList = ["yes", "hey", "sejt"]


let yes = coffeeShopList.first { (CoffeeShop) -> Bool in
    return CoffeeShop == "je"
}

print(yes)

