//
//  StorySelectViewController.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/17/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class StorySelectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let persistence : StoryPersistence = StoryPersistence()
    var stories : [Story] = []
    var recommended : [Story] = []
    var content : Content?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        stories = self.persistence.getAll("title", ascending: true)
        recommended = self.persistence.getAll("date_created", ascending: false)
        self.navigationItem.title = "Historias asociadas"
        

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let finalStories : [Story]
        if(indexPath.section == 0){
            finalStories = recommended
        }
        else{
            finalStories = stories
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("story_cell")
        let story : Story = finalStories[indexPath.row]
        cell!.textLabel!.text = story.title
        if((content?.stories?.containsObject(story))!){
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else{
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let finalStories : [Story]
        let selectedStory : Story
        let oppositeIndex : Int?
        let oppositeCell : UITableViewCell
        let oppositeIndexPath : NSIndexPath
        
        if(indexPath.section == 0){
            finalStories = recommended
        }
        else{
            finalStories = stories
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        selectedStory = finalStories[indexPath.row]
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark){
            cell!.accessoryType = UITableViewCellAccessoryType.None
            content?.mutableSetValueForKey("stories").removeObject(selectedStory)
        }
        else{
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            content?.mutableSetValueForKey("stories").addObject(selectedStory)
        }
        
        
        if(indexPath.section == 0){
            oppositeIndex = stories.indexOf(selectedStory)
            oppositeIndexPath = NSIndexPath(forRow:oppositeIndex!, inSection: 1)
        }
        else{
            oppositeIndex = recommended.indexOf(selectedStory)!
            oppositeIndexPath = NSIndexPath(forRow:oppositeIndex!, inSection: 0)
        }
        
        if(indexPath.section == 0 || (indexPath.section == 1 && oppositeIndex < 3)){
            oppositeCell = tableView.cellForRowAtIndexPath(oppositeIndexPath)!
            
            if (oppositeCell.accessoryType == UITableViewCellAccessoryType.Checkmark){
                oppositeCell.accessoryType = UITableViewCellAccessoryType.None
            }
            else{
                oppositeCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            
        }
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("header_cell") as! HeaderTableViewCell
        
        switch (section) {
        case 0:
            headerCell.title.text = "Recomendadas";
        default:
            headerCell.title.text = "Historias";
        }
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            switch recommended.count < 3{
            case true: return recommended.count;
            default: return 3
            }
        }
        else{
            return stories.count
        }
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}
