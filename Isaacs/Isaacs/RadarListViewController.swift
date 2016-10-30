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
    
    var services = ["Weather", "Places"]
    
    var placesClient: GMSPlacesClient?
    
    let placesLimit = 5
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "ForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "weather_cell")
        tableView.registerNib(UINib(nibName: "PlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "place_cell")
        
        navigationItem.title = "Radar feed"
        
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return weatherForecasts.count
        } else {
            return places.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("weather_cell") as! ForecastTableViewCell
            
            let forecast = weatherForecasts[indexPath.row]
            
            cell.temperature.text = String(format: "%.2f ºC", forecast.temperature!) //String(forecast.temperature!)
            
            cell.icon.image = UIImage(named: forecast.icon!)
            
            cell.summary.text = forecast.summary
            
            return cell

        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("place_cell") as! PlacesTableViewCell
            
            let place = places[indexPath.row]
            
            cell.ranking.text = String(indexPath.row)//String(format: "%.2f", place.place.r)
            
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

    


}


