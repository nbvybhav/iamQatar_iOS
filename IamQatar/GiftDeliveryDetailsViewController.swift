//
//  GiftDeliveryDetailsViewController.swift
//  IamQatar
//
//  Created by anuroop kanayil on 27/08/19.
//  Copyright © 2019 alisons. All rights reserved.
//

import UIKit

@objc class GiftDeliveryDetailsViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate,UITabBarDelegate {

    //MARK:- OUTLETS
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var deliveryDateCollectionView: UICollectionView!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    @IBOutlet weak var btnCheckOut: UIButton!
    @IBOutlet weak var mainContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgOther: UIImageView!
    @IBOutlet weak var imgSelf: UIImageView!
    
    @IBOutlet weak var datePickerContViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePickerMainContView: UIView!
    @IBOutlet weak var txtViewPersonalNote: UITextView!
    @IBOutlet weak var datePickerContView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    //MARK:- VARIABLES
    var selectedDateIndex = 0
    var selectedTimeIndex = 0
    var timeArray = NSArray()
    var dateArray = [Date]()
    
    var productId = ""
    //var availableTimeSlots = NSArray()
    var minimumAvailableDate = ""
    var minimumAvailableTime = ""
    var currentDate = ""
    
    var deliverToSelf = true
    
