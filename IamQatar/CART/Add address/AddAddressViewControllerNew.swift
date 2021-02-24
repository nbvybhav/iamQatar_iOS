//
//  AddAddressViewController.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 01/02/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit



class AddAddressViewControllerNew: BaseViewController {

    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnOffice: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtLastName: CustomTextFiled!
    @IBOutlet weak var txtAddressOne: CustomTextFiled!
    @IBOutlet weak var txtAddressTwo: CustomTextFiled!
    @IBOutlet weak var txtBuildingNum: CustomTextFiled!
    @IBOutlet weak var txtZoneNO: CustomTextFiled!
    @IBOutlet weak var txtStreetNo: CustomTextFiled!
    @IBOutlet weak var txtMobileNo: CustomTextFiled!
    @IBOutlet weak var txtAdditionalInfo: CustomTextFiled!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainContentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblSelectedLocatioName: UILabel!
    
    //MARK:- VARIABLES
    var selectedAddressType = "Home"
    var addressToEdit = NSDictionary()
    var selectedLat = ""
    var selectedLong = ""
    
    //MAR:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUi()
        
        print(addressToEdit)
        
        if self.addressToEdit.count != 0{
            self.setContentView()
        }
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController?.delegate = self
//    }
    
//     parameters =  @{@"user_id": [appDelegate.userProfileDetails objectForKey:@"user_id"], @"full_name":_fullNameTxt .text, @"mobile_no": _mobileNumTxt.text, @"building_name": _buildingName.text, @"flat_no": _flatNoTxt.text, @"street": _streetTxt.text,@"address
    
