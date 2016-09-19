//
//  PhotoTableViewCell.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/17/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    
    var beingEdited = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Style
        containerView.layer.borderWidth = 2.0
        containerView.layer.borderColor = UIColor.cyanColor().CGColor
        containerView.layer.cornerRadius = 10.0
        backgroundColor = UIColor.clearColor()
        // Style
    }
    
}
