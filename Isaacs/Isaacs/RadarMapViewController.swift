//
//  RadarMapViewController.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 10/23/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class RadarMapViewController: UIViewController, CLLocationManagerDelegate {
    
    
    var mapView: GMSMapView?
    
    let persistence:ContentPersistence = ContentPersistence()
    
    let locationManager = CLLocationManager()
    
    let range = 30.0
    
    var lastLocationRetrieved: CLLocationCoordinate2D? = nil
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location manager
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Location manager
        

        GMSServices.provideAPIKey("AIzaSyAGcvu0TRmu2CbCgpDbBesmF80NE0ZQ67o")
        
        lastLocationRetrieved = getCurrentLocation()!.coordinate
        
        let camera = GMSCameraPosition.cameraWithLatitude(lastLocationRetrieved!.latitude, longitude: lastLocationRetrieved!.longitude, zoom: 15)
        
        mapView = GMSMapView.mapWithFrame(self.view.bounds, camera: camera)
        
        mapView!.myLocationEnabled = true
        
        //view = mapView
        
        view.insertSubview(mapView!, atIndex: 0)
        
        setUpMarkers()
        

    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        lastLocationRetrieved = locValue
        
        let threshold = 20
        
        if (true) { // Threshold computation
            lastLocationRetrieved = locValue
            setUpMarkers()
        }
        
    }
    
    
    func setUpMarkers() {
        
        let contents = persistence.getAll(Content.types.Text.rawValue)
        
        print("INICIO")
        for content in contents {
            
            if content.latitude! != 0 && content.longitude! != 0 {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: content.latitude! as Double, longitude: content.longitude! as Double)
                marker.title = String(content.date_created!)
                marker.snippet = content.type!
                marker.map = mapView
                print(content.longitude)
            }
            
        }
        print("FIN")
    }
    
    
    func getCurrentLocation() -> CLLocation? {
        
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        
        var currentLocation : CLLocation? = nil
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
            
            currentLocation = locManager.location
            
        }
        
        return currentLocation
    }

    
    @IBAction func openListView(sender: UIBarButtonItem) {
        print("SHOULD OPEN THE LIST VIEW")
    }
    

    /*@IBAction func getLocationWithSender(sender: UIBarButtonItem) {
     
     mapView?.clear()
     
     /*let locManager = CLLocationManager()
     locManager.requestWhenInUseAuthorization()
     
     var currentLocation : CLLocation? = nil
     
     if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
     CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
     
     currentLocation = locManager.location
     
     }
     
     print("CURRENT LOCATION")
     print(currentLocation)
     navigationItem.title = String(currentLocation)
     
     let marker = GMSMarker()
     marker.position = CLLocationCoordinate2D(latitude:currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
     marker.title = "My first marker"
     marker.snippet = "Yeah"
     marker.map = mapView
     
     let camera = GMSCameraPosition.cameraWithLatitude(currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude, zoom: 6)
     
     mapView?.animateToCameraPosition(camera)*/
     
     
     }*/
    
    
  
    
    /*override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationItem.title = "Mapa"
    }*/
    

    /*@IBAction func dismissRadar(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }*/

}
