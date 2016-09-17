//
//  AudioTableViewCell.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/17/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit
import AVFoundation

class AudioTableViewCell: UITableViewCell, AVAudioRecorderDelegate , AVAudioPlayerDelegate{

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var btnRecord: UIButton!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    let isRecorderAudioFile = false
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                          AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(int: 1),
                          AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
    

    func directoryURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4a")
        print(soundURL)
        return soundURL
    }
    
    @IBAction func record(sender: AnyObject) {
        if sender.titleLabel!!.text == "Record" {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!,
                                                    settings: recordSettings)
                audioRecorder.prepareToRecord()
            } catch {
            }
            do {
                self.btnRecord.setTitle("Stop", forState: UIControlState.Normal)
                self.btnPlay.enabled = false
                try audioSession.setActive(true)
                audioRecorder.record()
            } catch {
            }
        }else{
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                self.btnRecord.setTitle("Record", forState: UIControlState.Normal)
                self.btnPlay.enabled = true
                try audioSession.setActive(false)
            } catch {
            }
        }
    }
    @IBAction func play(sender: AnyObject) {
        if !audioRecorder.recording {
            self.audioPlayer = try! AVAudioPlayer(contentsOfURL: audioRecorder.url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
        }
    }
    
    //MARK:- AudioRecordDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print(flag)
    }
    
    
    //MARK:- AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print(flag)
    }
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?){
        print(error.debugDescription)
    }
    internal func audioPlayerBeginInterruption(player: AVAudioPlayer){
        print(player.debugDescription)
    }
}
