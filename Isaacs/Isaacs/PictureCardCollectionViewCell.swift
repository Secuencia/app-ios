//
//  PictureCardCollectionViewCell.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/4/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class PictureCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.borderColor = UIColor.cyanColor().CGColor
        containerView.layer.borderWidth = 2
    }
}
