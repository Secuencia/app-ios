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
import LocalAuthentication

class DashboardViewController: UIViewController, UISplitViewControllerDelegate{

   
    // MARK: Properties - Interface
    
    @IBOutlet weak var textContentButton: UIButton!
    @IBOutlet weak var visualMediaContentButton: UIButton!
    @IBOutlet weak var galleryContentButton: UIButton!
    @IBOutlet weak var audioContentButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    // ---------
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var contentsButton: UIButton!
    @IBOutlet weak var radarButton: UIButton!
    @IBOutlet weak var storiesButton: UIButton!
    
    var authenticationContext = LAContext()
    
    var auth:Bool = false {
        didSet {
            if auth {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alpha = CGFloat(1)
                    
                    self.titleLabel.alpha = 1
                    
                    self.textContentButton.enabled = true
                    self.textContentButton.alpha = alpha
                    
                    self.visualMediaContentButton.enabled = true
                    self.visualMediaContentButton.alpha = alpha
                    
                    self.galleryContentButton.enabled = true
                    self.galleryContentButton.alpha = alpha
                    
                    self.audioContentButton.enabled = true
                    self.audioContentButton.alpha = alpha
                    
                    self.contentsButton.enabled = true
                    self.contentsButton.alpha = alpha
                    
                    self.radarButton.enabled = true
                    self.radarButton.alpha = alpha
                    
                    self.storiesButton.enabled = true
                    self.storiesButton.alpha = alpha
                    
                    self.settingsButton.enabled = true
                    self.settingsButton.alpha = alpha
                    
                    self.lockButton.setBackgroundImage(UIImage(named: "unlocked-normal"), forState: .Normal)
                })
                
            }
            else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alpha = CGFloat(0.2)
                    
                    self.titleLabel.alpha = alpha
                    
                    self.textContentButton.enabled = false
                    self.textContentButton.alpha = alpha
                    
                    self.visualMediaContentButton.enabled = false
                    self.visualMediaContentButton.alpha = alpha
                    
                    self.galleryContentButton.enabled = false
                    self.galleryContentButton.alpha = alpha
                    
                    self.audioContentButton.enabled = false
                    self.audioContentButton.alpha = alpha
                    
                    self.contentsButton.enabled = false
                    self.contentsButton.alpha = alpha
                    
                    self.radarButton.enabled = false
                    self.radarButton.alpha = alpha
                    
                    self.storiesButton.enabled = false
                    self.storiesButton.alpha = alpha
                    
                    self.settingsButton.enabled = false
                    self.settingsButton.alpha = alpha
                    
