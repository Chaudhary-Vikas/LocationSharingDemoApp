//
//  LocationTableViewCell.swift
//  LocationSharingDemoApp
//
//  Created by Vikas Chaudhary on 31/07/17.
//  Copyright © 2017 CHDSEZ301972DADM. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet var locationNameLabel : UILabel!
    @IBOutlet var locationAddressLabel : UILabel!
    @IBOutlet var locationWhether : UILabel!
    @IBOutlet var thumbnailImageView :UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
