//
//  SummaryViewController.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 25/01/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class SummaryViewController: BaseViewController, SendDataBackDelegate {

    //MARK:- OUTLETS
    @IBOutlet weak var timeSlotContView: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var shippingTableView: UITableView!
    @IBOutlet weak var timeSlotTableView: UITableView!
    @IBOutlet weak var priceContView: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var btnChangeAddress: UIButton!
    @IBOutlet weak var shippingOptionsViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var deliveryTimeViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var addressViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainCotentViewHeigthConstraint: NSLayoutConstraint!
    
    //MARK:- VARIABLES
    var responseDict = NSDictionary()
    var responseShippingOptions = NSArray()
    var responseDeliveryTime = NSArray()
    var selectedAddressId = ""
    
    var selectedShippingId = ""
    var selectedTimeId = ""
    var selectedShippingCharge = ""
    var firstLoad = true
    
        
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if firstLoad == true {
            firstLoad = false
            self.setContentView()
        }else {
            self.getCart()
        }
    }
    
    //MARK:- API CALL
    func getCart(){

        let apiService = ApiService.shared

        apiService.urlString = parentURL + getCartItems
        apiService.target = self

        let paramter = ["user_id":userId()]

        apiService.parameter = paramter as [String : Any]

        apiService.fetchData { (responseDict, error) in

            if error == nil, let responseDict = responseDict{

                print(responseDict)
                self.responseDict = responseDict

                DispatchQueue.main.async {
                    self.setContentView()
                }
            }
        }
    }
    
    
    //MARK:- METHODS
    func setUi(){
    
        self.navigationItem.title = "SHOPPING CART"
        
        self.shippingTableView.register(UINib(nibName: "OptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "OptionsTableViewCell")
        self.timeSlotTableView.register(UINib(nibName: "OptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "OptionsTableViewCell")
                
        self.priceContView.layer.shadowColor = UIColor.lightGray.cgColor
        self.priceContView.layer.shadowRadius = 8
        self.priceContView.layer.shadowOpacity = 0.6
        
        self.shippingTableView.delegate = self
        self.shippingTableView.dataSource = self
        self.timeSlotTableView.delegate = self
        self.timeSlotTableView.dataSource = self
        
        self.view.layoutIfNeeded()
        self.btnContinue.addGradient(colorOne: nil, colorTwo: nil)
        
        self.lblAddress.text = ""
        
    }
    
    func setContentView(){
      
        if let deliveryAddressArray = (self.responseDict.value(forKey: "address") as AnyObject).value(forKey: "delivery_address") as? NSArray{
            if deliveryAddressArray.firstObject != nil, let addressData = deliveryAddressArray.firstObject as? NSDictionary{
                self.setAddress(addressDict: addressData)
            }else{
                self.setAddress(addressDict: [:])
            }
        }
        
        self.responseShippingOptions = (self.responseDict.value(forKey: "carriers") ?? []) as! NSArray
        self.responseDeliveryTime = (self.responseDict.value(forKey: "timeslote") ?? []) as! NSArray
        self.shippingTableView.reloadData()
        self.timeSlotTableView.reloadData()
        
        self.lblTotalPrice.text = price("\((self.responseDict.value(forKey: "cart_total") as AnyObject).value(forKey: "grandtotal") ?? "")")
        
        self.setContentViewHeight()
        
    }
    
    func setAddress(addressDict:NSDictionary){
        
        if addressDict.count == 0{
            
            self.lblAddress.text = "No Address Added"
            self.btnChangeAddress.setTitle("ADD", for: .normal)
            self.selectedAddressId = ""
            
        }else{
            
            self.selectedAddressId = "\(addressDict.value(forKey: "id") ?? "")"
            self.btnChangeAddress.setTitle("CHANGE", for: .normal)
            self.lblAddress.text = formatAddress(addressData: addressDict)
            
        }
        
        self.lblAddress.sizeToFit()
        self.setContentViewHeight()
    }
    
    func setContentViewHeight(){
        
        self.addressViewHeightConstraint.constant = self.lblAddress.frame.height + 70
        self.shippingOptionsViewHeightConstraints.constant = self.shippingTableView.contentSize.height + self.shippingTableView.contentInset.bottom + self.shippingTableView.contentInset.top + 44
        self.deliveryTimeViewHeightConstraints.constant = self.timeSlotTableView.contentSize.height + self.timeSlotTableView.contentInset.bottom + self.timeSlotTableView.contentInset.top + 44
        
        self.view.layoutIfNeeded()
        self.mainCotentViewHeigthConstraint.constant = self.timeSlotContView.frame.origin.y + self.deliveryTimeViewHeightConstraints.constant + 12
        
        self.view.layoutIfNeeded()
        
    }
    
    //selected address dict from address list view controller
    func recievedData(_ dict: NSDictionary) {
        
        self.setAddress(addressDict: dict)
        
    }

    //MARK:- BTN ACTION
    @IBAction func changeAddressAction(_ sender: UIButton) {
        
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "AddressListViewController") as! AddressListViewController
        nextVc.sendDataBackDelegate = self
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        
        if self.selectedAddressId == ""{
            AlertController.alert(withMessage: "Select address", presenting: self)
        }else if self.selectedShippingId == ""{
            AlertController.alert(withMessage: "Select shipping option", presenting: self)
        }
//        else if self.selectedTimeId == ""{
//            AlertController.alert(withMessage: "Select preferred delivery time", presenting: self)
//        }
        else{
            
            //goto payment
            let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewControllerNew") as! PaymentViewControllerNew
            nextVc.responseDict = self.responseDict
            nextVc.selectedShippingCharge = self.selectedShippingCharge
            nextVc.selectedShippingId = self.selectedShippingId
            nextVc.timeId = self.selectedTimeId
            nextVc.addressId = self.selectedAddressId
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }
        
    }
    
}

extension SummaryViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.shippingTableView{
            return self.responseShippingOptions.count
        }
        
        return self.responseDeliveryTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsTableViewCell") as! OptionsTableViewCell
        
        if tableView == self.shippingTableView{//shipping options
            
            if let carrierData = self.responseShippingOptions[indexPath.row] as? NSDictionary{
                
                var deliveyPeriodString = "\(carrierData.value(forKey: "delivery_period_str") ?? "")"
                deliveyPeriodString = deliveyPeriodString == "" ? "" : "( \(deliveyPeriodString) )"
                
                cell.lblItemName.text = "\(carrierData.value(forKey: "carrier_name") ?? "") \(deliveyPeriodString)"
                cell.lblItemName.numberOfLines = 0
                
                let deliveryCharge = "\(carrierData.value(forKey: "delivery_charge") ?? "")"
                cell.lblPrice.text = deliveryCharge == "0" ? "Free" : price(deliveryCharge)
                
                let shippId = "\(carrierData.value(forKey: "ship_id") ?? "")"
                if self.selectedShippingId == shippId{
                    cell.imgRadio.image = #imageLiteral(resourceName: "radio_btn_selected")
                }else{
                    cell.imgRadio.image = #imageLiteral(resourceName: "radio_btn")
                }
                cell.lblPrice.isHidden = false
                
            }

        }else{//time slots
            
            if let timeSlotData = self.responseDeliveryTime[indexPath.row] as? NSDictionary{
                
                var deliveyPeriodString = "\(timeSlotData.value(forKey: "delivery_period_str") ?? "")"
                deliveyPeriodString = deliveyPeriodString == "" ? "" : "( \(deliveyPeriodString) )"
                
                cell.lblItemName.text = "\(timeSlotData.value(forKey: "start_time") ?? "")"
                
                let timeID = "\(timeSlotData.value(forKey: "time_id") ?? "")"
                if self.selectedTimeId == timeID{
                    cell.imgRadio.image = #imageLiteral(resourceName: "radio_btn_selected")
                }else{
                    cell.imgRadio.image = #imageLiteral(resourceName: "radio_btn")
                }
                
                cell.lblPrice.isHidden = true
            }
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.shippingTableView{
            self.selectedShippingId = "\((self.responseShippingOptions[indexPath.row] as AnyObject).value(forKey: "ship_id") ?? "")"
            
            let shippingCharge = "\((self.responseShippingOptions[indexPath.row] as AnyObject).value(forKey: "delivery_charge") ?? "0")"
            let currentAmount = "\((self.responseDict.value(forKey: "cart_total") as AnyObject).value(forKey: "grandtotal") ?? "0")"
            let total = (Double(currentAmount) ?? 0.0) + (Double(shippingCharge) ?? 0.0)
            self.lblTotalPrice.text = price("\(total)")
            
            self.selectedShippingCharge = shippingCharge
            
        }else{
            self.selectedTimeId = "\((self.responseDeliveryTime[indexPath.row] as AnyObject).value(forKey: "time_id") ?? "")"
        }
        
        tableView.reloadData()
        
    }
    
}


func formatAddress(addressData:NSDictionary)->String{
    
    var name = "\(addressData.value(forKey: "full_name") ?? "")" + "\(addressData.value(forKey: "last_name") ?? "")"
    var houseNo = "\(addressData.value(forKey: "house_no") ?? "")"
    var town = "\(addressData.value(forKey: "town") ?? "")"
    var buildingName = "\(addressData.value(forKey: "building_name") ?? "")"
    var street = "\(addressData.value(forKey: "street") ?? "")"
    var pinCode = "\(addressData.value(forKey: "pin_code") ?? "")"
    var phone = "\(addressData.value(forKey: "mobile_number") ?? "")"
    let moreInfo = "\(addressData.value(forKey: "landmark") ?? "")"
    
    let addressType = "\(addressData.value(forKey: "address_type") ?? "")".capitalizingFirstLetter()
    
    name = name == "" ? "" : "\(name) (\(addressType))\n"
    houseNo = houseNo == "" ? "" : "\(houseNo),"
    buildingName = buildingName == "" ? "" : "\(buildingName),"
    town = town == "" ? "" : "\(town)\n"
    street = street == "" ? "" : "\(street)\n"
    pinCode = pinCode == "" ? "" : "\(pinCode)\n"
    phone = phone == "" ? "" : "\(phone)\n"
    
    
    let addressString = name + houseNo + buildingName + town + street + pinCode + phone + moreInfo
    //"\(name)\n\(houseNo), \(buildingName)\n\(street)\n\(pinCode)\(phone)"
    
    return addressString
    
    
}



extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


//extension SummaryViewController: UITabBarControllerDelegate {
//
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
//        if viewController == self.tabBarController?.viewControllers?[3]{
//            self.navigationController?.popViewController(animated: true)
//            return false
//        }
//        return true
//
//    }
//
//}

