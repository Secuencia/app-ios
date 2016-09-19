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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.bringSubviewToFront(delete)
        containerView.layer.borderColor = UIColor.magentaColor().CGColor
        containerView.layer.borderWidth = 2
    }
}
