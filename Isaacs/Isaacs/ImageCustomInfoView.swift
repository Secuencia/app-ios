//
//  ImageCustomInfoView.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 10/29/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class ImageCustomInfoView: UIView {
    
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var stories: UILabel!
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setUpContent(content: Content) {
        
        title.text = content.type!
        
        let jsonData = content.data!
        let imageName = JsonConverter.jsonToDict(jsonData)!["image_file_name"]!
        let image = Utils.getImage(imageName)
        
        self.image.image = image
        
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


}
