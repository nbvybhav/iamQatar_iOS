//
//  GiftListCollectionViewCell.swift
//  IamQatar
//
//  Created by anuroop kanayil on 26/08/19.
//  Copyright © 2019 alisons. All rights reserved.
//

import UIKit

class GiftListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var salesTagView: UIView!
    @IBOutlet weak var lblSalesTag: UILabel!
    @IBOutlet weak var lblSoldOut: UILabel!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var lblGiftName: UILabel!
    @IBOutlet weak var imgGift: UIImageView!
    
    
    var salesTagText : String?{
        
        didSet{
            
        }
        
    }
    
    func setSalesTagText(){
        
        if self.salesTagText != nil && self.salesTagText != ""{
            self.salesTagView.isHidden = false
            self.lblSalesTag.text = self.salesTagText
        }else{
            self.salesTagView.isHidden = true
        }
        
    }

}
