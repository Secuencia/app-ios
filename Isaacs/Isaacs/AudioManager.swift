//
//  AudioManager.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/17/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import Foundation
import AVFoundation

public class AudioManager: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    class var sharedInstance: AudioManager {
        struct Singleton {
            static let instance = AudioManager()
        }
        return Singleton.instance
    }
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    let isRecorderAudioFile = false
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                          AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(int: 2),
                          AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Max.rawValue))]
    
    
    func directoryURL(title : String) -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent(title + ".m4a")
        return soundURL
    }
    
    func record(title : String) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
            try audioRecorder = AVAudioRecorder(URL: self.directoryURL(title)!,settings: recordSettings)
            audioRecorder.prepareToRecord()
            try audioSession.setActive(true)
            audioRecorder.record()
        }
        catch {
            
        }
    }
    
    func stop(){
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            audioRecorder = nil
        }
        catch {
            
        }
    }
    
    func play(title : String) {
        do{
            try audioRecorder = AVAudioRecorder(URL: self.directoryURL(title)!,settings: recordSettings)
            self.audioPlayer = try! AVAudioPlayer(contentsOfURL: audioRecorder.url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
        }
        catch{
        
        }
    }
}
