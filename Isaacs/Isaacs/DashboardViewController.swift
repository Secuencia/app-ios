//
//  ViewController.swift
//  Isaacs
//
//  Created by Sebastian Florez on 8/23/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /*override func viewDidAppear(animated: Bool)
    {
        let width_portion = self.view.bounds.width/4;
        
        UIView.animateWithDuration(2.0, animations: {
            
            //Audio button
            self.audio_button.center.y = self.view.bounds.height - self.audio_button.bounds.height - 50
            
            self.audio_button.center.x = self.audio_button.bounds.width/2
            
            //Pic button
            self.pic_button.center.y = self.view.bounds.height - self.pic_button.bounds.height - 50
            
            self.pic_button.center.x = width_portion * 2 - self.pic_button.bounds.width
            
            //Text button
            self.text_button.center.y = self.view.bounds.height - self.text_button.bounds.height - 50;
            
            self.text_button.center.x = width_portion * 2 + self.pic_button.bounds.width
            
            
            //Contact Button
            self.contact_button.center.y = self.view.bounds.height - self.contact_button.bounds.height - 50;
            
            self.contact_button.center.x = self.view.bounds.width - self.contact_button.bounds.width/2
        })
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func captureSelection(sender: UIButton) {
        print("Entre")
    }

}

