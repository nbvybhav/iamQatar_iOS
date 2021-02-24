//
//  CartNewViewController.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 23/01/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class CartNewViewController: BaseViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var priceContView: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var cartEmptyView: UIView!
    
    //MARK:- VARIABELS
    var responseDict = NSDictionary()
    var responseCartArray = NSArray()
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUi()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.tabBarController?.delegate = self
        self.getCart()
        
    }
    
    //MARK:- API CALL
    func getCart(){
    
        self.mainContentView.isHidden = true
        
        let apiService = ApiService.shared
        
        apiService.urlString = parentURL + getCartItems
        apiService.target = self
        
        let paramter = ["user_id":userId()]
     
        apiService.parameter = paramter as [String : Any]
        
        apiService.fetchData { (responseDict, error) in
            
            if error == nil, let responseDict = responseDict{
                
                print(responseDict)
                self.responseDict = responseDict
                self.setContentView()
                
            }
            
        }
        
    }
    
    func editCart(cartId:String,qty:String){
    
        let apiService = ApiService.shared
        
        apiService.urlString = qty == "0" ? (parentURL + removeFromCart) : (parentURL + updateCart)
        apiService.target = self
        
        let paramter = ["user_id":userId(),
                        "quantity":qty,
                        "cart_id":cartId]

        print(paramter)
        print(parentURL + updateCart)
    
        apiService.parameter = paramter// as [String : Any]
        
        apiService.fetchData { (responseDict, error) in
            
            if error == nil, let responseDict = responseDict{
                
                print(responseDict)
                self.responseDict = responseDict
                self.setContentView()
                 
                let cartCount = "\((responseDict.value(forKey: "count") as AnyObject).value(forKey: "count") ?? "")"
                
                self.tabBarController?.tabBar.items?.last?.badgeValue = cartCount == "0" ? nil : cartCount
                
            }
        }
    }
    
    
    
    //MARK:- METHODS
    func setUi(){
     
        
        self.mainContentView.isHidden = true
        self.cartEmptyView.isHidden = true
        
        self.navigationItem.title = "SHOPPING CART"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        
        
        self.cartTableView.delegate = self
        self.cartTableView.dataSource = self
        
        self.cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        
        //self.tabBarItem.image = #imageLiteral(resourceName: "cartxxhdpi")//UIImage(named:"cart.png")
        //self.tabBarItem.selectedImage = #imageLiteral(resourceName: "menuxxhdpi")//UIImage(named:"cart.png")
        
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        
        self.priceContView.layer.shadowColor = UIColor.lightGray.cgColor
        self.priceContView.layer.shadowRadius = 8
        self.priceContView.layer.shadowOpacity = 0.6
        
        self.cartTableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 24, right: 0)
        
        self.view.layoutIfNeeded()
        self.btnContinue.addGradient(colorOne: nil, colorTwo: nil)
        
        
        self.backBtnAction = {
            
            Utility.exitAlert(self)
            
            
        }
        
    }
    
    func setContentView() {
         
        let enableOnlinePayment = "\(self.responseDict.value(forKey: "enable_online_payment") ?? "")"
        UserDefaults.standard.setValue(enableOnlinePayment, forKey: PreferenceKeys.ENABLE_ONLINE_PAYMENT)
        
        if let cartArray = self.responseDict.value(forKey: "value") as? NSArray{
            self.responseCartArray = cartArray
            cartEmpty(cartArray.firstObject == nil)
        }else{
            cartEmpty(true)
        }
        
        self.cartTableView.reloadData()
        
        self.lblTotalPrice.text = price("\((self.responseDict.value(forKey: "cart_total") as AnyObject).value(forKey: "grandtotal") ?? "")")
        
        //self.mainContentView.isHidden = false
        
    }
    
    func cartEmpty(_ yeah:Bool){
        
        if yeah{
            self.cartEmptyView.isHidden = false
            self.mainContentView.isHidden = true
        }else{
            self.cartEmptyView.isHidden = true
            self.mainContentView.isHidden = false
        }
        
    }
    
    
    //MARK:- BTN ACTTIONS
    @IBAction func continueAction(_ sender: UIButton) {
        
        let isSkip = Utility.getfromplist("skippedUser", plist: "iq")
        if isSkip == "YES"{
            Utility.guestUserAlert(self)
            
        }else{
            let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
            nextVc.responseDict = self.responseDict
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
        

        
    }
    
//    func updateCartAction(){
//
//    }
    
    @IBAction func continueShoppingAction(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 2
//        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
//        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
}

extension CartNewViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.responseCartArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell
        
        if let cartData = self.responseCartArray[indexPath.row] as? NSDictionary {
            
            cell.cartData = cartData
            
            //add
            cell.btnPlus.addTapGestureRecognizer {
                    
                let availableStock = Int("\((cartData.value(forKey: "product_details") as AnyObject).value(forKey: "stock_quantity") ?? "")") ?? 0
                
                let currentQty = Int(cell.lblCount.text!) ?? 0
                
                if (availableStock > (currentQty)){
                    
                    cell.lblCount.text = "\(Int(cell.lblCount.text!)! + 1)"
                    self.editCart(cartId: "\(cartData.value(forKey: "cart_id") ?? "")", qty: "\(cell.lblCount.text ?? "")")
                    
                }else{
                    AlertController.alert(withMessage: "No more stock availabe", presenting: self)
                }
                
                
            }
            
            //minus
            cell.btnMinus.addTapGestureRecognizer {
                
                if cell.lblCount.text != "1"{
                    cell.lblCount.text = "\(Int(cell.lblCount.text!)! - 1)"
                }
                
                self.editCart(cartId: "\(cartData.value(forKey: "cart_id") ?? "")", qty: "\(cell.lblCount.text ?? "")")
            }

            //remove
            cell.btnRemove.addTapGestureRecognizer {
                
                //if cell.lblCount.text != "1"{
                    cell.lblCount.text = "0"
                //}
                
                self.editCart(cartId: "\(cartData.value(forKey: "cart_id") ?? "")", qty: "\(cell.lblCount.text ?? "")")
            }
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

//extension CartNewViewController {
//
//
//    //for back button to work, ovverride tab selection action in all view controllers
//    //confirm to tabbarcontroller delegate in viewWillAppear , coz some vc will have diffrent actions for back btn tap
//
//    override func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        _ = super.tabBarController(tabBarController, shouldSelect: viewController)
//
//        if viewController == self.tabBarController?.viewControllers?[3]{
//            Utility.exitAlert(self)
//            return false
//        }
//
//
////        if viewController == self.tabBarController?.viewControllers?[0]{
////
//////            menu= [[Menu alloc]init];
//////            NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"Menu" owner:self options:nil];
//////            menu = [nib1 objectAtIndex:0];
//////            menu.frame=CGRectMake(-290, 0, 275,deviceHieght);
//////            menu.delegate = self;
//////            [self.tabBarController.view addSubview:menu];
//////            menuHideTap.enabled = NO;
        //[menu setHidden:YES];
////
////            let menuView = UINib(nibName: "Menu", bundle: nil).instantiate(withOwner: self, options: nil).first as? Menu
////            menuView?.frame = CGRect(x: 0, y: 0, width: 275, height: self.view.frame.height)
////            menuView?.delegate = self
////            self.view.addSubview(menuView!)
////
////            return false
////        }
//
//
//        return true
//
//    }
//}
//
//
