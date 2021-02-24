//
//  ResetPasswordViewController.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 14/01/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var mainScrollView : UIScrollView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @objc var email = ""
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        setUi()
        
    }

    //MARK:- API CALL
    func resetPassword(){
        
        //reserPassword
        //email=maksood%40alisonsgroup.com&password=qwe&confirm_password=qwe&ucode=E93YMG
        
        
        let progressHUD = ProgressHUDD(text: "")
        self.view.addSubview(progressHUD)
        
        //check internet connection
        guard Reachability.isConnectedToNetwork() else {
            progressHUD.hide()
            //noNetworkAlert(presenting: vc)
            AlertController.alert(withMessage: "Network connection not available!", presenting: self)
            return
        }
        
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        let userId = appDelegate.userProfileDetails.value(forKey: "user_id") ?? ""
        
        
        let param = ["email":self.email,
                     "password":self.txtNewPassword.text!,
                     "confirm_password":self.txtNewPassword.text!,
                     "ucode":self.txtCode.text!]
        
        print(param)
        
        let url = parentURL + resetPasswordUrl
        print(url)
        guard let serviceUrl = URL(string: url) else { return }
        //let parameterDictionary = param as NSDictionary
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("text/html; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
//            return
//        }
        //request.httpBody = httpBody
        
        let postString = self.paremterAsString(param)//user id is added automatically for all api calls
        request.httpBody = postString.data(using: .utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            //            if let response = response {
            //                print(response)
            //            }
            
            if let data = data {
                do {
                    
                    let responseDict = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as! NSDictionary
                    print(responseDict)
                    
                    DispatchQueue.main.async {
                        progressHUD.hide()
                        
                        if "\(responseDict.value(forKey: "code") ?? "")" == "200"{
                          
                            AlertController.alert(withMessage: "Password reset successfuly", presenting: self)
                            self.dismiss(animated: true, completion: nil)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                        }else{
                            AlertController.alert(withMessage: "\(responseDict.value(forKey: "text") ?? "")", presenting: self)
                        }
                        
                        
                    }
                    
                } catch {
                    print("data convert to model class error : ",error)
                    progressHUD.hide()
                }
            }
            }.resume()
        
        
    }
    
    

    //MARK:- METHODS
    @IBAction func cancelAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    fileprivate func setUi() {
        //observer for keyboard show hide notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        self.btnSubmit.addGradient(colorOne: nil, colorTwo: nil)
        self.btnCancel.addGradient(colorOne: nil, colorTwo: nil)
        
        self.hideKeyboard()
    }
    
    //create parameter string
    func paremterAsString(_ param:[String:Any]) -> String{

        //let selectedRegionId = "\(UserDefaults.standard.value(forKey: Keys.SELECTED_REGION) ?? "")"

        var paramString = ""

        for (key,value) in param as NSDictionary {
            paramString +=  "\(key)=" + "\("\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")" + "&"
        }

        print(paramString)

        return paramString

    }
    
    //MARK:- BTN ACTIONS
    @IBAction func submitAction(_ sender: UIButton) {
        
        if self.txtCode.text == ""{
            AlertController.alert(withMessage: "Enter Verification Code", presenting: self)
        }else if self.txtNewPassword.text == ""{
            AlertController.alert(withMessage: "Enter New Password", presenting: self)
        }else if self.txtConfirmPassword.text == ""{
            AlertController.alert(withMessage: "Confirm Password", presenting: self)
        }else if self.txtNewPassword.text! != self.txtConfirmPassword.text!{
            AlertController.alert(withMessage: "Password does not match", presenting: self)
        }else{
            self.resetPassword()
        }
        
        
        
        
        
    }
    
    
    
    
    //KEYBOARD
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.mainScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.mainScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.mainScrollView.contentInset = contentInset
    }

}
