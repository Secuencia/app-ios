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
    var content : Content?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        stories = self.persistence.getAll()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("story_cell")
        let story : Story = stories[indexPath.row]
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
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark){
            cell!.accessoryType = UITableViewCellAccessoryType.None
            content?.mutableSetValueForKey("stories").removeObject(stories[indexPath.row])
        }
        else{
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            content?.mutableSetValueForKey("stories").addObject(stories[indexPath.row])
        }
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count;
    }

    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
