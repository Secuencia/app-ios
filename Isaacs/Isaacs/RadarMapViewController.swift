//
//  RadarMapViewController.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 10/23/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit
import GoogleMaps

class RadarMapViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GMSServices.provideAPIKey("")
        
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 6)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Get location", style: .Plain, target: self, action: #selector(RadarMapViewController.getLocation))
    }

    
    func getLocation(){
        print("Hello")
    }

    /*@IBAction func dismissRadar(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }*/

}
