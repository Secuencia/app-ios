//
//  ForecastTableViewCell.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 10/30/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var temperature: UILabel!
    
    @IBOutlet weak var summary: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
