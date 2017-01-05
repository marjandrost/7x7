//
//  GameCell.swift
//  7x7
//
//  Created by Marjan Drost on 13-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {
    
    
    @IBOutlet weak var lblDatum: UILabel!
    
    @IBOutlet weak var lblTijd: UILabel!
    
    
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var lblWedstrijd: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
