//
//  PaymentViewControllerNew.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 03/02/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit
import QpayPayment

class PaymentViewControllerNew: BaseViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    @IBOutlet weak var paymentTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtCouponCode: CustomTextFiled!
    @IBOutlet weak var couponCodeContStackView: UIStackView!
    @IBOutlet weak var lblCoupon: UILabel!
    @IBOutlet weak var lblCouponLeft: UILabel!
    @IBOutlet weak var btnApplyCoupon: UIButton!
    
    //MARK:- VARIABLES
    var selectedPaymentModeIndex = 0
    var responseDict = NSDictionary()
    var paymentOptionsArray = [String]()
    var selectedShippingCharge = ""
    var selectedShippingId = ""
    var addressId = ""
    var timeId = ""
    
    let COD = "COD"
    let ONLINE = "Payfort"
    
    var qpRequestParams : QPRequestParameters!
    
    //var selectedPaymentModeIndex = 0
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUi()
        self.setContentView()
        

        
    }

    //MARK:- API CALL
    func placeOrder(){
        
        guard self.addressId != "" else{
            AlertController.alert(withMessage: "No Address Selected", presenting: self)
            
            return
        }
        
        let apiService = ApiService.shared
        
        apiService.urlString = parentURL + placeOrderAPI
        apiService.target = self
        
        let paymentMode = self.selectedPaymentModeIndex == 0 ? COD : ONLINE
        
        //user_id, shipping_id, billing_id, comment, coupon_code, payment_type, delivery_address_id,time_id
        let paramter = ["user_id":userId(),
                        "shipping_id":self.selectedShippingId,
                        "billing_id":self.addressId,
                        "comment":"",
                        "coupon_code":self.txtCouponCode.text ?? "",
                        "payment_type":paymentMode,
                        "delivery_address_id":self.addressId,
                        "time_id":self.timeId]
     
        print(paramter)
        
        apiService.parameter = paramter as [String : Any]
        
        apiService.fetchData { (responseDict, error) in
            
            if error == nil, let responseDict = responseDict{
                
                print(responseDict)
                
                DispatchQueue.main.async {
                    //self.setContentView()
                    
                    if "\(responseDict.value(forKey: "code") ?? "")" == "200"{
                        
                        
                        if paymentMode == self.ONLINE{
                            
                            //goto qpay
                            let orderID = "\(responseDict.value(forKey: "value") ?? "")"

                            let price = "\(((responseDict.value(forKey: "price_summary") as AnyObject).value(forKey: "grandtotal") ?? ""))"

                            if let priceD = Double(price){
                                self.gotoQpay(orderID: orderID,price: priceD)
                            }
                            
                            
//                            let response = [
//                                "amount"             : "0.1",
//                                "cardType"           : "CREDIT",
//                                "datetime"           : "Fri May 22 06:48:15 AST 2020",
//                                "maskedCardNumber"   : "XXXX-XXXX-XXXX-8595",
//                                "orderId"            : "886",
//                                "reason"             : "",
//                                "status"             : "success",
//                                "transactionId"      : "3000111299249288",
//                                "transactionStatus"  : "accepted"
//                                ] as NSDictionary
//
//                            self.qpResponse(response)
                            
                            
                        }else{
                            self.tabBarController?.tabBar.items?.last?.badgeValue = nil
                            let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                            self.navigationController?.pushViewController(nextVc, animated: true)
                        }
                        
                    }else{
                        
                        AlertController.alert(withMessage: "Failed", presenting: self)
                        
                    }
                }
            }
        }
    }
    
    func applyCouponCode(){
    
        let apiService = ApiService.shared
        
        apiService.urlString = parentURL + applyCoupon
        apiService.target = self
        
        //coupon_code, user_id
        let paramter = ["user_id":userId(),
                        "coupon_code":self.txtCouponCode.text!,]
     
        apiService.parameter = paramter as [String : Any]
        
        apiService.fetchData { (responseDict, error) in
            
            if error == nil, let responseDict = responseDict{
                
                print(responseDict)
                
                DispatchQueue.main.async {
                    
                    if "\(responseDict.value(forKey: "code") ?? "")" == "200"{
                        
                        if let priceDict = responseDict.value(forKey: "price_summary") as? NSDictionary{
                            
                            self.lblSubTotal.text = price("\(priceDict.value(forKey: "subtotal") ?? "")")
                            self.lblCoupon.text = price("\(priceDict.value(forKey: "coupon_appplied_amt") ?? "")")
                            
                            let grandTotal = "\(priceDict.value(forKey: "grandtotal") ?? "")"
                            let total = (Double(grandTotal) ?? 0.0) + (Double(self.selectedShippingCharge) ?? 0.0)
                            
                            self.lblTotalPrice.text = price("\(total)")
                            self.couponCodeContStackView.isHidden = false
                            
                            self.setCouponApplyBtn(enable: false)
                            self.txtCouponCode.isUserInteractionEnabled = false
                            
                        }else{
                            self.txtCouponCode.text = ""
                            AlertController.alert(withMessage: "Invalid Coupon Code", presenting: self)
                            self.setCouponApplyBtn(enable: false)
                        }
                   
                    }else{
                        self.txtCouponCode.text = ""
                        AlertController.alert(withMessage: "Invalid Coupon Code", presenting: self)
                        self.setCouponApplyBtn(enable: false)
                    }
                }
            }
        }
    }
    
    
    //MARK:- METHODS
    func setUi(){
        DispatchQueue.main.async {
            self.qpRequestParams = QPRequestParameters(viewController: self)
            self.qpRequestParams.delegate = self
        }

        self.paymentTableView.register(UINib(nibName: "OptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "OptionsTableViewCell")
        self.paymentTableView.delegate = self
        self.paymentTableView.dataSource = self
        self.view.layoutIfNeeded()
        self.btnPlaceOrder.addGradient(colorOne: nil, colorTwo: nil)
        
        self.navigationItem.title = "PAYMENT"
        
        self.lblCouponLeft.attributedText = "Coupon discount  ".attributedStirngWith(color: Colors.mainTxtColor, size: 14, font: lblCouponLeft.font) + "Remove".attributedStirngWith(color: UIColor.red, size: 14, font: lblCouponLeft.font)
        
        self.couponCodeContStackView.isHidden = true
        
        
        self.lblCouponLeft.addTapGestureRecognizer {
            self.removeCoupon()
        }
        
        self.setCouponApplyBtn(enable: false)
        
        
        self.txtCouponCode.addTarget(self, action: #selector(couponCodeDidChange), for: .editingChanged)
        
       
        let enableOnlinePayment = "\(UserDefaults.standard.value(forKey: PreferenceKeys.ENABLE_ONLINE_PAYMENT) ?? "")"
        if enableOnlinePayment == "1"{
            self.paymentOptionsArray = ["Cash on Delivery","Credit / Debit Card"]
        }else{
            self.paymentOptionsArray = ["Cash on Delivery"]
        }
        
        self.paymentTableView.reloadData()
    }
    
    func setContentView(){
        
        let subTotal = "\((self.responseDict.value(forKey: "cart_total") as AnyObject).value(forKey: "subtotal") ?? "")"
        self.lblSubTotal.text = price(subTotal)
        self.lblDeliveryCharge.text = price(self.selectedShippingCharge)
        
        let totalAmount = (Double(subTotal) ?? 0.0) + (Double(self.selectedShippingCharge) ?? 0.0)
        self.lblTotalPrice.text = price("\(totalAmount)")
        
        self.paymentTableViewHeightConstraint.constant = self.paymentTableView.contentSize.height + self.paymentTableView.contentInset.bottom + self.paymentTableView.contentInset.top + 44
        
    }
    
  
    @objc func couponCodeDidChange(){
        
        if self.txtCouponCode.text == ""{
            self.setCouponApplyBtn(enable: false)
        }else{
            self.setCouponApplyBtn(enable: true)
        }
        
    }
    func setCouponApplyBtn(enable:Bool){
        
        if enable{

            self.btnApplyCoupon.addGradient(colorOne: nil, colorTwo: nil)
            self.btnApplyCoupon.backgroundColor = UIColor.clear
            self.btnApplyCoupon.isUserInteractionEnabled = true
            self.btnApplyCoupon.alpha = 1
            //self.btnApplyCoupon.enable()
            
        }else{
            
            self.btnApplyCoupon.removeGradient()
            self.btnApplyCoupon.backgroundColor = UIColor.darkGray
            self.btnApplyCoupon.isUserInteractionEnabled = false
            self.btnApplyCoupon.alpha = 0.5
            //self.btnApplyCoupon.desable()
            
        }
        
    }
    
    
    func removeCoupon(){
        
        self.couponCodeContStackView.isHidden = true
        self.txtCouponCode.isUserInteractionEnabled = true
        self.setCouponApplyBtn(enable: true)
        self.txtCouponCode.text = ""
        self.setContentView()
        
    }
    
    
    //MARK:- BTN ACTIONS
    @IBAction func placeOrder(_ sender: Any) {
        
        self.placeOrder()
        
    }
    
    @IBAction func applyCouponAction(_ sender: UIButton) {
        
        self.applyCouponCode()
        
    }
    
}


extension PaymentViewControllerNew : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        return self.paymentOptionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsTableViewCell") as! OptionsTableViewCell
        cell.lblItemName.text = self.paymentOptionsArray[indexPath.row]
        cell.lblPrice.isHidden = true
        
        if indexPath.row == self.selectedPaymentModeIndex{
            cell.imgRadio.image = #imageLiteral(resourceName: "radio_btn_selected")
        }else{
            cell.imgRadio.image = #imageLiteral(resourceName: "radio_btn")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedPaymentModeIndex = indexPath.row
        tableView.reloadData()
        
    }
        
}


extension PaymentViewControllerNew : QPRequestProtocol{
    
    
    func gotoQpay(orderID : String,price:Double){
        DispatchQueue.main.async {
            self.qpRequestParams = QPRequestParameters(viewController: self)
            self.qpRequestParams.delegate = self
            
            var addressData = NSDictionary()
            if let deliveryAddressArray = (self.responseDict.value(forKey: "address") as AnyObject).value(forKey: "delivery_address") as? NSArray{
                if deliveryAddressArray.firstObject != nil, let address = deliveryAddressArray.firstObject as? NSDictionary{
                    addressData = address
                }
            }
            
            let name = "\(addressData.value(forKey: "full_name") ?? "")" + "\(addressData.value(forKey: "last_name") ?? "")"
            _ = "\(addressData.value(forKey: "house_no") ?? "")"
            let town = "\(addressData.value(forKey: "town") ?? "")"
            _ = "\(addressData.value(forKey: "building_name") ?? "")"
            _ = "\(addressData.value(forKey: "street") ?? "")"
            _ = "\(addressData.value(forKey: "pin_code") ?? "")"
            let phone = "\(addressData.value(forKey: "mobile_number") ?? "")"
            _ = "\(addressData.value(forKey: "landmark") ?? "")"
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let userData = appDelegate.userProfileDetails
            let email = "\(userData?.value(forKey: "email") ?? "")"
            _ = "\(userData?.value(forKey: "phone") ?? "")"
            
            self.qpRequestParams.gatewayId = "019252994"
            self.qpRequestParams.secretKey = "2-f6SY45I3aeAyjb"
            self.qpRequestParams.name = name
            self.qpRequestParams.address = formatAddress(addressData:addressData)
            self.qpRequestParams.city = town
            self.qpRequestParams.state = town
            self.qpRequestParams.country = "QA"
            self.qpRequestParams.email = email
            self.qpRequestParams.currency = "QAR"
            self.qpRequestParams.referenceId = orderID
            self.qpRequestParams.phone = phone
            self.qpRequestParams.amount = price //any float value
            self.qpRequestParams.mode = "live"
            self.qpRequestParams.productDescription = "description"
            self.qpRequestParams.sendRequest()
        }

    }
    
    
    func qpResponse(_ response: NSDictionary) {
        
        DispatchQueue.main.async {
            
            //AlertController.alert(withMessage: "\(response)", presenting: self)
            print(response)
            let status = "\(response.value(forKey: "status") ?? "")"
            if status == "success"{

                var jsonString = ""

                if let theJSONData = try?  JSONSerialization.data(
                    withJSONObject: response,
                    options: .prettyPrinted
                    ),
                    let jsonTxt = String(data: theJSONData,
                                             encoding: String.Encoding.ascii) {
                    print("JSON string = \n\(jsonString)")
                    jsonString = jsonTxt
                }

                self.savePaymentApi(orderID: "\(response.value(forKey: "orderId") ?? "")", jsonString: jsonString)
            }else{
                AlertController.alert(withMessage: "Failed", presenting: self)
            }
            
        }
                
    }
    
    
    func savePaymentApi(orderID:String,jsonString:String){
    
        let apiService = ApiService.shared
        
        apiService.urlString = parentURL + savePayment
        apiService.target = self
        
        
        let paramter = ["order_id":orderID,
                        "parameters":jsonString]
        
        apiService.parameter = paramter as [String : Any]
        
        apiService.fetchData { (responseDict, error) in
            
            if error == nil, let responseDict = responseDict{
                
                print(responseDict)
                //self.responseDict = responseDict
                
                DispatchQueue.main.async {
                    //self.setContentView()
                    
                    //AlertController.alert(withMessage: "\(responseDict)", presenting: self)
                    
                    if "\(responseDict.value(forKey: "code") ?? "")" == "200"{
                        
                        self.tabBarController?.tabBar.items?.last?.badgeValue = nil
                        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                        self.navigationController?.pushViewController(nextVc, animated: false)
                        
                    }
                    
                }
            }
        }
    }
    
    
}