    //MARK:- VIEW DID LOADC
    override func viewDidLoad() {
        super.viewDidLoad()

        //observer for keyboard show hide notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        self.deliveryDateCollectionView.register(UINib(nibName: "TagsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagsCollectionViewCell")
        self.timeCollectionView.register(UINib(nibName: "TagsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagsCollectionViewCell")
        
        
        self.timeArray = (UserDefaults.standard.value(forKey: "giftTimeArray") ?? []) as! NSArray
        self.minimumAvailableDate = "\(UserDefaults.standard.value(forKey: "minimumAvailableDateForGiftDelivery") ?? "")"
        self.minimumAvailableTime = "\(UserDefaults.standard.value(forKey: "minimumAvailableTimeForGiftDelivery") ?? "")"
        self.currentDate = "\(UserDefaults.standard.value(forKey: "currentDate") ?? "")"
        self.productId = "\(UserDefaults.standard.value(forKey: "giftId") ?? "")"
        
        
        
        print("gift delivery time array : ",timeArray)
        print("minimumAvailableTimeForGiftDelivery : ",minimumAvailableTime)
        print("minimumAvailableDateForGiftDelivery : ",minimumAvailableDate)
        
        print(self.currentDate)
        if let currentDate = self.convertStringToDate(dateString: self.currentDate){
            let deliveryStartDate = currentDate.adding(.day, Int(minimumAvailableDate) ?? 0)
            self.dateArray = [deliveryStartDate,deliveryStartDate?.dayAfter,deliveryStartDate?.dayAfter.dayAfter] as! [Date]
            self.datePicker.minimumDate = deliveryStartDate?.adding(.day, 2)
            
        }
        
        
        print(dateArray)
        
        self.setUi()
        self.setContentViewHeight()
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.deliveryDateCollectionView.reloadData()
    }
    
    
    //MARK:- METHODS
    func setUi(){
        
        self.btnCheckOut.addGradient(colorOne: Colors.gradStartNew, colorTwo: Colors.gradEndNew)
        
        self.deliverToSelf = true
        self.imgSelf.image = #imageLiteral(resourceName: "checked-1")
        self.imgOther.image = #imageLiteral(resourceName: "checkbox_off")
        self.datePickerMainContView.isHidden = true
        
        self.datePickerMainContView.addTapGestureRecognizer {
            self.showDatePicker(false)
        }
        
        self.txtViewPersonalNote.text = ""
        
        self.txtViewPersonalNote.delegate = self
        
        self.hideKeyboard()
        

        
    }
    
    func setContentViewHeight(){
        
        self.view.layoutIfNeeded()
        self.mainContentViewHeightConstraint.constant = self.btnCheckOut.frame.origin.y + self.btnCheckOut.frame.height + 50 + 20
        
    }
    
    func showDatePicker(_ yeah : Bool){
        
        if yeah{
            
            self.datePickerMainContView.isHidden = false
            self.datePickerMainContView.alpha = 0
            self.datePickerContViewBottomConstraint.constant = -self.datePickerContView.frame.height
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.datePickerContViewBottomConstraint.constant = 0
                self.datePickerMainContView.alpha = 1
                self.view.layoutIfNeeded()
            }) { (true) in
                self.datePickerMainContView.isHidden = false
            }
            
            
        }else{
            
            self.datePickerMainContView.isHidden = false
            self.datePickerMainContView.alpha = 1
            self.datePickerContViewBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.datePickerMainContView.alpha = 0
                self.datePickerContViewBottomConstraint.constant = -self.datePickerContView.frame.height
                self.view.layoutIfNeeded()
            }) { (true) in
                self.datePickerMainContView.isHidden = true
            }
            
        }
        
    }
 
    
    func convertStringToDate(dateString:String) -> Date? {
       
        if dateString != "null" || dateString != "<null>" || dateString != ""{
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"//"yyyy-MM-dd HH:mm:ss"
            guard let date = dateFormatter.date(from: dateString) else { return nil }
            return date
        
        }else{
            return nil
        }
    }
    
    func convertDateToString(date:Date) -> String {
       
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-MM-dd"//2019-09-25

        return  dateFormatter.string(from: date)
        
    }
    
    func monthNameFrom(date:Date) -> String{
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MMMM"
        return  dateFormatter.string(from: date)
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
    
    //MARK:- BTN ACTIONS
    @IBAction func addToCartAction(_ sender: UIButton) {
        
        //data need to perform add to cart api from product details page : user_id, product_id, quantity, personal_message, delivery_date, variant_id,deliveryto
        print("time index : ",self.selectedTimeIndex)
        print("date index : ",self.selectedDateIndex)
        print("time array : ",self.timeArray)
        print("date array : : ",self.dateArray)
        
        var deliveryDate = ""
        if self.selectedDateIndex <= self.dateArray.count{
           deliveryDate = self.convertDateToString(date: self.dateArray[self.selectedDateIndex])
        }
        
        let giftData = ["personal_message":self.txtViewPersonalNote.text ?? "",
                        "delivery_date":deliveryDate,
                        "deliveryto": self.deliverToSelf ? "self" : "other",
                        "time_id":"\((self.timeArray[self.selectedTimeIndex] as AnyObject).value(forKey: "time_id") ?? "")"]
        
        print(giftData)
        
        UserDefaults.standard.set(giftData, forKey: "selectedGiftData")
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func CheckBoxAction(_ sender: UIButton) {
       
        //tags : self - 10 , other - 20
        
        if sender.tag == 10{//self
            
            self.deliverToSelf = true
            self.imgSelf.image = #imageLiteral(resourceName: "checked-1")
            self.imgOther.image = #imageLiteral(resourceName: "checkbox_off")
            
        }else if sender.tag == 20{//other
            
            self.deliverToSelf = false
            self.imgSelf.image = #imageLiteral(resourceName: "checkbox_off")
            self.imgOther.image = #imageLiteral(resourceName: "checked-1")
            
        }
        
    }
    
    @IBAction func datePicekerDoneAction(_ sender: UIButton) {
        self.showDatePicker(false)
        self.dateArray.removeLast()
        self.dateArray.append(self.datePicker.date)
        self.selectedDateIndex = 2
        self.deliveryDateCollectionView.reloadData()
    }
    
    //MARK:- COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.deliveryDateCollectionView{
            return self.dateArray.count + 1
        }
        
        return self.timeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsCollectionViewCell
        cell.mainContentView.backgroundColor = UIColor.white
        
        cell.mainContentView.addBorder(0.5, Colors.mainTxtColor.withAlphaComponent(0.3))
        //cell.addBorder(0.5, Colors.mainTxtColor.withAlphaComponent(0.5))
        cell.layoutIfNeeded()
        
        
        
        //data
        if collectionView == self.deliveryDateCollectionView{//date
            
            cell.lblTitle.isHidden = false
            if indexPath.row == self.dateArray.count{
                cell.calendarContView.isHidden = false
                cell.lblTitle.isHidden = true
                cell.lblItem.isHidden = true
            }else{
                
                let date = self.dateArray[indexPath.row]
                
                var dayName = ""
                
                switch convertDateToString(date:date) {
                case convertDateToString(date: Date()) :
                    dayName = "Today"
                case convertDateToString(date: Date.tomorrow) :
                    dayName = "Tomorrow"
                case convertDateToString(date: Date.tomorrow.dayAfter) :
                    dayName = "Day After"
                default:
                    dayName = self.monthNameFrom(date: date)
                }
                
                
                cell.lblTitle.text = dayName
                cell.lblItem.text = "\(date.day)"
                cell.lblItem.font = cell.lblItem.font.withSize(20)
//                cell.lblItem.attributedText = dayName.attributedStirngWith(color: cell.lblItem.textColor, size: 12, font: UIFont.systemFont(ofSize: 10, weight: .regular)) + "\(dayName == "" ? "" : "\n")\(date.day)".attributedStirngWith(color: cell.lblItem.textColor, size: 22, font: UIFont.systemFont(ofSize: 10, weight: .bold))
                
                cell.calendarContView.isHidden = true
                cell.lblTitle.isHidden = false
                cell.lblItem.isHidden = false
            }
            
        }else{//time
            
            cell.calendarContView.isHidden = true
            cell.lblTitle.isHidden = true
            
            cell.lblItem.text = "\((self.timeArray[indexPath.row] as AnyObject).value(forKey: "start_time") ?? "")" + " - " + "\((self.timeArray[indexPath.row] as AnyObject).value(forKey: "expiry_time") ?? "")"
            
        }
        
        
        //design
        let selected = collectionView == self.deliveryDateCollectionView ? self.selectedDateIndex : self.selectedTimeIndex
        if indexPath.row == selected{
            cell.mainContentView.addGradient(colorOne: Colors.gradStartNew, colorTwo: Colors.gradEndNew)
            cell.lblItem.textColor = UIColor.white
            cell.lblTitle.textColor = cell.lblItem.textColor
        }else{
            cell.layoutIfNeeded()
            cell.mainContentView.addGradient(colorOne: UIColor.clear, colorTwo: UIColor.clear)
            cell.removeGradient()
            
            cell.lblItem.textColor = UIColor.darkGray//Colors.mainTxtColor
            cell.lblTitle.textColor = cell.lblItem.textColor
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.deliveryDateCollectionView{//date
            //let side = collectionView.frame.height
            self.view.layoutIfNeeded()
            let width = (collectionView.frame.width / 4) - 7
            return CGSize(width: width, height: collectionView.frame.height)
            
        }else{
            
            let label = UILabel()
            
            label.text = "\((self.timeArray[indexPath.row] as AnyObject).value(forKey: "start_time") ?? "")" + " - " + "\((self.timeArray[indexPath.row] as AnyObject).value(forKey: "expiry_time") ?? "")"
            
            self.timeCollectionView.layoutIfNeeded()
            let width = label.intrinsicContentSize.width
            print("time colleciton cell width : ",width)
            return CGSize(width: 165, height: collectionView.frame.height)//CGSize(width: width <= 50 ? 50 : width, height: collectionView.frame.height)
           
        }
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 0,left: 8,bottom: 0,right: 8)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.deliveryDateCollectionView{
            
            
            if indexPath.row == self.dateArray.count{
                self.showDatePicker(true)
            }else{
                self.selectedDateIndex = indexPath.row
            }
            
        }else{//time
            self.selectedTimeIndex = indexPath.row
        }
        
        self.deliveryDateCollectionView.reloadData()
        self.timeCollectionView.reloadData()
        
    }
    
    //MARK:- TEXT VIEW DELEGATE
//    textViewShouldRet


}
//        if self.timeArray.count == 0{
//            self.timeArray = (UserDefaults.standard.value(forKey: "giftTimeArray") ?? []) as! NSArray
//        }
//
//        if self.minimumAvailableDate == ""{
//            self.minimumAvailableDate = "\(UserDefaults.standard.value(forKey: "minimumAvailableDateForGiftDelivery") ?? "")"
//        }
//
//        if self.minimumAvailableTime == ""{
//            self.minimumAvailableTime = "\(UserDefaults.standard.value(forKey: "minimumAvailableTimeForGiftDelivery") ?? "")"
//        }
//
//        if self.currentDate == ""{
//            self.currentDate = "\(UserDefaults.standard.value(forKey: "currentDate") ?? "")"
//        }
//        if self.productId == ""{
//            self.currentDate = "\(UserDefaults.standard.value(forKey: "currentDate") ?? "")"
//        }
