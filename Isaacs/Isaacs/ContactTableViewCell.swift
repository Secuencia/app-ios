//
//  ContactTableViewCell.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/17/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var additionalInfoText: UITextView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var beingEdited = true{
        didSet{
            //nameTextField. = beingEdited
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Style
        containerView.layer.borderWidth = 2.0
        containerView.layer.borderColor = UIColor.magentaColor().CGColor
        containerView.layer.cornerRadius = 10.0
        backgroundColor = UIColor.clearColor()
        additionalInfoText.layer.borderColor = UIColor.lightGrayColor().CGColor
        // Style
        
    }
}
