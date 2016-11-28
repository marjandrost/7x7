//
//  WatIsCell.swift
//  7x7
//
//  Created by Marjan Drost on 12-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit

class WatIsCell: UITableViewCell {

    
    @IBOutlet weak var lblHeaderText: UILabel!
    
    
    @IBOutlet weak var imgHeader: UIImageView!
    
    @IBOutlet weak var imgPicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
