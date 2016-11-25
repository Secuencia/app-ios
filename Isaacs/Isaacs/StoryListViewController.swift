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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
