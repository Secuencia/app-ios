//
//  StoryListViewController.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/4/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit
import CoreData

class StoryListViewController: UITableViewController {

    var stories : [Story] = []
    let persistence : StoryPersistence = StoryPersistence()
    let contentPersistence : ContentPersistence = ContentPersistence()
    weak var actionToEnable : UIAlertAction?
    var parent: StoriesSplitViewController? = nil
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stories = self.persistence.getAll("title", ascending: true);
        
        
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
            tableView.backgroundColor = UIColor.grayColor()
            
            tableView.separatorColor = UIColor.darkGrayColor()
            
            navigationController?.navigationBar.barStyle = UIBarStyle.Black
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        } else {
            
            setDayTheme()
            
        }
        
    }
    
    func setDayTheme() {
        
        tableView.backgroundColor = UIColor.whiteColor()
            
        tableView.separatorColor = UIColor.lightGrayColor()
            
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    override func tableView(tableView: UITableView,
                   cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let story : Story = stories[indexPath.row]
        
        cell!.textLabel!.text = story.title
        //cell!.detailTextLabel!.text = (story.date_created as! String) ?? "07/09/16"
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            persistence.deleteEntity(stories[indexPath.row])
            persistence.save()
            self.stories = self.persistence.getAll("title", ascending: true)
            tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "story_detail"){
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let navController = (segue.destinationViewController as! UINavigationController)
                let controller = navController.topViewController as! StoryDetailViewController
                controller.story = self.stories[indexPath.row]
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        else if(segue.identifier == "isaacs_dashboard"){
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    @IBAction func createStory(sender: AnyObject) {
        let alert = UIAlertController(title: "Nueva historia",
                                      message: "",
                                      preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Título"
            textField.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
        })
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Descripción"
        })
        
        
        let saveAction = UIAlertAction(title: "Crear", style: .Default, handler: {
                                        (action:UIAlertAction) -> Void in
            
            let newStory : Story = self.persistence.createEntity()
            newStory.title = alert.textFields!.first?.text!
            newStory.brief = alert.textFields![1].text!
            newStory.date_created = NSDate()
            self.persistence.save()
            self.reloadData()
            }
        )
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .Default) { (action: UIAlertAction) -> Void in
                                            print("Cancelado")
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.actionToEnable = saveAction
        saveAction.enabled = false
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    
    
    @IBAction func dismiss(sender: AnyObject) {
        self.parent?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textChanged(sender:UITextField) {
        self.actionToEnable?.enabled = (sender.text!.characters.count > 0)
    }
    
    func reloadData(){
        self.stories = self.persistence.getAll("title", ascending: true)
        self.tableView.reloadData()
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
        
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
