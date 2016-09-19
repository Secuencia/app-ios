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
    
    var recording: Bool = false
    
    let audioManager : AudioManager = AudioManager.sharedInstance
    
    
    @IBAction func recordWithSender(sender: UIButton) {
        if !recording {
            print("Entro tag 0")
            self.btnRecord.setImage(UIImage(named: "StopRecording"), forState: UIControlState.Normal)
            self.btnPlay.enabled = false
            recording = true
            audioManager.record(file_name!)
        }
        else{
            print("Entro tag 1")
            self.btnRecord.setImage(UIImage(named: "Record"), forState: UIControlState.Normal)
            self.btnPlay.enabled = true
            audioManager.stop()
            recording = false
            
        }
    }
    
    @IBAction func playWithSender(sender: UIButton) {
        audioManager.play(file_name!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Style
        containerView.layer.borderWidth = 2.0
        containerView.layer.borderColor = UIColor.orangeColor().CGColor
        containerView.layer.cornerRadius = 10.0
        backgroundColor = UIColor.clearColor()
        // Style
    }

}
