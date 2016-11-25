//
//  NoiseLevelTableViewCell.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 11/25/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit
import AVFoundation

class NoiseLevelTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var colorIndicatorLevel: UILabel!
    
    @IBOutlet weak var noiseLevelLabel: UILabel!
    
    // Mic as noise sensor
    
    var recorder:AVAudioRecorder!
    
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                          AVFormatIDKey : NSNumber(int: Int32(kAudioFormatAppleIMA4)),
                          AVNumberOfChannelsKey : NSNumber(int: 1),
                          AVLinearPCMBitDepthKey: NSNumber(int: 16),
                          AVLinearPCMIsBigEndianKey: false,
                          AVLinearPCMIsFloatKey: false]
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func updateNoiseLevel(sender: UIButton) {
        
        setNoiseValue()
        
    }
    
    
    func setNoiseValue() {
        
        do{
            try recorder = AVAudioRecorder(URL: NSURL(string: NSTemporaryDirectory().stringByAppendingString("tmp.caf"))!, settings: recordSettings)
        }catch{
            
        }
        recorder.meteringEnabled = true
        
        recorder.record()
        recorder.updateMeters()
        let decibelsAvg = recorder.averagePowerForChannel(0)
        let decibelsPeak = recorder.peakPowerForChannel(0)
        print(decibelsAvg)
        print(decibelsPeak)
        
        let decibels = decibelsAvg
        
        var labelValue = "No noise info"
        
        if decibels < 0 {
            labelValue = "REALLY LOUD"
            colorIndicatorLevel.backgroundColor = UIColor.redColor()
        }
        
        if decibels < -15 {
            labelValue = "KINDA LOUD"
            colorIndicatorLevel.backgroundColor = UIColor.redColor()
        }
        
        if decibels < -30 {
            labelValue = "LOUD"
            colorIndicatorLevel.backgroundColor = UIColor.orangeColor()
        }
        
        if decibels < -50 {
            labelValue = "NORMAL"
            colorIndicatorLevel.backgroundColor = UIColor.yellowColor()
        }
        
        if decibels < -70 {
            labelValue = "KINDA QUIET"
            colorIndicatorLevel.backgroundColor = UIColor.greenColor()
        }
        
        if decibels < -100 {
            labelValue = "QUIET"
            colorIndicatorLevel.backgroundColor = UIColor.greenColor()
        }
        
        noiseLevelLabel.text = labelValue
        
    
    }
    
}
