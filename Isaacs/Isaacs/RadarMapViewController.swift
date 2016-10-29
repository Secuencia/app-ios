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
    
    //var filters = {"stories": }
    
    var filterElements = [String: AnyObject]()
    
    var mapView: GMSMapView?
    
    let contentPersistence:ContentPersistence = ContentPersistence()
    
    let storyPersistence:StoryPersistence = StoryPersistence()
    
    let locationManager = CLLocationManager()
    
    let range = 30.0
    
    var lastLocationRetrieved: CLLocation? = nil
    
    var criteria = ["general":["all_stories"], /* o podria decir todas las historias */ "stories" : [], /* historias por las que quiera filtrar, debe eliminar contenidos redundantes (recorrer por contenido) */ "modules" : ["twitter"] /* O nada, si hay mas servicios se añaden aca*/]
    
    //let exampleCriteria: [String:[String]] = ["general":[], /* o podria decir todas las historias */ "stories" : ["historia 1", "historia 2"], /* historias por las que quiera filtrar, debe eliminar contenidos redundantes (recorrer por contenido) */ "modules" : ["twitter"] /* O nada, si hay mas servicios se añaden aca*/]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Radar"
        
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
        
        let initialLocation = CLLocation(latitude: 4.607692, longitude: -73.800312)
        
        let camera = GMSCameraPosition.cameraWithLatitude(initialLocation.coordinate.latitude, longitude: initialLocation.coordinate.longitude, zoom: 1)
        
        mapView = GMSMapView.mapWithFrame(self.view.bounds, camera: camera)
        
        mapView!.myLocationEnabled = true
        
        view.insertSubview(mapView!, atIndex: 0)
        
        updateFilter()

    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue = manager.location!
        
        if let lastLocation = lastLocationRetrieved {
            
            if (lastLocation.distanceFromLocation(locValue) > 50) {
                
                print("UPDATE")
                
                lastLocationRetrieved = locValue
                
                mapView?.clear()
                
                setUpMarkers()
                
                updateCamera()
                
                setUpBuffer()
                
            }
            
        } else { // First time location is retrieved
            
            print("FIRST TIME")
            
            lastLocationRetrieved = locValue
            
            setUpMarkers()
            
            updateCamera()
            
            setUpBuffer()
        
            
        }
    
        
    }
    
    func setUpBuffer(){
        
        let circle = GMSCircle(position: lastLocationRetrieved!.coordinate, radius: 1000.0)
        circle.fillColor = UIColor.redColor().colorWithAlphaComponent(0.1)
        circle.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.7)
        circle.map = mapView
        
    }
    
    
    func setUpMarkers() {
        
        //let contents = contentPersistence.getAll(Content.types.Text.rawValue)
        
        var markers = [GMSMarker]()
        
        let contents = filterElements["contents"] as! [Content]
        
        for content in  contents{
            
            let marker = GMSMarker()
            
            marker.position = CLLocationCoordinate2D(latitude: content.latitude! as Double, longitude: content.longitude! as Double)
            
            marker.title = content.type! + " of " + String(content.date_created!.iso8601)
            
            if let stories = content.stories {
                
                if stories.count != 0 {
                    
                    var storiesText = [String]()
                    
                    for story in stories {
                        storiesText.append(story.title!)
                    }
                    
                    marker.snippet = storiesText.joinWithSeparator(" ")
                    
                } else {
                
                    marker.snippet = "No associated stories"
                
                }
            
                
            } else {
                marker.snippet = "No associated stories"
            }
            
            marker.map = mapView
            
            markers.append(marker)
            
        }
        
        print("\n NUMBER OF MARKERS: ", markers.count)
    }
    
    
    func updateCamera() {
        
        let newCamera = GMSCameraPosition.cameraWithLatitude(lastLocationRetrieved!.coordinate.latitude, longitude: lastLocationRetrieved!.coordinate.longitude, zoom: 15)
        
        let update = GMSCameraUpdate.setCamera(newCamera)
        
        mapView!.animateWithCameraUpdate(update)

    }
    
    
    
    func updateFilter() {
        // Update filter elements with a criteria
        
        if criteria["general"]!.contains("all_contents") {
            
            let contentsToAppend = contentPersistence.getAll(nil)
            filterElements["contents"] = contentsToAppend

        
        } else if criteria["general"]!.contains("all_stories"){
            
            var contentsToAppend = [Content]()
            
            for content in contentPersistence.getAll(nil) {
                if content.stories?.count != 0 {
                    contentsToAppend.append(content)
                }
            }
            
            filterElements["contents"] = contentsToAppend
        
        } else {
            
            print("SOME STORIES")
            
            let storiesToLoad = criteria["stories"]
            
            print(storiesToLoad)
        
            
        }
        
        if  criteria["modules"]!.contains("twitter") {
        
            print("DO TWITTER STUFF")
        
        }
        
        
    }

    
  
    
    /*override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationItem.title = "Mapa"
    }*/
    

    /*@IBAction func dismissRadar(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }*/

}
