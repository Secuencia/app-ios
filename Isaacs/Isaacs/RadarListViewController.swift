//
//  RadarListViewController.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 10/28/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import AVFoundation

class WeatherForecast {
    

    var location : CLLocation?
    
    var time: Float?
    
    var summary: String?
    
    var icon: String?
    
    var temperature: Double?
    
    
    init(location: CLLocation, time: Float, summary: String, icon: String, temperature: Double) {
        self.location = location
        self.time = time
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
    }

}


class RadarListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Setup weather api with temperature format and language
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var location: CLLocation = CLLocation(latitude: 4.717642, longitude: -74.047166)
    
    var weatherForecasts = [WeatherForecast]()
    
    var places = [GMSPlaceLikelihood]()
    
    var services = ["Context Info", "Weather", "Places"]
    
    var placesClient: GMSPlacesClient?
    
    let placesLimit = 5
    
    var parent: RadarSplitViewController? = nil
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "ForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "weather_cell")
        tableView.registerNib(UINib(nibName: "PlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "place_cell")
        tableView.registerNib(UINib(nibName: "NoiseLevelTableViewCell", bundle: nil), forCellReuseIdentifier: "noise_cell")
        
        
        GMSPlacesClient.provideAPIKey("AIzaSyAGcvu0TRmu2CbCgpDbBesmF80NE0ZQ67o")

        placesClient = GMSPlacesClient.sharedClient()
        
        loadPlaces()
        
        
        //let requestURL = NSURL(string: "http://www.learnswiftonline.com/Samples/subway.json")!
        
        let url = "https://api.darksky.net/forecast/7d447c6639d11e484916eeb28fed6416/" + String(location.coordinate.latitude) + "," + String(location.coordinate.longitude) + "?lang=es&units=ca"
        
        let requestURL = NSURL(string: url)!
        
        let urlRequest = NSMutableURLRequest(URL: requestURL)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                
                print("File successfully downloaded!")
                
                //self.checkTest(data!)
                
                self.getWeather(data!)
                
                
            }
        
        }
        
        task.resume()
                
        tableView.reloadData()
        

        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if(size.width<size.height){
            if (!(self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact && self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Regular)) {
                let item = UIBarButtonItem(image:.None, style: .Plain, target: self, action: #selector(dismiss))
                item.title = "Isaacs"
                self.navigationController?.navigationItem.leftBarButtonItem = nil
                self.navigationItem.leftBarButtonItem = item
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Brightness
        
        if NSUserDefaults.standardUserDefaults().boolForKey(KeysConstants.nightModeKey){
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(brightnessStateMonitor), name: "UIScreenBrightnessDidChangeNotification", object: nil)
            checkBrightness()
        } else {
            
            setDayTheme()
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return weatherForecasts.count
        } else {
            return places.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("noise_cell") as! NoiseLevelTableViewCell
            
            cell.setNoiseValue()
            
            return cell

        } else if indexPath.section == 1 {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("weather_cell") as! ForecastTableViewCell
            
            let forecast = weatherForecasts[indexPath.row]
            
            cell.temperature.text = String(format: "%.2f ºC", forecast.temperature!) //String(forecast.temperature!)
            
            cell.icon.image = UIImage(named: forecast.icon!)
            
            cell.summary.text = forecast.summary
            
            return cell
        
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("place_cell") as! PlacesTableViewCell
            
            let place = places[indexPath.row]
            
            cell.ranking.text = String(indexPath.row + 1)//String(format: "%.2f", place.place.r)
            
            cell.placeName.text = place.place.name
            
            cell.address.text = place.place.formattedAddress!.componentsSeparatedByString(", ")[0]
            
            var addressArray = place.place.formattedAddress!.componentsSeparatedByString(", ")
            
            addressArray.removeFirst()
            
            cell.cityCountry.text = addressArray.joinWithSeparator(", ")
            
            
            return cell
        
        }
        
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return services[section]
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    
    func checkTest(data: NSData) {
    
        do {
            
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let stations = json["stations"] as? [[String: AnyObject]] {
                
                for station in stations {
                    
                    if let name = station["stationName"] as? String {
                        
                        if let year = station["buildYear"] as? String {
                            print("INFO")
                            print(name, year)
                        }
                        
                    }
                    
                }
                
            }
            
        } catch {
            
            print("ERROR")
            
        }
    
    }
    
    func getWeather(data: NSData) {
    
        do {
            
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            var location : CLLocation?
            
            var time: Float?
            
            var summary: String?
            
            var icon: String?
            
            var temperature: Double?
            
            if let latitude = json["latitude"] as? Double, let longitude = json["longitude"] as? Double {
                location = CLLocation(latitude: latitude, longitude: longitude)
            }
            
            
            if let currently = json["currently"] as? [String:AnyObject] {
            
                time = currently["time"] as? Float
                summary = currently["summary"] as? String
                icon = currently["icon"] as? String
                temperature = currently["temperature"] as? Double
            
            }
            
            let currentForecast = WeatherForecast(location: location!, time: time!, summary: summary!, icon: icon! , temperature: temperature!)
            
            weatherForecasts.append(currentForecast)
            
            tableView.reloadData()
            
        } catch {
            
            print("ERROR")
            
        }
    
    }
    
    func loadPlaces() {
    
        placesClient?.currentPlaceWithCallback({
            (placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            print("No current place")
            
            if let placeLikelihoodList = placeLikelihoodList {

                for (index,likehood) in placeLikelihoodList.likelihoods.enumerate() {
                    
                    if index > self.placesLimit {break}
                    
                    let place = likehood
                    
                    self.places.append(place)
                
                }
                
                self.tableView.reloadData()
                
            }
        })
        
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.parent?.dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: Quick capture
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) { // This gets the notification automatically
        if (motion == .MotionShake){
            print("SHAKE")
            quickCaptureNewContent()
        }
    }
    
    func quickCaptureNewContent() {
        let alert = UIAlertController(title: "Captura rápida",
                                      message: "",
                                      preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Texto", style: .Default, handler: { (action: UIAlertAction!) in
            print("Text")
            let storyboard = self.storyboard
            let controller = storyboard!.instantiateViewControllerWithIdentifier( "InputViewController") as! InputViewController
            controller.entryModule = DashboardViewController.SelectedBarButtonTag.Text.rawValue
            self.presentViewController(controller, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Foto", style: .Default, handler: { (action: UIAlertAction!) in
            print("Photo")
            let storyboard = self.storyboard
            let controller = storyboard!.instantiateViewControllerWithIdentifier( "InputViewController") as! InputViewController
            controller.entryModule = DashboardViewController.SelectedBarButtonTag.Camera.rawValue
            controller.parentController = self
            self.presentViewController(controller, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Galería", style: .Default, handler: { (action: UIAlertAction!) in
            print("Gallery")
            let storyboard = self.storyboard
            let controller = storyboard!.instantiateViewControllerWithIdentifier( "InputViewController") as! InputViewController
            controller.entryModule = DashboardViewController.SelectedBarButtonTag.Gallery.rawValue
            self.presentViewController(controller, animated: true, completion: nil)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Audio", style: .Default, handler: { (action: UIAlertAction!) in
            print("Audio")
            let storyboard = self.storyboard
            let controller = storyboard!.instantiateViewControllerWithIdentifier( "InputViewController") as! InputViewController
            controller.entryModule = DashboardViewController.SelectedBarButtonTag.Audio.rawValue
            self.presentViewController(controller, animated: true, completion: nil)
        }))
        
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }



    


}


