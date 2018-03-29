//
//  ViewController.swift
//  TrickorEatApp
//
//  Created by gamora_4500 on 2018-03-25.
//  Copyright © 2018 cis_4500. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet var showTags: UITextView!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    
    //If the user disables location services, then it will show the University of Guelph Campus
    let defaultLocation = CLLocation(latitude: 43.530879, longitude: -80.226041)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GeotagButton Config
        //GeotagButton.layer.cornerRadius = 8
        //GeotagButton.layer.borderWidth = 1
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set the size of the Google Maps window
        //Determine the pixel height
        let screenSize: CGRect = UIScreen.main.bounds
        let mapWidth = screenSize.width
        let mapHeight = screenSize.height-100
        
        //The bottom navigation bar takes 10% of the screen
        let barHeight = screenSize.height/10
        let mapFrame = CGRect(x: 0, y: 60, width: mapWidth, height: mapHeight-barHeight) //Tab bar is 49 px
        
        if (CLLocationManager.locationServicesEnabled()){
        //Initalize the map to the viewer's current location
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.distanceFilter = 50
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            print ("Location Services are not enabled.")
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        
        mapView = GMSMapView.map(withFrame: mapFrame, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        mapView.settings.compassButton = true
        
        // Creates a marker with the bus pickup location
        let busMarker = GMSMarker()
        busMarker.position = CLLocationCoordinate2D(latitude: 43.531957, longitude: -80.219103)
        busMarker.title = "Group 6 Pickup Location"
        busMarker.snippet = "Parking Lot 13"
        busMarker.map = mapView
        
        // Creates a marker with the goods dropoff location
        let goodsMarker = GMSMarker()
        goodsMarker.icon = GMSMarker.markerImage(with: .orange)
        goodsMarker.position = CLLocationCoordinate2D(latitude: 43.531896, longitude: -80.230188)
        goodsMarker.title = "Donation Dropoff Location"
        goodsMarker.snippet = "Johnston Green"
        goodsMarker.map = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func insertTag(_ sender: UIButton) {
        currentLocation = locationManager.location
        let addString = "\n<" + String(currentLocation.coordinate.latitude) + "," + String(currentLocation.coordinate.longitude) + ">"
        showTags.text = showTags.text + addString
    }
    
}

//Location Manager delegates
extension ViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    //Location Manager Authorization, uses the example from Google
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
            locationManager.stopUpdatingLocation()
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
            locationManager.stopUpdatingLocation()
        case .notDetermined:
            print("Location status not determined.")
            locationManager.requestWhenInUseAuthorization()
            locationManager.stopUpdatingLocation()
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            locationManager.startUpdatingLocation()
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    

}
