//
//  StoriesSplitViewController.swift
//  Isaacs
//
//  Created by Sebastian Florez on 11/24/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class StoriesSplitViewController: UISplitViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailNavigationController = self.viewControllers[self.viewControllers.count-1] as! UINavigationController
        
        detailNavigationController.topViewController!.navigationItem.leftBarButtonItem = self.displayModeButtonItem()
        
        let masterNavigationController = self.viewControllers[0] as! UINavigationController
        (masterNavigationController.topViewController as! StoryListViewController).parent = self
        
        preferredDisplayMode = .AllVisible
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
