//
//  AddressListTableViewCell.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 31/01/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class AddressListTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imgRadio: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
