//
//  RadarListViewController.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 10/28/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit


class RadarListViewController: UIViewController {
    // Setup weather api with temperature format and language

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Radar feed"
        
        getWeatherData("https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22nome%2C%20ak%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")

        // Do any additional setup after loading the view.
    }

    func getWeatherData(urlString: String) {
    
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(),
                           { self.printData(data!)
            })
        }
        
        task.resume()
    }
    
    func printData(weatherData : NSData) {
        
        let json = try? NSJSONSerialization.JSONObjectWithData(weatherData, options: []) as! String
        
        
        print(json)
        
    }

}
