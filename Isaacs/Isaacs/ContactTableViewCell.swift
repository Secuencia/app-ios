//
//  ContactTableViewCell.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/16/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var additionalInfoText: UITextView!
    @IBOutlet weak var pictureButton: UIButton!
    
    var beingEdited = true{
        didSet{
            //nameTextField. = beingEdited
        }
    }

}
