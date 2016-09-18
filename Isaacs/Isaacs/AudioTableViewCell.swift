//
//  AudioTableViewCell.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/17/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit
import AVFoundation

class AudioTableViewCell: UITableViewCell{

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var file_name : String?
    
    let audioManager : AudioManager = AudioManager.sharedInstance
    
    @IBAction func record(sender: AnyObject) {
        if sender.titleLabel!!.text == "Record" {
            self.btnRecord.setTitle("Stop", forState: UIControlState.Normal)
            self.btnPlay.enabled = false
            audioManager.record(file_name!)
        }
        else{
            self.btnRecord.setTitle("Record", forState: UIControlState.Normal)
            self.btnPlay.enabled = true
            audioManager.stop()
        }
    }
    
    @IBAction func play(sender: AnyObject) {
        audioManager.play(file_name!)
    }
}
