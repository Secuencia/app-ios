//
//  RecordTableViewCell.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/16/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var recordingTime: UILabel!
    @IBOutlet weak var bookmarksText: UITextView!
    @IBOutlet weak var captureControlButton: UIButton!
    
    var beingEdited = true{
        didSet{
            bookmarksText.editable = beingEdited
        }
    }

}
