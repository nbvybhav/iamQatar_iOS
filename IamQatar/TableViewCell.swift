//
//  TableViewCell.swift
//  IamQatar
//
//  Created by User on 20/01/21.
//  Copyright © 2021 alisons. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblOptions: UILabel!
    @IBOutlet weak var lblDataLeading: NSLayoutConstraint!
    @IBOutlet weak var imgSortWidth: NSLayoutConstraint!
    @IBOutlet weak var imgSort: UIImageView!
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var imgfilterOrSortBy: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
