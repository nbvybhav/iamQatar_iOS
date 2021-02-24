//
//  SuccessViewController.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 04/02/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class SuccessViewController: BaseViewController {

    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        
        self.view.layoutIfNeeded()
        self.btnContinue.addGradient(colorOne: nil, colorTwo: nil)
        
        self.bgView.layer.shadowColor = UIColor.darkGray.cgColor
        self.bgView.layer.shadowRadius = 10
        
        
        self.backBtnAction = {
            
            self.tabBarController?.selectedIndex = 2
            
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController?.delegate = self
//    }

    @IBAction func continueAction(_ sender: UIButton) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
           self.gotoFirstVc()
        }
        
        NotificationCenter.default.post(Notification(name: Notification.Name("DEL_SUCCESS_NOTI"), object: nil, userInfo: nil))
        
        //UserDefaults.standard.setValue(true, forKey: "GOTO_MARKET")
        //self.tabBarController?.selectedIndex = 2
    
//        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "marketView") as! MarketViewController
//        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.gotoFirstVc()
    }
    
}


extension UIViewController{
    
    @objc func gotoFirstVc(){
        var navgationStack = self.navigationController?.viewControllers
        let count = (navgationStack?.count ?? 1)
        navgationStack?.removeLast(count - 1)
        self.navigationController?.viewControllers = navgationStack!
    }
    
    
}

//extension SuccessViewController: UITabBarControllerDelegate {
//
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
//        if viewController == self.tabBarController?.viewControllers?[3]{
//            self.tabBarController?.selectedIndex = 2
//            return false
//        }
//        return true
//
//    }
//
//}
