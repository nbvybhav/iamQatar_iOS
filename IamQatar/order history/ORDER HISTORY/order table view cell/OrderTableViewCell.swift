//
//  OrderTableViewCell.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 04/02/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblExpctedDate: UILabel!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var btnContactUs: UIButton!
    
    
    var orderData : NSDictionary? {
        didSet{
            self.setContentView()
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func setContentView(){
        
        self.lblProductName.text = "\(self.orderData?.value(forKey: "product_name") ?? "")"
        self.lblOrderId.text = "Order ID #\(self.orderData?.value(forKey: "order_number") ?? "")"
        self.lblOrderStatus.text = "\(self.orderData?.value(forKey: "orderstatus") ?? "")"
        
        
        btnPrice.setTitle(price("\(self.orderData?.value(forKey: "price") ?? "")"),for: .normal)
        
        self.layoutIfNeeded()
        self.btnContactUs.addGradient(colorOne: nil, colorTwo: nil)
        
        let delDate = "\(self.orderData?.value(forKey: "delivery_date") ?? "")"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: delDate) else { return }
        dateFormatter.dateFormat = "dd MMMM yyyy"//"yyyy-MM-dd"//2019-09-25
        let dateString = dateFormatter.string(from: date)
        
        self.lblExpctedDate.text = "Delivery Expected " + dateString
        
        self.imgProduct.setImage(withUrlString:"\(self.orderData?.value(forKey: "product_image") ?? "")")
        
    }
    
}
