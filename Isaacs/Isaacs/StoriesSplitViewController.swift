//
//  StoriesSplitViewController.swift
//  Isaacs
//
//  Created by Sebastian Florez on 11/24/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class StoriesSplitViewController: UISplitViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let masterNavigationController = self.viewControllers[0] as! UINavigationController
        (masterNavigationController.topViewController as! StoryListViewController).parent = self
        
        preferredDisplayMode = .AllVisible
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
