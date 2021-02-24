//
//  FeedCollectionViewCell.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 05/02/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgFeed: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var feedData : NSDictionary?{
        
        didSet{
            
            self.setContent()
        }
        
    }
    
  
    func setContent(){
        
        self.lblTitle.text = "\(feedData?.value(forKey: "title") ?? "")"
        self.imgFeed.setImage(withUrlString: "\(feedData?.value(forKey: "image") ?? "")")
        
        
    }

}
