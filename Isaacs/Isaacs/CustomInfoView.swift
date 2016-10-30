//
//  CustomInfoView.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 10/29/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class CustomInfoView: UIView {

    @IBOutlet weak var title: UILabel!
   
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var stories: UILabel!
    
    
    func setUpContent(content: Content) {
    
        title.text = content.type!
        
        contentLabel.text = JsonConverter.jsonToDict(content.data!)!["text"]
        
        if let stories = content.stories {
            
            if stories.count != 0 {
                
                var storiesText = [String]()
                
                for story in stories {
                    storiesText.append(story.title!)
                }
                
                self.stories.text = storiesText.joinWithSeparator(", ")
                
            } else {
                
                self.stories.text = "No associated stories"
                
            }
            
            
        } else {
            self.stories.text = "No associated stories"
        }
    
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
