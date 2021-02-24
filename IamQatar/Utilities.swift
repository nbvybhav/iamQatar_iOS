////
////  Utilities.swift
////  Pulimart
////
////  Created by anuroop on 30/10/18.
////  Copyright © 2018 Alisons Infomatics. All rights reserved.
////
//
//import Foundation
//import UIKit
//import NYAlertViewController
//import Toaster
//

@objc class Utilities : NSObject{
    
    @objc func isiPhone5()-> Bool{
        return UIScreen.main.bounds.height <= 568
    }
    
    @objc func convertStringToDate(dateString:String) -> Date? {
        
        if dateString != "null" || dateString != "<null>" || dateString != ""{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"//"yyyy-MM-dd HH:mm:ss"
            guard let date = dateFormatter.date(from: dateString) else { return nil }
            return date
            
        }else{
            return nil
        }
    }
    
    
    
//    @objc func mainTxtColor()->UIColor{
//        return Colors.mainTxtColor
//    }
    
}


func userId()->String{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return "\(appDelegate.userProfileDetails.object(forKey: "user_id") ?? "")"
    
}

func price(_ val:String)->String{
    
//    let parts = val.components(separatedBy: ".")
//
//    var value  = val
//    if parts.first == "0"{
//        return value
//    }else{
//        if parts.count > 1 && parts.last?.count == 1{
//            value = val + "0"
//        }else{
//            value = val + ".00"
//        }
//    }
//
//    return "QAR \(value)"
    return "QAR \(val)"
}


