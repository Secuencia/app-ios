//
//  AudioTableViewCell.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/17/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class AudioTableViewCell: UITableViewCell {

    @IBOutlet weak var recordingTime: UILabel!
    @IBOutlet weak var bookmarksText: UITextView!
    @IBOutlet weak var captureControlButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var beingEdited = true{
        didSet{
            bookmarksText.editable = beingEdited
        }
    }
    
}
