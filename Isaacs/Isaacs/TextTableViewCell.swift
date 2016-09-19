//
//  TextTableViewCell.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/17/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var myText: UITextView!
    @IBOutlet weak var containerView: UIView!
    
    
    var beingEdited = true{
        didSet{
            myText.editable = beingEdited
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Style
        containerView.layer.borderWidth = 2.0
        containerView.layer.borderColor = UIColor.darkGrayColor().CGColor
        containerView.layer.cornerRadius = 10.0
        backgroundColor = UIColor.clearColor()
        // Style
    }

}
