//
//  OrderHistoryNewViewController.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 04/02/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class OrderHistoryNewViewController: BaseViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var orderTableView: UITableView!
    
    //MARK:- VARIABLES
    var responseOrders = NSArray()
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "MY ORDERS"
        
        self.orderTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        self.orderTableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        self.getOrderList()
        
    }
    
    //MARK:- API CALL
    func getOrderList(){
    
        let apiService = ApiService.shared
        
        apiService.urlString = parentURL + orderHistoryAPI
        apiService.target = self
        
        let paramter = ["user_id":userId()]
     
        apiService.parameter = paramter as [String : Any]
        
        apiService.fetchData { (responseDict, error) in
            
            if error == nil, let responseDict = responseDict{
                
                if "\(responseDict.value(forKey: "code") ?? "")" == "200"{
                    print(responseDict)
                    
                    if let recentOrders = (responseDict.value(forKey: "value") as AnyObject).value(forKey: "recent") as? NSArray{
                        self.responseOrders = recentOrders
                    }else if let pastOrders = (responseDict.value(forKey: "value") as AnyObject).value(forKey: "past") as? NSArray{
                        self.responseOrders = pastOrders
                    }else{
                        AlertController.alert(withMessage: "Order History Empty", presenting: self)
                    }
                    
                    DispatchQueue.main.async {
                        self.orderTableView.reloadData()
                    }
                }else{
                    AlertController.alert(withMessage: "Order History Empty", presenting: self)
                }
                
                
            }
        }
    }
    
}

extension OrderHistoryNewViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.responseOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell") as! OrderTableViewCell
        if let orderData = self.responseOrders[indexPath.row] as? NSDictionary{
            cell.orderData = orderData
        }
        
        cell.btnContactUs.addTapGestureRecognizer {
            
            let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "marketDetailView") as! MarketDetailViewController
        nextVc.selectedProductId = "\((self.responseOrders[indexPath.row] as AnyObject).value(forKey: "item_id") ?? "")"
        //nextVc.isGift = "true"
        self.navigationController?.pushViewController(nextVc, animated: true)
        
        
    }
}
