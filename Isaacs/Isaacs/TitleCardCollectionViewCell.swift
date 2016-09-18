//
//  TitleCardCollectionViewCell.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/17/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class TitleCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storyTitle: UILabel!
    @IBOutlet weak var storyBrief: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.backgroundColor = UIColor(netHex: 0xdddddd)
    }

}
