//
//  ExtensionFile.swift
//  Pulimart
//
//  Created by User on 14/11/18.
//  Copyright © 2018 Alisons Infomatics. All rights reserved.
//

import Foundation
import UIKit
//import SDWebImage

extension Date {
    
    func adding(_ component: Calendar.Component, _ value: Int) -> Date? {
        return Calendar.current.date(byAdding: component, value: value, to: self)
        
    }
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var day: Int {
        return Calendar.current.component(.day,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
}


@objc extension UIView{
    
    func addShadow()  {
        
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    func addBorder(_ width : Float = 2 , _ color : UIColor = UIColor.white){
        
        self.layer.borderWidth = CGFloat(width)
        self.layer.borderColor = color.cgColor
        
    }
    
    func addGradient(colorOne:UIColor?,colorTwo:UIColor?)  {
        
        clipsToBounds = true
        
        removeGradient()
        
        let gradient = CAGradientLayer()
        
        gradient.frame = bounds
        
//        if let colorOne = colorOne, let colorTwo = colorTwo{
//            gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
//        }else{
//            gradient.colors = [UIColor.green,UIColor.red]//[Colors.gradStartNew, Colors.gradEndNew]
//        }
        
        gradient.colors = [colorOne?.cgColor ?? Colors.gradStartNew.cgColor, colorTwo?.cgColor ?? Colors.gradEndNew.cgColor]
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.accessibilityLabel = "Gradient Layer"
        
        layer.insertSublayer(gradient, at: 0)
        
    }
    
    
    func removeGradient(){
        for sublayer in layer.sublayers ?? []{
            if sublayer.accessibilityLabel == "Gradient Layer"{
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    func addCornerRadius(_ value : CGFloat){

        self.clipsToBounds = true
        self.layer.cornerRadius = value
        
    }
    
    
    func makeRound()  {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    func hideView(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (true) in
            self.isHidden = true
        }
        
    }
    
    func showView(){
        
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }) { (true) in
            self.isHidden = false
        }
        
    }
    
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.cornerRadius
        }
        set {
            if newValue == -1{
                self.makeRound()
            }else{
                
                if self.layer.shadowOpacity > 0 {
                    self.clipsToBounds = false
                }else{
                    self.clipsToBounds = true
                }
                
                self.layer.cornerRadius = newValue
                //self.clipsToBounds = false
            }
            
            
        }
        
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
        
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return self.borderColor
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
        
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return self.shadow
        }
        set {
            if newValue == true{
                self.addShadow()
            }
            
        }
        
    }
    
    @IBInspectable var gradient: Bool {
        get {
            return self.gradient
        }
        set {
            if newValue == true{
                self.layoutIfNeeded()
                self.addGradient(colorOne: nil, colorTwo: nil)
            }
            
        }
        
    }
    
}

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR = "iPhone XR"
        case iPhone_XSMax = "iPhone XS Max"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax
        default:
            return .unknown
        }
    }
    
}

extension UIViewController{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }

}


extension UIImageView{

    func setImage(withUrlString:String) {
        if withUrlString != ""{

//            self.sd_setShowActivityIndicatorView(true)
//            self.sd_setIndicatorStyle(.gray)
            
                Utility.setImage(self, url: withUrlString)
            
            
//            //self.sd_setImage(with: URL(string: withUrlString), completed: nil)
            //self.sd_setImage(with: URL(string: withUrlString), placeholderImage: UIImage(named: "placeholder"))
//            self.sd_setImage(with: URL(string: withUrlString), placeholderImage: UIImage(named: "placeholder"), options: [.scaleDownLargeImages], completed: nil)


//            let urlString = withUrlString
//            guard let url = URL(string: urlString) else { return }
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if error != nil {
//                    print("Failed fetching image:", error as Any)
//                    return
//                }
//
//                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                    print("Not a proper HTTPURLResponse or statusCode")
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    self.image = UIImage(data: data!)
//                }
//            }.resume()

        }
    }

}


extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    
    func attributedStirngWith(color:UIColor,size:CGFloat,font:UIFont) -> NSAttributedString{
        
        let attributes = [ NSAttributedString.Key.foregroundColor: color , NSAttributedString.Key.font:font.withSize(size)]
        let attString = NSAttributedString(string: self , attributes: attributes)
        return attString
        
    }
    
    func checkNull() -> String {
        return (self == "<null>" ? "" : self)
    }
    
}

//add tap guesture to UIView
extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}


extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                
                self.addPlaceholder(newValue!)
                
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}


    
//@objc extension UIColor {
//    public convenience init?(hex: String) {
//        let r, g, b, a: CGFloat
//
//        if hex.hasPrefix("#") {
//            let start = hex.index(hex.startIndex, offsetBy: 1)
//            let hexColor = String(hex[start...])
//
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                    a = CGFloat(hexNumber & 0x000000ff) / 255
//
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//
//        return nil
//    }
//}

    

