//
//  TextTableViewCell.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/16/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var myText: UITextView!
    
    
    var beingEdited = true{
        didSet{
            myText.editable = beingEdited
        }
    }

}
