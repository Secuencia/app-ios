//
//  ContactCardCollectionViewCell.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/4/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class ContactCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.borderColor = UIColor.magentaColor().CGColor
        containerView.layer.borderWidth = 2
    }
}
