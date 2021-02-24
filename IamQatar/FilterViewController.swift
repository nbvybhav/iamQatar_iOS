//
//  FilterViewController.swift
//  IamQatar
//
//  Created by User on 16/01/21.
//  Copyright © 2021 alisons. All rights reserved.
//

import UIKit
import SpriteKit

class FilterViewController: BaseViewController {
    @IBOutlet weak var filterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK:- Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            if touch.view != filterView{
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
