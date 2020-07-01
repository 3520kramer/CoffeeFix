import UIKit

var str = "Hello, playground"

var coffeeShopList = ["yes", "hey", "sejt"]


let yes = coffeeShopList.first { (CoffeeShop) -> Bool in
    return CoffeeShop == "je"
}

print(yes)

var cond1 = true
var cond2 = false

switch (cond1, cond2) {

case (true, false):
    print("yes")
    
case (false, false):
    print("no")
    
default:
    print("wtf")
}
