//
//  ViewController.swift
//  Isaacs
//
//  Created by Sebastian Florez on 8/23/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

import EventKitUI

import AVFoundation

import CoreMotion

class DashboardViewController: UIViewController, UISplitViewControllerDelegate{

   
    // MARK: Properties - Interface
    
    @IBOutlet weak var textContentButton: UIButton!
    @IBOutlet weak var visualMediaContentButton: UIButton!
    @IBOutlet weak var galleryContentButton: UIButton!
    @IBOutlet weak var audioContentButton: UIButton!
    
    // ---------
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var contentsButton: UIButton!
    @IBOutlet weak var radarButton: UIButton!
    @IBOutlet weak var storiesButton: UIButton!
    
    
    
    // MARK: Properties - Interface Utils
    
    enum SelectedBarButtonTag: Int {
        case Text
        case Camera
        case Gallery
        case Audio
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        
        
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
        
        setUpViewMode(true)
        
        
        //sensors
        
        becomeFirstResponder() // Necesary to receive notifications of events
        
        // Brightness
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(brightnessStateMonitor), name: "UIScreenBrightnessDidChangeNotification", object: nil)
        
        // Proximity sensor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(proximityStateMonitor), name: "UIDeviceProximityStateDidChangeNotification", object: nil)
        
        
        // Orientation
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(orientationStateMonitor), name: "UIDeviceOrientationDidChangeNotification", object: nil)
        
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startDeviceMotionUpdates()
        
        // Recorder
        
        initRecorder()
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIDevice.currentDevice().proximityMonitoringEnabled = true
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        UIDevice.currentDevice().proximityMonitoringEnabled = false
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // Motion
    
    let  motionManager = CMMotionManager()
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) { // This gets the notification automatically
        if (motion == .MotionShake){
            print("SHAKE")
            printMotion()
        }
    }
    
    func printMotion() {
        
        if motionManager.accelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            //print("Accelerometer")
            print(motionManager.accelerometerData?.acceleration)
            //print("Gyroscope")
            print(motionManager.gyroData?.rotationRate)
            //retrieveMeasure()
            print(motionManager.deviceMotion?.attitude)
        }
        
        //motionManager.stopAccelerometerUpdates()
        //motionManager.stopGyroUpdates()
        //motionManager.stopDeviceMotionUpdates()
    }
    
    func orientationStateMonitor(notification: NSNotificationCenter) {
        print("ORIENTATION")
        print(UIDevice.currentDevice().orientation)
        print(UIDevice.currentDevice().orientation.isFlat)
    }
    
    // Ambient light
    
    func brightnessStateMonitor(notification: NSNotificationCenter) {
        let level = UIScreen.mainScreen().brightness
        if level >= 0.50 {
            setUpViewMode(false)
        } else {
            setUpViewMode(true)
        }
    }
    
    func setUpViewMode(nightMode: Bool){
        
        if nightMode {
            titleLabel.textColor = UIColor.lightGrayColor()
            self.view.backgroundColor = UIColor.darkGrayColor()
            contentsButton.backgroundColor = UIColor.lightGrayColor()
            radarButton.backgroundColor = UIColor.lightGrayColor()
            storiesButton.backgroundColor = UIColor.lightGrayColor()
            settingsButton.backgroundColor = UIColor.lightGrayColor()
        } else {
            titleLabel.textColor = UIColor.blackColor()
            self.view.backgroundColor = UIColor.whiteColor()
            contentsButton.backgroundColor = UIColor.clearColor()
            radarButton.backgroundColor = UIColor.clearColor()
            storiesButton.backgroundColor = UIColor.clearColor()
            settingsButton.backgroundColor = UIColor.clearColor()
        }
        
    }
    
    // Proximity sensor
    
    func proximityStateMonitor(notification: NSNotificationCenter){
        if UIDevice.currentDevice().proximityState {
            print("Device close to user")
            printNumbers()
            performSegueWithIdentifier("photoSegue", sender: nil)
        } else {
            print("Device NOT close to user")
        }
    }
   
    func printNumbers() {
        for i in 1...5 {
            print(i)
        }
    }
    
    // Mic as noise sensor
    
    var recorder:AVAudioRecorder!
    
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                          AVFormatIDKey : NSNumber(int: Int32(kAudioFormatAppleIMA4)),
                          AVNumberOfChannelsKey : NSNumber(int: 1),
                          AVLinearPCMBitDepthKey: NSNumber(int: 16),
                          AVLinearPCMIsBigEndianKey: false,
                          AVLinearPCMIsFloatKey: false]
    
    
    
    func initRecorder() {
        
        do{
            try recorder = AVAudioRecorder(URL: NSURL(string: NSTemporaryDirectory().stringByAppendingString("tmp.caf"))!, settings: recordSettings)
        }catch{
        
        }
        recorder.meteringEnabled = true
        
        
    }
    
    func retrieveMeasure() {
        
        recorder.record()
        recorder.updateMeters()
        let decibelsAvg = recorder.averagePowerForChannel(0)
        let decibelsPeak = recorder.peakPowerForChannel(0)
        print(decibelsAvg)
        print(decibelsPeak)
    
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
        
        if (segue.identifier == "showStories") {
            let inputController: StoriesSplitViewController = segue.destinationViewController as! StoriesSplitViewController
            inputController.delegate = self;
        }

    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? StoryDetailViewController else { return false }
        if topAsDetailController.story == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false

    }
   
    
    
    
    // MARK: Sensors
    
    // Ambient light
    
    // Accelerometer

    
}

