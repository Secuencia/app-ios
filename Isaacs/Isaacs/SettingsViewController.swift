//
//  SettingsViewController.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 11/27/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

struct KeysConstants {
    static let stealthKey = "stealthCapture"
    static let lowPowerKey = "lowPowerMode"
    static let authenticationKey = "authentication"
    static let nightModeKey = "nightMode"
}

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var stealthModeSwitch: UISwitch!
    @IBOutlet weak var lowPowerModeSwitch: UISwitch!
    @IBOutlet weak var nightModeSwitch: UISwitch!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        stealthModeSwitch.on = defaults.boolForKey(KeysConstants.stealthKey)
        
        lowPowerModeSwitch.on = defaults.boolForKey(KeysConstants.lowPowerKey)

        
        nightModeSwitch.on = defaults.boolForKey(KeysConstants.nightModeKey)
    
        
        }
    
    
    @IBAction func updateUserPreference(sender: UISwitch){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if sender.tag == 0 {
            
            defaults.setBool(sender.on, forKey: KeysConstants.stealthKey)
            
        
        } else if sender.tag == 1 {
            
            defaults.setBool(sender.on, forKey: KeysConstants.lowPowerKey)
        
        } else {
            
            defaults.setBool(sender.on, forKey: KeysConstants.nightModeKey)
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

}
