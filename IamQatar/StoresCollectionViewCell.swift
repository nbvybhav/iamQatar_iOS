//
//  StoresCollectionViewCell.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 29/04/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class StoresCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var lblStoreName: UILabel!
    
    var storeData : NSDictionary?{
        
        didSet{
            self.setContent()
        }
        
    }
    
    func setContent(){
        
        self.lblStoreName.text = "\(self.storeData?.value(forKey: "name") ?? "")"
        let imgUrl = "\(self.storeData?.value(forKey: "app_icon") ?? "")"
        self.imgStore.setImage(withUrlString: imgUrl)
        
    }
    
}
