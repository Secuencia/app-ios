//
//  PhotoTableViewCell.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/16/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var notesTextView: UITextView!
    
    var beingEdited = true
}
