//
//  AddressListViewController.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 31/01/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

protocol SendDataBackDelegate {
    func recievedData(_ dict : NSDictionary)
}

class AddressListViewController: BaseViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var addressListTableView: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    //MARK:- VARIABLES
    var responseAddress = NSArray()
    @IBOutlet weak var addressTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnAddAddress: UIButton!
    
    
    //MARK:- VARIABLES
    var selectedAddressIndex = Int()
    var sendDataBackDelegate : SendDataBackDelegate?
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUi()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.delegate = self

        self.getAddressList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if self.responseAddress.count > self.selectedAddressIndex{
            self.sendDataBackDelegate?.recievedData(self.responseAddress[self.selectedAddressIndex] as! NSDictionary)
        }else{
            self.sendDataBackDelegate?.recievedData([:])
        }
    }
    
    //MARK:- API CALL
    func getAddressList(){
    
        let apiService = ApiService.shared
        
        apiService.urlString = parentURL + getAddresses
        apiService.target = self
        
        let paramter = ["user_id":userId()]
     
        apiService.parameter = paramter as [String : Any]
        
        apiService.fetchData { (responseDict, error) in
            
            if error == nil, let responseDict = responseDict{
                
                print(responseDict)
                self.setContentView(responseDict: responseDict)

            }
        }
    }
    
    func deleteAddress(id:String){
    
        let apiService = ApiService.shared
        
        apiService.urlString = parentURL + deleteAddressAPI
        apiService.target = self
        
        let paramter = ["user_id":userId(),
                        "id":id]
                        
        apiService.parameter = paramter as [String : Any]
        
        apiService.fetchData { (responseDict, error) in
            
            if error == nil, let responseDict = responseDict{
                
                print(responseDict)
                let status = "\(responseDict.value(forKey: "code") ?? "")"
                if status == "200"{
                    self.setContentView(responseDict: responseDict)
                }
                
            }
        }
    }
    
    //MARK:- METHODS
    func setUi(){
        
        
        self.addressListTableView.register(UINib(nibName: "AddressListTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressListTableViewCell")
        self.addressListTableView.delegate = self
        self.addressListTableView.dataSource = self
        
        self.view.layoutIfNeeded()
        self.btnSubmit.addGradient(colorOne: nil, colorTwo: nil)
        
        self.navigationItem.title = "CHANGE ADDRESS"
        
        self.btnAddAddress.isHidden = true
        
        
    }
    
    func setContentView(responseDict:NSDictionary){
        
        DispatchQueue.main.async {

            self.responseAddress = (((responseDict.value(forKey: "value") as AnyObject).value(forKey: "address") as AnyObject).value(forKey: "delivery_address") ?? []) as! NSArray
            
            if self.responseAddress.count <= self.selectedAddressIndex{
                self.selectedAddressIndex = 0
            }
            
            
            self.addressListTableView.reloadData()
            self.setContentViewHieght()
            self.setContentViewHieght()
            self.btnAddAddress.isHidden = false
            
        }        
    }
    
    func setContentViewHieght(){
        
        self.view.layoutIfNeeded()
        self.addressTableViewHeightConstraint.constant = self.addressListTableView.contentSize.height + self.addressListTableView.contentInset.bottom + self.addressListTableView.contentInset.top //+ 44
        self.view.layoutIfNeeded()
        
        self.mainContentViewHeightConstraint.constant = self.addressTableViewHeightConstraint.constant + 120
        
    }
    
    //MARK:- BTN ACTIONS
    @IBAction func addAddressAction(_ sender: UIButton) {
        
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewControllerNew") as! AddAddressViewControllerNew
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension AddressListViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.responseAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListTableViewCell") as!
        AddressListTableViewCell
        
        if let addressData = self.responseAddress[indexPath.row] as? NSDictionary{
            cell.lblAddress.text = formatAddress(addressData:addressData)
            
//            if addressId == self.selectedAddressId{
//                cell.imgRadio.image = #imageLiteral(resourceName: "radio_btn_selected")
//            }else{
//                cell.imgRadio.image = #imageLiteral(resourceName: "radio_btn")
//            }
            if self.selectedAddressIndex == indexPath.row{
                cell.imgRadio.image = #imageLiteral(resourceName: "radio_btn_selected")
                cell.btnEdit.isHidden = false
                cell.btnDelete.isHidden = false
            }else{
                cell.imgRadio.image = #imageLiteral(resourceName: "radio_btn")
                cell.btnEdit.isHidden = true
                cell.btnDelete.isHidden = true
            }
            
            //edit action
            let addressId = "\(addressData.value(forKey: "id") ?? "")"
            cell.btnEdit.addTapGestureRecognizer {
                
                let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewControllerNew") as! AddAddressViewControllerNew
                nextVc.addressToEdit = addressData
                self.navigationController?.pushViewController(nextVc, animated: true)
                
            }
            
            cell.btnDelete.addTapGestureRecognizer {
                self.deleteAddress(id: addressId)
            }
            
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.selectedAddressId = "\((self.responseAddress[indexPath.row] as AnyObject).value(forKey: "id") ?? "")"
        self.selectedAddressIndex = indexPath.row
        self.addressListTableView.reloadData()
    }
        
}


//extension AddressListViewController: UITabBarControllerDelegate {
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
