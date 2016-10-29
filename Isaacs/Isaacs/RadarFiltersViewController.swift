//
//  RadarFiltersViewController.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 10/29/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class RadarFiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK - Properties
    
    
    @IBOutlet weak var filtersTable: UITableView!
    
    var filters : [String:[String]] = [:]
    
    let storyPersistence = StoryPersistence()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Filters"
        
        filtersTable.delegate = self
        filtersTable.dataSource = self
        
        filters["general"] = ["all_contents"]
        
        if let stories = getNamesArray(storyPersistence.getAll("title", ascending: true)) {
            filters["stories"] = stories
        }
        
        filters["services"] = ["twitter"]
        

        // Do any additional setup after loading the view.
    }
    
    
    func getNamesArray(stories: [Story]) -> [String]? {
        
        var storiesString : [String]?
        
        for story in stories {
            
            storiesString!.append(story.title ?? "No title")
            
        }
        
        return storiesString
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = filters.startIndex.advancedBy(section)
        let filter = filters[index]
        return filter.1.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filters.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let index = filters.startIndex.advancedBy(section)
        let title = filters[index].0
        return title
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = filtersTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        
        let index = filters.startIndex.advancedBy(indexPath.section)
        
        let item = filters[index].1[indexPath.row]
        
        cell.textLabel!.text = item
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
