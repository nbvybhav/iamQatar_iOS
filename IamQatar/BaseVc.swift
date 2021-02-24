//
//  BaseVc.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 06/02/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import Foundation

class BaseViewController : UIViewController{
   
    //MARK:- VARIABLES
    var backBtnAction = {()}
    var menuView : Menu?
    var isMenuEnabled = false
    
    //MARK:- VIEW DID LOAD
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.delegate = self
        _ = UIApplication.shared.isKeyboardPresented
        
        KeyboardStateListener.shared.start()
        
//        let navigationStack = self.navigationController?.viewControllers
//        if navigationStack?.count == 1{
//
//            self.tabBarController?.tabBar.subviews[4].isHidden = true
//
//        }else{
//            self.tabBarController?.tabBar.subviews[4].isHidden = false
//        }
        
        
    }
    
    override func viewDidLoad() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        self.setUpSideMenu()
        self.setupTapGesture()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.setMenuEnabled(false)
        
    }
    
    //MARK:- METHODS
    
    private func setUpSideMenu(){
        
        self.menuView = UINib(nibName: "Menu", bundle: nil).instantiate(withOwner: self, options: nil).first as? Menu
        menuView?.frame = CGRect(x: -275, y: 0, width: 275, height: self.view.frame.height)
        menuView?.isHidden = true
        menuView?.delegate = self
        self.tabBarController?.view.addSubview(menuView!)
        
        menuView?.tag = 1234
        
        self.backBtnAction = {
            
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    private func setupTapGesture(){
        
//        for recognizer in self.view.gestureRecognizers ?? [] {
//            self.view.removeGestureRecognizer(recognizer)
//        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        swipeLeft.delegate = self
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        self.setMenuEnabled(false)
    }
    
    func setMenuEnabled(_ yeah:Bool){
        
        if yeah{
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            UIView.animate(withDuration: 0.2, animations: {
                self.menuView?.isHidden = false
                self.menuView?.frame = CGRect(x: 0, y: 0, width: 275, height: self.view.frame.height)
            }) { (true) in
                self.isMenuEnabled = true
            }
            
        }else{
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            UIView.animate(withDuration: 0.2, animations: {
                self.menuView?.frame = CGRect(x: -275, y: 0, width: 275, height: self.view.frame.height)
            }) { (true) in
                self.menuView?.isHidden = true
                self.isMenuEnabled = false
            }
        }
    }
}


extension BaseViewController: UITabBarControllerDelegate {
    
    //for back button to work, ovverride tab selection action in all view controllers
    //confirm to tabbarcontroller delegate in viewWillAppear , coz some vc will have diffrent actions for back btn tap
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        //if viewController == self.tabBarController?.viewControllers?[3]{
            //Utility.exitAlert(self)
            
            //self.backBtnAction()
            //return false
        //}
        
        if viewController == self.tabBarController?.viewControllers?[0]{
            
            if self.isMenuEnabled{
                
                self.setMenuEnabled(false)
                
            }else{
                
                self.setMenuEnabled(true)
            }
       
            return false
        }
        
        return true
        
    }
}

extension BaseViewController : PopMenuDelegate{
    
    //MARK:- POPUP DELEGATE
    func todaysDeal(_ sender: Menu!) {
        print("kola")
    }
    
    func whatsNew(_ sender: Menu!) {
        print("kaba")
    }
    
    func emergencyContact(_ sender: Menu!) {
        
    }
    
    func contest(_ sender: Menu!) {
        
        let isSkip = Utility.getfromplist("skippedUser", plist: "iq")
        if isSkip == "YES"{
            
            AlertController.alert(withMessage: "Please login to continue", presenting: self)
            
        }else{
            let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "contestView") as! contestViewController
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
    }
    
    func goAboutUsPage(_ sender: Menu!) {
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "aboutUsView") as! AboutUsViewController
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func goProfilePage(_ sender: Menu!) {
//        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "aboutUsView") as! AboutUsViewController
//        self.navigationController?.pushViewController(nextVc, animated: true)
        self.tabBarController?.selectedIndex = 1
    }
    
    func history(_ sender: Menu!) {
        
        let isSkip = Utility.getfromplist("skippedUser", plist: "iq")
        
        if isSkip == "YES"{
            
            AlertController.alert(withMessage: "Please login to continue", presenting: self)
            
            
        }else{
            let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "OrderHistoryNewViewController") as! OrderHistoryNewViewController
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
        
        
    }
    
    func contactUs(_ sender: Menu!) {
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func goTerms(ofUse sender: Menu!) {
        
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsVC") as! TermsAndConditionsVC
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func logOut(_ sender: Menu!) {
        
        Utility.addtoplist("", key: "login", plist: "iq")
        Utility.addtoplist("NO", key: "skippedUser", plist: "iq")
        
        self.navigationController?.popToRootViewController(animated: false)
        self.tabBarController?.selectedIndex = 2
        //self.navigationController?.popToRootViewController(animated: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        
    }
    
    
}


extension BaseViewController : UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if self.isMenuEnabled {

            if touch.view?.isDescendant(of: self.menuView!) ?? false{
                return false
            }
            return true

        }
        
//        if UIApplication.shared.isKeyboardPresented{
//            return true
//        }
        
        if KeyboardStateListener.shared.isVisible{
            return true
        }
        
        return false
    }
    
}


extension UIApplication {
    /// Checks if view hierarchy of application contains `UIRemoteKeyboardWindow` if it does, keyboard is presented
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"),
            self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}


class KeyboardStateListener: NSObject {
  
    static var shared = KeyboardStateListener()
    var isVisible = false
    
    var keybordDidShowAction = {()}
    var keyboardDidHideAction = {()}

    func start() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(didShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(didHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func didShow() {
        isVisible = true
        self.keybordDidShowAction()
    }

    @objc func didHide() {
        isVisible = false
        self.keyboardDidHideAction()
    }
    
}


//class ShowHideBackBtnViewController : UIViewController{
//
//
//
//
//}
