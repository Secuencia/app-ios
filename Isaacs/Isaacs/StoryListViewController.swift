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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stories = StoryPersistence().getAll();
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
    
    @IBAction func createStory(sender: AnyObject) {
        let alert = UIAlertController(title: "Nueva historia",
                                      message: "",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Crear", style: .Default, handler: {
                                        (action:UIAlertAction) -> Void in
            self.saveName((alert.textFields!.first?.text)!)
                                            
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
    
    func saveName(name: String) {
        StoryPersistence().save(name)
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
