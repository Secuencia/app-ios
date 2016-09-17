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
    @IBOutlet weak var stories: UITextField!
    
    var beingEdited = true
    
}
