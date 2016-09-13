//
//  ViewController.swift
//  Isaacs
//
//  Created by Sebastian Florez on 8/23/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

   
    @IBOutlet weak var textContentButton: UIButton!
    @IBOutlet weak var visualMediaContentButton: UIButton!
    @IBOutlet weak var audioContentButton: UIButton!
    @IBOutlet weak var contactContentButton: UIButton!
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Default Text button styling
        //textContentButton.layer.borderWidth = 2
        //textContentButton.layer.borderColor = UIColor.darkGrayColor().CGColor
        textContentButton.layer.shadowRadius = 3
        textContentButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        textContentButton.layer.shadowColor = UIColor.lightGrayColor().CGColor
        
        
        // Visual Media button styling
        visualMediaContentButton.backgroundColor = UIColor.cyanColor()
        visualMediaContentButton.layer.cornerRadius = 20
        visualMediaContentButton.layer.borderWidth = 0
        visualMediaContentButton.layer.borderColor = UIColor.clearColor().CGColor
        
        
        // Audio button styling
        audioContentButton.backgroundColor = UIColor.orangeColor()
        audioContentButton.layer.cornerRadius = 20
        audioContentButton.layer.borderWidth = 0
        audioContentButton.layer.borderColor = UIColor.clearColor().CGColor
        
        // Contact button styling
        contactContentButton.backgroundColor = UIColor.magentaColor()
        contactContentButton.layer.cornerRadius = 20
        contactContentButton.layer.borderWidth = 0
        contactContentButton.layer.borderColor = UIColor.clearColor().CGColor
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /*override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
     
     button.layer.cornerRadius = button.frame.height / 2
     
     buttonCamera.layer.cornerRadius = button.frame.height / 2
     
     buttonContact.layer.cornerRadius = buttonContact.frame.height / 2
     }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "textSegue") {
            print("Entra")
            let inputController: InputViewController = segue.destinationViewController as! InputViewController
            inputController.context = "text"
        }
        
        if (segue.identifier == "photoSegue") {
            let inputController: InputViewController = segue.destinationViewController as! InputViewController
            inputController.context = "photo"
        }
        
        if (segue.identifier == "audioSegue") {
            let inputController: InputViewController = segue.destinationViewController as! InputViewController
            inputController.context = "audio"
        }
        
        if (segue.identifier == "contactSegue") {
            let inputController: InputViewController = segue.destinationViewController as! InputViewController
            inputController.context = "contact"
        }
    }

    
    
}

