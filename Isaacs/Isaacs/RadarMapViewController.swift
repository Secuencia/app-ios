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

class RadarMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    //var filters = {"stories": }
    
    var filterElements = [String: AnyObject]()
    
    var filterContents = [Content]()
    
    var mapView: GMSMapView?
    
    let contentPersistence:ContentPersistence = ContentPersistence()
    
    let storyPersistence:StoryPersistence = StoryPersistence()
    
    let locationManager = CLLocationManager()
    
    let radius = 850.0
    
    var lastLocationRetrieved: CLLocation? = nil
    
    var parent: RadarSplitViewController? = nil
    
    var criteria = ["general":["all_contents"], /* o podria decir todas las historias */ "stories" : [], /* historias por las que quiera filtrar, debe eliminar contenidos redundantes (recorrer por contenido) */ "modules" : ["twitter"] /* O nada, si hay mas servicios se añaden aca*/]
    
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
        mapView!.delegate = self
        mapView!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        
        self.view.insertSubview(mapView!, atIndex: 0)
        
        //updateFilter()
        
        
        if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular) {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        

    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if(size.width>size.height){
            //IPHONE 7 Plus
            if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular) {
                self.navigationItem.leftBarButtonItem = nil
                self.navigationController?.navigationItem.hidesBackButton = true
            }
            //IPHONE 7
            if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular && self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact) {
                let item = UIBarButtonItem(title: "Isaacs", style: .Plain, target: self, action: #selector(dismiss))
                self.navigationItem.leftBarButtonItem = item
            }

        }
        else{
            if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular && self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact || self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact && self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact) {
                let item = UIBarButtonItem(title: "Isaacs", style: .Plain, target: self, action: #selector(dismiss))
                self.navigationItem.leftBarButtonItem = item
            }
        }
    }
    
    // MARK: Nightmode
    
    func brightnessStateMonitor(notification: NSNotificationCenter) {
        checkBrightness()
    }
    
    func checkBrightness(){
        let level = UIScreen.mainScreen().brightness
        if level >= 0.50 {
            setUpViewMode(false)
        } else {
            setUpViewMode(true)
        }
    }
    
    func setUpViewMode(nightMode: Bool){
        
        if nightMode {
            print("IS HERE")
            navigationController?.navigationBar.barStyle = UIBarStyle.Black
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            
        } else {
            
            setDayTheme()
            
        }
        
    }
    
    func setDayTheme() {
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue = manager.location!
        
        if let lastLocation = lastLocationRetrieved {
            
            if (lastLocation.distanceFromLocation(locValue) > 50) {
                
                print("UPDATE")
                
                lastLocationRetrieved = locValue
                
                //mapView?.clear()
                
                //setUpMarkers()
                
                updateCamera()
                
                //setUpBuffer()
                
                updateFilter()
                
            }
            
        } else { // First time location is retrieved
            
            print("FIRST TIME")
            
            lastLocationRetrieved = locValue
            
            //setUpMarkers()
            
            updateCamera()
            
            //setUpBuffer()
        
            updateFilter()
            
        }
    
        
    }
    
    func setUpBuffer(){
        
        let circle = GMSCircle(position: lastLocationRetrieved!.coordinate, radius: radius)
        circle.fillColor = UIColor.magentaColor().colorWithAlphaComponent(0.1)
        circle.strokeColor = UIColor.magentaColor().colorWithAlphaComponent(0.7)
        circle.map = mapView
        
    }
    
    
    func setUpMarkers() {
        
        //let contents = contentPersistence.getAll(Content.types.Text.rawValue)
                        
        var markers = [GMSMarker]()
        
        let contents = filterContents// filterElements["contents"] as! [Content]
        
        for content in  contents{
            
            let locationContent = CLLocation(latitude: content.latitude as! Double, longitude: content.longitude as! Double)
            
            let distance = locationContent.distanceFromLocation(lastLocationRetrieved!)

            
            if  distance < radius { // Not working (is the other way around
                
                let marker = GMSMarker()
                
                marker.position = CLLocationCoordinate2D(latitude: content.latitude! as Double, longitude: content.longitude! as Double)
                
                //marker.title = content.type! + " of " + String(content.date_created!.iso8601)
                
                // Icon
                
                let markerView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                
                let type = content.type!
                
                if type == Content.types.Text.rawValue {
                    
                    let icon = UIImage(named: "Text")!.imageWithRenderingMode(.AlwaysTemplate)
                    
                    markerView.image = icon
                    
                } else if type == Content.types.Picture.rawValue {
                    
                    let icon = UIImage(named: "Gallery")!.imageWithRenderingMode(.AlwaysTemplate)
                    
                    markerView.image = icon
                    
                } else if type == Content.types.Audio.rawValue {
                    
                    let icon = UIImage(named: "Record")!.imageWithRenderingMode(.AlwaysTemplate)
                    
                    markerView.image = icon
                    
                }
                
                markerView.tintColor = UIColor.blackColor()
                marker.iconView = markerView
                
                // Icon
                
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
                
                marker.userData = content
                
                markers.append(marker)
                
                
            }
            
            
        }
        
        for marker in markers {
            print(marker.position)
        }
        
        print("\n NUMBER OF MARKERS: ", markers.count)
    }
    
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let content = marker.userData as! Content
        
        if content.type! == Content.types.Text.rawValue {
            
            let customView = NSBundle.mainBundle().loadNibNamed("CustomInfoView", owner: self, options: nil)!.first as! CustomInfoView
            
            customView.setUpContent(content)
            
            customView.frame = CGRectMake(0, 0, 300, 80)
            
            return customView
        
        }else if content.type! == Content.types.Picture.rawValue {
            
            let customView = NSBundle.mainBundle().loadNibNamed("ImageCustomInfoView", owner: self, options: nil)!.first as! ImageCustomInfoView
        
            customView.setUpContent(content)
            
            customView.frame = CGRectMake(0, 0, 150, 150)
            
            return customView
            
        } else {
            
            let customView = NSBundle.mainBundle().loadNibNamed("AudioCustomInfoView", owner: self, options: nil)!.first as! AudioCustomInfoView
            
            customView.setUpContent(content)
            
            customView.frame = CGRectMake(0, 0, 300, 80)
            
            return customView
        
        }
        
    }
    
    
    
    func updateCamera() {
        
        let newCamera = GMSCameraPosition.cameraWithLatitude(lastLocationRetrieved!.coordinate.latitude, longitude: lastLocationRetrieved!.coordinate.longitude, zoom: 15)
        
        let update = GMSCameraUpdate.setCamera(newCamera)
        
        mapView!.animateWithCameraUpdate(update)

    }
    
    
    
    func updateFilter() {
        // Update filter elements with a criteria
        
        mapView?.clear()
        
        setUpBuffer()
        
        if criteria["general"]!.contains("all_contents") {
            
            let contentsToAppend = contentPersistence.getAll(nil)
            filterElements["contents"] = contentsToAppend
            filterContents = contentsToAppend

            setUpMarkers()
        
        } else if criteria["general"]!.contains("all_stories"){
            
            var contentsToAppend = [Content]()
            
            for content in contentPersistence.getAll(nil) {
                if content.stories?.count != 0 {
                    contentsToAppend.append(content)
                }
            }
            
            filterElements["contents"] = contentsToAppend
            filterContents = contentsToAppend
            
            setUpMarkers()
        
        }
        
        if criteria["stories"]!.count != 0 {
            
            print("SOME STORIES")
            
            let storiesToLoad = criteria["stories"]
            
            print(storiesToLoad)
            
            var contentsToAppend = [Content]()
            
            for content in contentPersistence.getAll(nil) {
                if content.stories?.count != 0 {
                    for story in content.stories! {
                        if storiesToLoad!.contains(story.title!) {
                            contentsToAppend.append(content)
                            break
                        }
                    }
                }
            }
        
            filterElements["contents"] = contentsToAppend
            filterContents = contentsToAppend
            
        }
        
        if  criteria["modules"]!.contains("twitter") {
        
            //print("DO TWITTER STUFF")
            
            print(criteria)
        
        }
        
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
               
        if segue.identifier == "services" {
            let destinationNavController = segue.destinationViewController as! UINavigationController
            let radarListController = destinationNavController.topViewController as! RadarListViewController
            
            if let location = lastLocationRetrieved {
                radarListController.location = location
            }
            print(radarListController.navigationItem.title)
            radarListController.navigationItem.leftBarButtonItem = nil
            
            
        }
    }
  
    @IBAction func dismiss(sender: AnyObject) {
        self.parent?.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewWillAppear(animated: Bool) {
        //self.navigationController?.navigationItem.title = "Mapa"
        
        // Brightness
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey(KeysConstants.nightModeKey){
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(brightnessStateMonitor), name: "UIScreenBrightnessDidChangeNotification", object: nil)
            checkBrightness()
        } else {
            
            setDayTheme()
        }
    }

}
