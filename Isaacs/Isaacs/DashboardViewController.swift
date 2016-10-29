//
//  ViewController.swift
//  Isaacs
//
//  Created by Sebastian Florez on 8/23/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

   
    // MARK: Properties - Interface
    
    @IBOutlet weak var textContentButton: UIButton!
    @IBOutlet weak var visualMediaContentButton: UIButton!
    @IBOutlet weak var galleryContentButton: UIButton!
    @IBOutlet weak var audioContentButton: UIButton!
    
    
    // MARK: Properties - Interface Utils
    
    enum SelectedBarButtonTag: Int {
        case Text
        case Camera
        case Gallery
        case Audio
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Default Text button styling
        //textContentButton.layer.borderWidth = 2
        //textContentButton.layer.borderColor = UIColor.darkGrayColor().CGColor
        textContentButton.layer.shadowRadius = 3
        textContentButton.layer.borderWidth = 1
        textContentButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        textContentButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        textContentButton.layer.shadowColor = UIColor.lightGrayColor().CGColor
        
        
        // Visual Media button styling
        visualMediaContentButton.backgroundColor = UIColor.cyanColor()
        visualMediaContentButton.layer.cornerRadius = 20
        visualMediaContentButton.layer.borderWidth = 0
        visualMediaContentButton.layer.borderColor = UIColor.clearColor().CGColor
        visualMediaContentButton.setImage(UIImage(named: "Camera"), forState: .Normal)
        visualMediaContentButton.tintColor = UIColor.whiteColor()
        visualMediaContentButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        
        // Gallery Media button styling
        galleryContentButton.backgroundColor = UIColor.magentaColor()
        galleryContentButton.layer.cornerRadius = 20
        galleryContentButton.layer.borderWidth = 0
        galleryContentButton.layer.borderColor = UIColor.clearColor().CGColor
        galleryContentButton.setImage(UIImage(named: "Gallery"), forState: .Normal)
        galleryContentButton.tintColor = UIColor.whiteColor()
        galleryContentButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        
        
        // Audio button styling
        audioContentButton.backgroundColor = UIColor.orangeColor()
        audioContentButton.layer.cornerRadius = 20
        audioContentButton.layer.borderWidth = 0
        audioContentButton.layer.borderColor = UIColor.clearColor().CGColor
        audioContentButton.setImage(UIImage(named: "Record"), forState: .Normal)
        audioContentButton.tintColor = UIColor.whiteColor()
        audioContentButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: Navigation bar setup
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "textSegue") {
            let inputController: InputViewController = segue.destinationViewController as! InputViewController
            inputController.entryModule = SelectedBarButtonTag.Text.rawValue
        }
        
        if (segue.identifier == "photoSegue") {
            let inputController: InputViewController = segue.destinationViewController as! InputViewController
            inputController.entryModule = SelectedBarButtonTag.Camera.rawValue
        }
        
        if (segue.identifier == "gallerySegue") {
            let inputController: InputViewController = segue.destinationViewController as! InputViewController
            inputController.entryModule = SelectedBarButtonTag.Gallery.rawValue
        }
        
        if (segue.identifier == "audioSegue") {
            let inputController: InputViewController = segue.destinationViewController as! InputViewController
            inputController.entryModule = SelectedBarButtonTag.Audio.rawValue
        }
        

    }

    
}