                    self.lockButton.setBackgroundImage(UIImage(named: "locked-normal"), forState: .Normal)
                })
            }
        }
    }
    
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
        var radius = 20
        if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular && self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Regular) {
            radius = 25
        }
        visualMediaContentButton.backgroundColor = UIColor.cyanColor()
        print(visualMediaContentButton.bounds.height)
        visualMediaContentButton.layer.cornerRadius = CGFloat(radius)
        visualMediaContentButton.layer.borderWidth = 0
        visualMediaContentButton.layer.borderColor = UIColor.clearColor().CGColor
        visualMediaContentButton.setImage(UIImage(named: "Camera"), forState: .Normal)
        visualMediaContentButton.tintColor = UIColor.whiteColor()
        visualMediaContentButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        
        // Gallery Media button styling
        galleryContentButton.backgroundColor = UIColor.magentaColor()
        galleryContentButton.layer.cornerRadius = CGFloat(radius)
        galleryContentButton.layer.borderWidth = 0
        galleryContentButton.layer.borderColor = UIColor.clearColor().CGColor
        galleryContentButton.setImage(UIImage(named: "Gallery"), forState: .Normal)
        galleryContentButton.tintColor = UIColor.whiteColor()
        galleryContentButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        
        
        // Audio button styling
        audioContentButton.backgroundColor = UIColor.orangeColor()
        audioContentButton.layer.cornerRadius = CGFloat(radius)
        audioContentButton.layer.borderWidth = 0
        audioContentButton.layer.borderColor = UIColor.clearColor().CGColor
        audioContentButton.setImage(UIImage(named: "Record"), forState: .Normal)
        audioContentButton.tintColor = UIColor.whiteColor()
        audioContentButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        setUpViewMode(true)
        
        
        //sensors
        
        becomeFirstResponder() // Necesary to receive notifications of events
        
        
        
        // Recorder
        
        initRecorder()
        
        auth = false
    }
    
    func promptAuthentication(){
        authenticationContext.evaluatePolicy(
            .DeviceOwnerAuthentication,
            localizedReason: "Debes autenticarte para capturar y acceder a tus contenidos",
            reply: { [unowned self] (success, error) -> Void in
                if( success ) {
                   self.auth = true
                }
                else {
                    
                    // Check if there is an error
                    if error != nil {
                        self.auth = false
                    }
                }
            })
    }
    
    func promptForPin() -> Bool{
        print("Autenticacion por pin")
        return true
    }
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        showAlertWithTitle("Error", message: "This device does not have a TouchID sensor.")
        
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertVC.addAction(okAction)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.presentViewController(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if NSUserDefaults.standardUserDefaults().boolForKey(KeysConstants.stealthKey) {UIDevice.currentDevice().proximityMonitoringEnabled = true}
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        if NSUserDefaults.standardUserDefaults().boolForKey(KeysConstants.stealthKey) {UIDevice.currentDevice().proximityMonitoringEnabled = false}
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // Motion
    
    var motionManager: CMMotionManager? = CMMotionManager()
    
    func setUpMotion() {
        
        motionManager!.deviceMotionUpdateInterval = 1 / 10
        
        motionManager?.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (data, error) in
            if let attitude = data?.attitude {
                
                _ = NSString(format:"%.2f",(attitude.pitch)) as String
                _ = NSString(format:"%.2f",(attitude.roll)) as String
                _ = NSString(format:"%.2f",(attitude.yaw)) as String
                
                if (attitude.pitch) < 0 {
                    self.addView()
                } else {
                    self.deleteView()
                }
                
            }
        })
        
    }
    
    func finishMotion() {
        
        motionManager!.stopDeviceMotionUpdates()
        
        motionManager = nil
    
    }
    
    func addView() {
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        myView.backgroundColor = UIColor.blackColor()
        myView.tag = 100
        self.view.addSubview(myView)
    }
    
    func deleteView() {
        
        if let myView = self.view.viewWithTag(100) {
            myView.removeFromSuperview()
        }
        
    }

    
    
    // Ambient light
    
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
            titleLabel.textColor = UIColor.lightGrayColor()
            self.view.backgroundColor = UIColor.darkGrayColor()
            
            contentsButton.setBackgroundImage(UIImage(named: "contents-nm"), forState: .Normal)
            radarButton.setBackgroundImage(UIImage(named: "radar-nm"), forState: .Normal)
            storiesButton.setBackgroundImage(UIImage(named: "stories-nm"), forState: .Normal)
            settingsButton.setBackgroundImage(UIImage(named: "settings-nm"), forState: .Normal)
        } else {
            setDayTheme()
        }
        
    }
    
    func setDayTheme() {
        
        titleLabel.textColor = UIColor.blackColor()
        self.view.backgroundColor = UIColor.whiteColor()
        
        contentsButton.setBackgroundImage(UIImage(named: "contents-normal"), forState: .Normal)
        radarButton.setBackgroundImage(UIImage(named: "radar-normal"), forState: .Normal)
        storiesButton.setBackgroundImage(UIImage(named: "stories-normal"), forState: .Normal)
        settingsButton.setBackgroundImage(UIImage(named: "settings-nm"), forState: .Normal)
    
    }
    
    // Proximity sensor
    
    func proximityStateMonitor(notification: NSNotificationCenter){
        if UIDevice.currentDevice().proximityState {
            print("Device close to user")
            performSegueWithIdentifier("audioSegue", sender: nil)
        } else {
            print("Device NOT close to user")
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
    
    @IBAction func lockPressed(sender: AnyObject) {
        if(self.auth){
            auth = false
            authenticationContext.invalidate()
            authenticationContext = LAContext()
        }
        else{
            promptAuthentication()
        }
    }
    
    
    // MARK: Navigation bar setup
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        // Brightness
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey(KeysConstants.nightModeKey){
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(brightnessStateMonitor), name: "UIScreenBrightnessDidChangeNotification", object: nil)
            checkBrightness()
        } else {
            
            setDayTheme()
        }
        
        
        // Proximity sensor
        
        if NSUserDefaults.standardUserDefaults().boolForKey(KeysConstants.stealthKey) {NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(proximityStateMonitor), name: "UIDeviceProximityStateDidChangeNotification", object: nil)}
        
        // Gyroscope
        
        if NSUserDefaults.standardUserDefaults().boolForKey(KeysConstants.lowPowerKey) {setUpMotion()}
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
        if NSUserDefaults.standardUserDefaults().boolForKey(KeysConstants.lowPowerKey) {finishMotion()}
        
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
            inputController.delegate = self
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

