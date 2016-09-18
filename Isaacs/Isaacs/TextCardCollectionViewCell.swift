//
//  TextCardCollectionViewCell.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/4/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class TextCardCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.borderColor = UIColor.darkGrayColor().CGColor
        containerView.layer.borderWidth = 2
    }
    
}
