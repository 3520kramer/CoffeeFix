//
//  ViewController.swift
//  CoffeeFix
//
//  Created by Oliver Kramer on 25/06/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class NearbyViewController: UIViewController {

    @IBOutlet weak var map: MKMapView! //
    @IBOutlet weak var coffeeShopTableView: UITableView!
    
    var locationAuthorizationManager: LocationAuthorizationManager!
    
    var selectedCoffeeShop: CoffeeShop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /// Sets the delegate of the map to this viewcontroller
        map.delegate = self
        
        /// Sets the delegate and datasource of the tableView to this viewcontroller
        coffeeShopTableView.delegate = self
        coffeeShopTableView.dataSource = self
        
        /// Starts the Location Authorization Manager
        locationAuthorizationManager = LocationAuthorizationManager(map: map, parentVC: self)
        
        /// Starts checking for location service in the device
        locationAuthorizationManager.checkLocationService()
        
        /// Starts the listener for fetching coffeshop data from the db
        CoffeeShopCollection.startListener(parentVC: self)
    }
    
    /// Called each time the view controller is out of the current view
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
   // MARK: - Map View Setup
       
    /// Centers the view on the user location
    func centerViewOnUserLocation(){

    /// Unwraps the user locations coordinates which is an optional
    if let location = locationAuthorizationManager.locationManager.location?.coordinate {
           
        /// Sets the region
        let region = MKCoordinateRegion(center: location,
                                        latitudinalMeters: locationAuthorizationManager.regionInMeters,
                                        longitudinalMeters: locationAuthorizationManager.regionInMeters)
           
       /// Sets the region on the map with our newly created region
       map.setRegion(region, animated: true)
       }
   }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        if let segueDestination = segue.destination as? CoffeeShopViewController{
            if let selectedCoffeeShop = selectedCoffeeShop{
                segueDestination.coffeeShop = selectedCoffeeShop
            }
        }
    }
}

// MARK: - MapView Annotation setup - MK Map View extension to View Controller
extension NearbyViewController: MKMapViewDelegate{

    /// Function that styles each annotation accept the user location
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        /// We use a guard statement to check if the annotation is a user location
        /// If the annotation is a user location it shall return nil, or else proceed
        guard !(annotation is MKUserLocation) else { return nil }

        /// Sets the identifier
        let identifier = "annotation"

        /// Makes sure that we reuse an annotation if it's not in the current view
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        /// If there isn't already created annotation available we create a new one
        if annotationView == nil{
            
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) // Details button for annotation

        /// If there is one available we reuse it and fills it with data
        }else{
            annotationView?.annotation = annotation
        }
        
        /// Returns the styled annotation
        return annotationView
    }
     
    /// When you select an annotation we set that as the selected coffeeshop
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MKPointAnnotation, let title = annotation.title{
            
            /// Uses the list method first. Uses a closure to determine the first element in the list which meets our condition
            selectedCoffeeShop = CoffeeShopCollection.coffeeShopList.first { (CoffeeShop) -> Bool in
                return CoffeeShop.id == title
            }
        }
    }

    /// This function is called when you press the button on an annotation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
     
        /// Performs the segue to a new view controller with the menu for the coffeeshop
        performSegue(withIdentifier: "showCoffeeShop", sender: nil)
    }

}

// MARK: - User Location - Location Manager setup - CLLocation Manager extension to View Controller
extension NearbyViewController: CLLocationManagerDelegate{
    
    /// Every time the user moves, this function is called
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        /// Creates a CL Location Coordinate to use as center on the map
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        /// Creates the region which uses the center coordinate we just created
        let region = MKCoordinateRegion(center: center,
                                        latitudinalMeters: locationAuthorizationManager.regionInMeters,
                                        longitudinalMeters: locationAuthorizationManager.regionInMeters)
        
        /// Sets the maps region to our new region
        map.setRegion(region, animated: true)
        
        
        //calculateDistanceFromUserToCoffeeShop(userLocation: location)
    }
    
    /// if the authorization changes, then we need to call our checkAuthorization function
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationAuthorizationManager.checkLocationAuthorization()
    }
}

extension NearbyViewController: UITableViewDelegate, UITableViewDataSource{
    
    // Sets the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoffeeShopCollection.coffeeShopList.count
    }
    
    // configures the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coffeeShop = CoffeeShopCollection.coffeeShopList[indexPath.row]
        
        // makes it possible to reuse cells to save memory
        let cell = coffeeShopTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoffeeShopCell
        
        // sets the cell
        cell.setCell(vc: self, coffeeShop: coffeeShop)
        return cell
    }
    
    // sets the height of the cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // when selecting a cell we set the selected coffeeshop to this cell and performs the segue with the selected coffeeshop
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCoffeeShop = CoffeeShopCollection.coffeeShopList[indexPath.row]
        
        performSegue(withIdentifier: "showDetail", sender: nil)
        
        // removes the gray color shown when selecting a row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

