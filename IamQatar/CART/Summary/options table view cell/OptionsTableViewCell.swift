//
//  OptionsTableViewCell.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 25/01/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgRadio: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
