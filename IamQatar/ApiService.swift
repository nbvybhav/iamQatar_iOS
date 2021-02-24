//
//  ApiService.swift
//  Thawseel
//
//  Created by anuroop kanayil on 06/12/19.
//  Copyright © 2019 Alisons Informatics. All rights reserved.
//

import Foundation
import UIKit



class ApiService: NSObject {
    
    static let shared = ApiService()
    
    var urlString = String()
    var parameter = [String:Any]()
    var target = UIViewController()
    
    
    func fetchData(completion: @escaping (NSDictionary?, Error?) -> ()) {

        
        print(parameter)
        print(urlString)
        
        let progressHUD = ProgressHUDD(text: "")
        target.view.addSubview(progressHUD)
        
        guard Reachability.isConnectedToNetwork() else{
            //makeAlert(title: "", message: "Internet connection appears to be ofline", presenting: target)
            AlertController.alert(withMessage: "Internet connection appears to be ofline", presenting: target)
            return
        }
        
        
        guard let serviceUrl = URL(string: urlString) else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"//parameter.count == 0 ? "GET" : "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        

        let postString = self.paremterAsString()//user id is added automatically for all api calls
        request.httpBody = postString.data(using: .utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                progressHUD.hide()
            }
            
//            if let response = response {
//                print(response)
//            }
            
            
            
            if let data = data {
                do {
                    
                    let reponseString = String(data: data, encoding: .ascii)
                    print(reponseString ?? "no reponse string")
                    
                    //makeAlert(title: "", message: reponseString ?? "", okBtnTitle: "ok", okAction: {}, presenting: self.target)
                    
                    let responseHere = (try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) ) //as! NSDictionary
                    //print(responseHere)
                    
                    DispatchQueue.main.async {
                        //completion(data,nil)
                        completion(responseHere as? NSDictionary,nil)
                    }
                    
                    
                    
                } catch {
                    print(error)
                    //makeToast("Something went wrong".localized())
                    AlertController.alert(withMessage: "Something went wrong", presenting: self.target)
                    completion(nil, error)
                }
            }
            }.resume()
        

    }
    
    //create parameter string
    func paremterAsString() -> String{

//        let selectedRegionId = "\(UserDefaults.standard.value(forKey: Keys.SELECTED_REGION) ?? "")"
//        let selectedLanguage = "\(UserDefaults.standard.value(forKey: Keys.SELECTED_LANGUAGE) ?? "")"


        var paramString = ""

        for (key,value) in self.parameter as NSDictionary {
            paramString +=  "\(key)=\(value)&"
        }

        //paramString = paramString + "user_id=\(getUserID())&region_id=\(selectedRegionId)&lang=\(selectedLanguage)"

        print(paramString)

        return paramString

    }
    
}


class ProgressHUDD: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            var width = CGFloat()
            
            if text == ""{
                width = 50
            }else{
                width = superview.frame.size.width / 2.3
            }
            
            //let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            vibrancyView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: activityIndicatorSize + 5,
                                 y: 0,
                                 width: width - activityIndicatorSize - 15,
                                 height: height)
            label.textColor = UIColor.gray
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}


//func getResponseFromServer(url:String,parameter:NSDictionary?,target:UIViewController,onSuccess: @escaping(NSDictionary) -> Void, onFailure: @escaping(Error) -> Void){
//
//
//    let progressHUD = ProgressHUD(text: "")
//    target.view.addSubview(progressHUD)
//
//    guard let serviceUrl = URL(string: url) else { return }
//
//    var request = URLRequest(url: serviceUrl)
//
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//
//    if let parameter = parameter{
//
//        request.httpMethod = "POST"//parameter.count == 0 ? "GET" : "POST"//httpMethod
//
//        if parameter.count != 0{//httpMethod == "POST"{
//            print("parameter : ",parameter)
//            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else {
//                return
//            }
//
//            request.httpBody = httpBody
//
//        }
//    }
//
//    let session = URLSession.shared
//    session.dataTask(with: request) { (data, response, error) in
//
//        DispatchQueue.main.async {
//            progressHUD.hide()
//        }
//
//        if let data = data {
//
//            let reponseString = String(data: data, encoding: .ascii)
//            print(reponseString)
//
//            do {
//                let response = (try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) ) //as! NSDictionary
//                print(response)
//                onSuccess(response as! NSDictionary)
//
//            } catch {
//
//                print(error)
//                //makeAlert(title: "Failed", message: "", presenting: target)
//                onFailure(error)
//            }
//        }
//        }.resume()
//
//
//
//
//}




//        if parameter.count != 0{
//            let parameterDictionary = parameter
//            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
//                return
//            }
//            request.httpBody = httpBody
//        }

