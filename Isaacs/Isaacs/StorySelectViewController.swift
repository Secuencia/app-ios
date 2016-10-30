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
}
