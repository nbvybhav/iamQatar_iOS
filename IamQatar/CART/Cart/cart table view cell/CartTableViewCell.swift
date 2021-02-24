//
//  CartTableViewCell.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 23/01/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    @IBOutlet weak var imgCart: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var lblSeller: UILabel!
    
    //MARK:- VARIABLES
    var cartData: NSDictionary?{
        didSet{
            
            self.setContentView()
        }
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    func setContentView(){
        
        self.selectionStyle = .none
        
        let productDetails = self.cartData?.value(forKey: "product_details") as? NSDictionary
        
        self.lblProductName.text = "\(productDetails?.value(forKey: "product_name") ?? "")".uppercased()
        self.lblCount.text = "\(self.cartData?.value(forKey: "quantity") ?? "")"
        self.lblPrice.text = price("\(productDetails?.value(forKey: "newprice") ?? productDetails?.value(forKey: "price") ?? "")")
        
        if let sellerName = productDetails?.value(forKey: "store_name") as? String{
            self.lblSeller.text = "Store : \(sellerName)"
        }
        
        let imageUrlStirng = "\(self.cartData?.value(forKey: "default") ?? "")"
        
        self.imgCart.image = UIImage()
        self.imgCart.setImage(withUrlString: imageUrlStirng)
        
    }
    
    
    //MARK:- BTN ACTIONS
    @IBAction func minusAction(_ sender: UIButton) {
        
//        if self.lblCount.text != "1"{
//            self.lblCount.text = "\(Int(self.lblCount.text!)! - 1)"
//        }else{
//            //self.lblCount.text = "0"
//            //self.editCart()
//        }
//
//        //self.editCart()
        
    }
    
    @IBAction func plusAction(_ sender: UIButton) {
        
//        self.lblCount.text = "\(Int(self.lblCount.text!)! + 1)"
//        //self.editCart()
        
    }
    
    
    @IBAction func removeAction(_ sender: UIButton) {
        
        self.lblCount.text = "0"
        //self.editCart()
        
    }
    
    
}
