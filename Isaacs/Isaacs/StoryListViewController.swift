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
    let storyPersistence : StoryPersistence = StoryPersistence()
    let contentPersistence : ContentPersistence = ContentPersistence()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stories = self.storyPersistence.getAll();
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
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "story_detail"){
            let destination : StoryDetailViewController = segue.destinationViewController as! StoryDetailViewController
            let path = self.tableView.indexPathForSelectedRow!
            destination.story = self.stories[path.row]
        }
    }
    
    @IBAction func createStory(sender: AnyObject) {
        let alert = UIAlertController(title: "Nueva historia",
                                      message: "",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Crear", style: .Default, handler: {
                                        (action:UIAlertAction) -> Void in
            
            let newStory : Story = self.storyPersistence.createEntity()
            let newContent : Content = self.contentPersistence.createEntity()
            newContent.data = "string de json bien chimbita"
            newContent.type = Content.types.Text.rawValue
            let newContent2 : Content = self.contentPersistence.createEntity()
            newContent2.data = "string de json bien chimbita"
            newContent2.type = Content.types.Picture.rawValue
            let newContent3 : Content = self.contentPersistence.createEntity()
            newContent3.data = "string de json bien chimbita"
            newContent3.type = Content.types.Audio.rawValue
            let newContent4 : Content = self.contentPersistence.createEntity()
            newContent4.data = "string de json bien chimbita"
            newContent4.type = Content.types.Contact.rawValue
            newStory.title = alert.textFields!.first?.text!
            newStory.addContent(newContent)
            newStory.addContent(newContent2)
            newStory.addContent(newContent3)
            newStory.addContent(newContent4)
            self.storyPersistence.save()
            self.reloadData()
            }
        )
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .Default) { (action: UIAlertAction) -> Void in
                                            print("Cancelado")
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    
    func reloadData(){
        self.stories = self.storyPersistence.getAll()
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