    //MARK:- API CALL
    func addAddress(){
    
        let apiService = ApiService.shared
        
        apiService.urlString = parentURL + addUserAddress
        apiService.target = self
        
        let paramter = ["user_id":userId(),
                        "full_name":self.txtFullName.text! + self.txtLastName.text!,
                        "mobile_no":self.txtMobileNo.text!,
                        "building_name":self.txtAddressOne.text!,
                        "flat_no":self.txtBuildingNum.text!,
                        "street":self.txtStreetNo.text!,
                        "moreinfo":self.txtAdditionalInfo.text!,
                        "address_type":self.selectedAddressType,
                        "town":self.txtAddressTwo.text!,
                        "pin_code":self.txtZoneNO.text!,
                        "longitude":"",
                        "latitude":"",
                        "id":"\(self.addressToEdit.value(forKey: "id") ?? "")"]
                        
        apiService.parameter = paramter as [String : Any]
        
        apiService.fetchData { (responseDict, error) in
            
            if error == nil, let responseDict = responseDict{
                
                print(responseDict)
                let status = "\(responseDict.value(forKey: "code") ?? "")"
                if status == "200"{
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
    }
    
    
    //MARK:- METHODS
    func setUi(){
        
        self.btnHome.accessibilityLabel = "Home"
        self.btnOffice.accessibilityLabel = "Office"
        self.btnOther.accessibilityLabel = "Other"
//        self.btnHome.tag = 0
//        self.btnOffice.tag = 1
//        self.btnOther.tag = 2
        
        self.view.layoutIfNeeded()
        self.setAddressType(sender: self.btnHome)
        
        self.navigationItem.title = "ADD ADDRESS"
        
        self.btnSave.addGradient(colorOne: nil, colorTwo:  nil)
        
        self.hideKeyboard()
        self.setUpKeyboard()
        
        
        //KeyboardStateListener.key
        
        
    }
    
    func setContentView(){
        
        self.selectedLat = "\(self.addressToEdit.value(forKey: "latitude") ?? "")"
        self.selectedLat = "\(self.addressToEdit.value(forKey: "longitude") ?? "")"
        self.lblSelectedLocatioName.text = "\(self.addressToEdit.value(forKey: "town") ?? "")"
        
        self.txtFullName.text = "\(self.addressToEdit.value(forKey: "full_name") ?? "")"
        self.txtLastName.text = "\(self.addressToEdit.value(forKey: "last_name") ?? "")"
        self.txtAddressOne.text = "\(self.addressToEdit.value(forKey: "building_name") ?? "")"
        self.txtAddressTwo.text = "\(self.addressToEdit.value(forKey: "town") ?? "")"
        self.txtBuildingNum.text = "\(self.addressToEdit.value(forKey: "house_no") ?? "")"
        self.txtZoneNO.text = "\(self.addressToEdit.value(forKey: "pin_code") ?? "")"
        self.txtStreetNo.text = "\(self.addressToEdit.value(forKey: "street") ?? "")"
        self.txtMobileNo.text = "\(self.addressToEdit.value(forKey: "mobile_number") ?? "")"
        self.txtAdditionalInfo.text = "\(self.addressToEdit.value(forKey: "landmark") ?? "")"
        
        let addressType = "\(self.addressToEdit.value(forKey: "address_type") ?? "")"
        self.setAddressType(sender: addressType == "Home" ? btnHome : (addressType == "office" ? btnOffice : btnOther))
        
        
    }
    
    func setAddressType(sender:UIButton){
        
        self.selectedAddressType = sender.accessibilityLabel!
        
        let btnArray = [self.btnHome,self.btnOffice,self.btnOther]
        for btn in btnArray{
            
            btn?.backgroundColor = UIColor.clear
            
            if self.selectedAddressType == btn?.accessibilityLabel{
                btn?.addGradient(colorOne: nil, colorTwo: nil)
                btn?.setTitleColor(UIColor.white, for: .normal)
            }else{
                btn?.removeGradient()
                btn?.setTitleColor(Colors.gradStartNew, for: .normal)
            }
        }
    }
    
    func setUpKeyboard(){
        
        // keyboard show / hide observers , used to change scrollview content size
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
         
            mainScrollView.contentSize.height = mainContentViewHeightConstraint.constant + keyboardHeight
        }
    }
        
        
    @objc func keyboardWillHide(_ notification: Notification) {

        mainScrollView.contentSize.height = mainContentViewHeightConstraint.constant
    }
    
    
    //MARK:- BTN ACTIONS
    @IBAction func adddressTypeAction(_ sender: UIButton) {
  
        self.setAddressType(sender:sender)
        
    }
    @IBAction func saveAction(_ sender: UIButton) {
        
        if self.txtFullName.text == ""{
            AlertController.alert(withMessage: "Enter full name", presenting: self)
        }else if self.txtFullName.text == ""{
            AlertController.alert(withMessage: "Enter last name", presenting: self)
        }else if self.txtAddressOne.text == ""{
            AlertController.alert(withMessage: "Enter address", presenting: self)
        }else if self.txtAddressTwo.text == ""{
            AlertController.alert(withMessage: "Enter address", presenting: self)
        }
//        else if self.txtZoneNO.text == ""{
//            AlertController.alert(withMessage: "Enter zone number", presenting: self)
//        }else if self.txtStreetNo.text == ""{
//            AlertController.alert(withMessage: "Enter street number", presenting: self)
//        }
        else if self.txtMobileNo.text == ""{
            AlertController.alert(withMessage: "Enter mobile number", presenting: self)
        }else if !HelperValidate.isValidPhone(self.txtMobileNo.text!){
            AlertController.alert(withMessage: "Invalid phone number", presenting: self)
        }else if self.selectedLat == ""{
            AlertController.alert(withMessage: "Please select preferred location", presenting: self)
        }else{
            self.addAddress()
        }
    }
    
    @IBAction func selectLocationAction(_ sender: UIButton) {
        
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        nextVc.locationSelectionDelegte = self
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    
}

extension AddAddressViewControllerNew : MapVcDelegate{
    
    func locationSelected(locationData: NSDictionary) {
        
        print(locationData)
        
        self.selectedLat = "\(locationData.value(forKey: "lat") ?? "")"
        self.selectedLong = "\(locationData.value(forKey: "long") ?? "")"
        self.lblSelectedLocatioName.text = "\(locationData.value(forKey: "area") ?? "")" + ", " + "\(locationData.value(forKey: "location_name") ?? "")"
        
        if self.lblSelectedLocatioName.text == ""{
            self.lblSelectedLocatioName.text = "\(self.selectedLat), \(self.selectedLong)"
        }
    }
    
}

extension AddAddressViewControllerNew : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
}

class CustomTextFiled:UITextField {
   required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 12);
    }
}


//extension AddAddressViewControllerNew: UITabBarControllerDelegate {
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
//
