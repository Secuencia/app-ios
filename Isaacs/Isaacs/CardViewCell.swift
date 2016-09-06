//
//  CardViewCell.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/5/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class CardViewCell: UICollectionViewCell {
    let HALF : Double = 0.5
    let COMPLETE : Double = 1.0
    var size_factor : (Double, Double)
    
    override init(frame: CGRect)
    {
        self.size_factor = (HALF, HALF)
        super.init(frame: frame)
    }
    
    init(frame: CGRect, width: Double, height: Double){
        self.size_factor = (width, height)
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
