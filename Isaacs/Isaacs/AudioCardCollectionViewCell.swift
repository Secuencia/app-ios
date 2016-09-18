//
//  AudioCardCollectionViewCell.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/4/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class AudioCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var file_name : String?
    
    let audioManager : AudioManager = AudioManager.sharedInstance
    
    @IBAction func playWithSender(sender: UIButton) {
        audioManager.play(file_name!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.borderColor = UIColor.orangeColor().CGColor
        containerView.layer.borderWidth = 2
        delete.tintColor = UIColor.darkGrayColor()
    }
    
}