////MARK:- ALERTS
//func makeAlert( title : String, message : String, okBtnTitle : String, cancelBtnTitle : String, okAction okActionHere : @escaping () -> Void , cancelAction cancelActionHere : @escaping () -> Void , presenting : UIViewController ){
//
//
//    let alertViewController = NYAlertViewController()
//
//    // Set a title and message
//    alertViewController.title = title
//    alertViewController.message = message
//    //alertViewController.titl
//
//
//    // Customize appearance as desired
//    alertViewController.view.tintColor = presenting.view.tintColor
//    alertViewController.view.superview?.alpha = 0.3
//    alertViewController.cancelButtonColor = Colors.themeColour
//
//
//
//    alertViewController.titleFont = Fonts.FONT_BOLD.withSize(19)//UIFont(name: Fonts.FONT_BOLD, size: 19.0)
//    alertViewController.messageFont = Fonts.FONT_MEDIUM.withSize(16)//UIFont(name: Fonts.FONT_MEDIUM, size: 16.0)
//    alertViewController.cancelButtonTitleFont = Fonts.FONT_MEDIUM.withSize(16)//UIFont(name: Fonts.FONT_MEDIUM, size: 16.0)
//    alertViewController.cancelButtonTitleFont = Fonts.FONT_MEDIUM.withSize(16)//UIFont(name: Fonts.FONT_MEDIUM, size: 16.0)
//
//    alertViewController.swipeDismissalGestureEnabled = false
//    alertViewController.backgroundTapDismissalGestureEnabled = false
//
//
//    // Add alert actions
//
//    if cancelBtnTitle != ""{
//        let cancelAction = NYAlertAction(
//            title: NSLocalizedString(cancelBtnTitle, comment: ""),
//            style: .cancel,
//            handler: { (action: NYAlertAction!) -> Void in
//
//                presenting.dismiss(animated: true, completion: nil)
//                cancelActionHere()
//
//        })
//        alertViewController.addAction(cancelAction)
//    }
//
//
//    let okAction = NYAlertAction(
//        title: NSLocalizedString(okBtnTitle, comment: ""),
//        style: .cancel,
//        handler: { (action: NYAlertAction!) -> Void in
//
//            presenting.dismiss(animated: true, completion: nil)
//            okActionHere()
//
//
//    })
//
//    alertViewController.addAction(okAction)
//
//    // Present the alert view controller
//    presenting.present(alertViewController, animated: true, completion: nil)
//
//}
//
//func makeAlert( title : String, message : String, okBtnTitle : String, okAction okActionHere : @escaping () -> Void , presenting : UIViewController ){
//
//    makeAlert(title: title, message: message, okBtnTitle: okBtnTitle, cancelBtnTitle: "", okAction: {
//        okActionHere()
//    }, cancelAction: { }, presenting: presenting)
//
//}
//
//func makeAlert(title : String, message : String,presenting : UIViewController){
//
//    makeAlert(title: title, message: message, okBtnTitle: "Done", okAction: {}, presenting: presenting)
//
//}
//
//func noNetworkAlert(presenting:UIViewController){
//
//    makeAlert(title: "Oops", message: "Failed, please check your network connection", okBtnTitle: "Retry", okAction: {
//
//        presenting.viewWillAppear(false)
//        presenting.viewDidLoad()
//        presenting.viewDidAppear(false)
//
//    }, presenting: presenting)
//
//}
//
//
//func guestUserAlert(vc:UIViewController){
//
//    makeAlert(title: "Wait", message: "Please login to continue", okBtnTitle: "OK", okAction: {
//
//        vc.dismiss(animated: true, completion: nil)
//
//        //changing customer id to guest id to pass guest id in sign in view
//        //            let CustomerID = PlistOperations.GetFromPlist(key: keys.CUSTOMER_ID, plist: "constant") as String
//        //            PlistOperations.WriteToPlist(value:CustomerID as NSString, key: keys.GUEST_ID, plist: "constant")
//
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        //vc.present(nextViewController, animated: true, completion: nil)
//        (vc.navigationController ?? vc as! UINavigationController).pushViewController(nextViewController, animated: true) // vc is navigation controller when comming from refferal link
//
//    }, presenting: vc)
//
//}
//
//func makeToast(_ message:String) {
//
//    Toast(text: message, duration: Delay.short).show()
//}
//
//
////MARK:- MISC
//func searchFor(text:String, inArray:NSArray,predicate:String) -> NSArray {
//
//    let predicate = NSPredicate(format: "\(predicate) contains[c] %@", argumentArray: [text])
//    let searchResultArray = inArray.filter { predicate.evaluate(with: $0) } as NSArray
//
//
//
//
//    print(searchResultArray)
//
//    return searchResultArray
//
//}
//
//func makeCallTo(number:String,_ vc:UIViewController)  {
//    if number != ""{
//        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
//    }else{
//        Toast(text: "Phone number not available", duration: Delay.short).show()
//    }
//}
//
//func isGuest() -> Bool{
//
//    let guestId = "\(UserDefaults.standard.value(forKey: keys.GUEST_ID)!)"
//    if guestId == ""{
//        return false
//    }else{
//        return true
//    }
//
//}
//
//func removeUserData(){
//
//    PlistOperations.WriteToPlist(value: "", key: keys.TOKEN, plist: keys.CONSTANT_PLIST)
//    PlistOperations.WriteToPlist(value: "", key: keys.CUSTOMER_ID, plist: keys.CONSTANT_PLIST)
//    UserDefaults.standard.set("", forKey: keys.BILLING_ADDRESS)
//    UserDefaults.standard.set("", forKey: keys.DELIVERY_ADDRESS)
//    UserDefaults.standard.set("", forKey: keys.PINCODE)
//    UserDefaults.standard.set("", forKey: keys.GUEST_ID)
//    UserDefaults.standard.set("", forKey: keys.REFFERAL_CODE)
//
//}
//
//func gotoSearch(vc:UIViewController){
//
//    let transition = CATransition()
//    transition.duration = constants.FADE_ANIMATION_SPEED
//    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
//    transition.type = CATransitionType.fade;
//    transition.subtype = CATransitionSubtype.fromBottom;
//    vc.navigationController?.view.layer.add(transition, forKey: nil)
//
//    vc.navigationController?.pushViewController(vc.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController, animated: false)
//
//}
//
////MARK:- FORMATTING STRING
//func formatDate(dateString:String) -> String {
//
//    if dateString != "null" || dateString != "<null>" || dateString != ""{
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let date = dateFormatter.date(from: dateString)
//        dateFormatter.dateFormat = "dd MMMM yyyy"
//        return  dateFormatter.string(from: date!)
//
//    }else{
//        return ""
//    }
//
//
//}
//
//func strikeThroughString(_ string : String) ->  NSAttributedString{
//
//    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: string)
//    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
//
//    return attributeString
//
//}
//
//func underlineString(_ string : NSAttributedString) ->  NSAttributedString{
//
//    //guard let text = string else { return }
//    let textRange = NSMakeRange(0, string.length)
//    let attributedText = string.mutableCopy() as! NSMutableAttributedString
//    attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
//    // Add other attributes if needed
//    return attributedText
//
//}
//
//func price(_ price:String) -> String{
//
//    if price == ""{
//        return ""
//    }else{
//        let priceSymbolDict = UserDefaults.standard.value(forKey: keys.PRICE_SYMBOL) as! NSDictionary
//        let roundedPrice = removeTrailingZero("\(Double(round(100.0*(Double(price) ?? 0.0))/100.0))") // round to two digits and remove trailing zero
//        return "\(priceSymbolDict.value(forKey: keys.PRICE_LEFT_SYMBOL)!)" + roundedPrice + "\(priceSymbolDict.value(forKey: keys.PRICE_RIGHT_SYMBOL)!)"
//    }
//
//}
//
//func removeTrailingZero(_ value :String) -> String {
//
//    let trailling = value.components(separatedBy: ".").last!
//    let priceValue = HelperValidate.containsOnlyZero(trailling) ? value.components(separatedBy: ".").first! : value
//    return priceValue
//}
//
//func formatOfferString(_ offerString : String) -> String{
//
//    let value = "\(offerString)".components(separatedBy: "|").first!
//    let type = "\(offerString)".components(separatedBy: "|").last!
//
//    if(type == "percentage") {
//        return (removeTrailingZero(value) + "% off")
//    }else if(type == "flat"){
//        return (price(value) + " off")
//    }else{
//        return ""
//    }
//
//}
//
//
func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {

    let combination = NSMutableAttributedString()

    combination.append(lhs)
    combination.append(rhs)

    return combination

}
//
//
//func formatAddress(addressData:NSDictionary) -> String{
//
//    var city = ""
//    var zipcode = ""
//    var name = ""
//    var state = ""
//    var country = ""
//    var addressType = ""
//    var address = ""
//
//    if let _ = addressData.value(forKey: "city"){
//        city = "\(addressData.value(forKey: "city")!)"
//        zipcode = "\(addressData.value(forKey: "zipcode")!)"
//        name = "\(addressData.value(forKey: "name")!)"
//        state = "\(addressData.value(forKey: "state")!)"
//        country = "\((addressData.value(forKey: "country") as AnyObject).value(forKey: "name")!)"
//        addressType = "(\(addressData.value(forKey: "address_type")!))"
//        address = "\(addressData.value(forKey: "address")!)"
//    }
////    else{
////        city = "\(addressData.value(forKey: "billing_city")!)"
////        zipcode = "\(addressData.value(forKey: "billing_zipcode")!)"
////        name = "\(addressData.value(forKey: "billing_name")!)"
////        state = "\(addressData.value(forKey: "billing_state")!)"
////        country = "\(addressData.value(forKey: "billing_country")!)"
////        addressType = "\(addressData.value(forKey: "shipping_address_type")!)"
////        address = "\(addressData.value(forKey: "billing_address")!)"
////    }
//
//    let newAddressString = address.replacingOccurrences(of: "|", with: ",")
//
//    let addressString = "\(name) \(addressType)\n\(newAddressString)\n\(city) \(state) \n\(country)\n\(zipcode)"
//    print(addressString)
//
//    return addressString
//
//}
//
//
////MARK:- CART COUNT
//func setCartCount(button : UIButton,count:String,type:String = "CART_COUNT")  {
//
//    let view = button.superview
//    view?.layer.layoutIfNeeded()
//
//    if count == "0" || count == ""{
//
//        removeCartCount(button: button, type: type)
//
//    }else{
//
//        let language =  "en"//PlistOperations.GetFromPlist(key: "Ext", plist: "constant") as String
//
//        var X = CGFloat()
//        var Y = CGFloat()
//
//        if language == "en"{
//
//            removeCartCount(button: button, type: type)
//            X = button.frame.origin.x + button.frame.width / 2 + button.frame.width / 4
//            Y = button.frame.origin.y + button.frame.height / 2 - button.frame.height / 4
//
//        }else if language == "ar"{
//
//            removeCartCount(button: button, type: type)
//            X = button.frame.origin.x + button.frame.width / 2 - button.frame.width / 4
//            Y = button.frame.origin.y + button.frame.height / 2 - button.frame.height / 4
//
//        }
//
//        let circlePath = UIBezierPath(arcCenter: CGPoint(x: X,y: Y), radius: CGFloat(8), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = circlePath.cgPath
//        shapeLayer.fillColor = UIColor.white.cgColor
//        shapeLayer.strokeColor = Colors.themeColour.cgColor
//        shapeLayer.lineWidth = 0.5
//        shapeLayer.accessibilityValue = type + "LAYER"
//        view?.layer.addSublayer(shapeLayer)
//
//        let label = UILabel()
//        label.frame = CGRect(x: X - 10, y:Y - 10, width: 20, height:20 )
//        label.textColor = Colors.themeColour
//        label.text = Int(count)! > 10 ? "9+" : count
//        label.font = label.font.withSize(10)
//        label.textAlignment = .center
//        label.accessibilityValue = type + "LABEL"
//        view?.addSubview(label)
//
//    }
//    view?.layer.layoutIfNeeded()
//
//}
//fileprivate func removeCartCount(button : UIButton,type:String){
//
//    let view = button.superview
//    view?.layer.layoutIfNeeded()
//
//    // to remove shapeLayer
//    for layer in (view?.layer.sublayers)! {
//
//        if layer.accessibilityValue == type + "LAYER" {
//
//            layer.removeFromSuperlayer()
//        }
//
//    }
//
//    //to remove label
//    for view in (view?.subviews)!{
//
//        if view.accessibilityValue == type + "LABEL" {
//
//            view.removeFromSuperview()
//        }
//
//    }
//
//}
//
