//
//  PlacesTableViewCell.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 10/30/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ranking: UILabel!
    
    @IBOutlet weak var placeName: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var cityCountry: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
