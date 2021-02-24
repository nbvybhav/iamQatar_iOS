//
//  GiftsListViewController.swift
//  IamQatar
//
//  Created by anuroop kanayil on 22/08/19.
//  Copyright © 2019 alisons. All rights reserved.
//

import UIKit
import Alamofire
import SpriteKit

class GiftsListViewController: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITabBarDelegate {
    
    //MARK:- OUTLETS
    @IBOutlet weak var giftCatCollectionView: UICollectionView!
    @IBOutlet weak var shopByOccationCollectionView: UICollectionView!
    @IBOutlet weak var giftsListCollectionView: UICollectionView!
   
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var filterOptionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterOptionCollectionView: UICollectionView!
    @IBOutlet weak var filterOptionView: UIView!
    @IBOutlet weak var shopByOccationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var giftListViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var shopByOccationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var catViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var giftListContView: UIView!
    @IBOutlet weak var lblListTitle: UILabel!
    @IBOutlet weak var lblShopByCategory: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpContentView: UIView!
    @IBOutlet weak var popUpTableView: UITableView!
    @IBOutlet weak var clearAllView: UIView!
    @IBOutlet weak var lblPopUpHeading: UILabel!
    @IBOutlet weak var popUpBottomButtonViewHeightConstraint: NSLayoutConstraint!//80//0
    @IBOutlet weak var popUpTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var popUpViewheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var occationView: UIView!
    @IBOutlet weak var shopByStroreOrCategoryView: UIView!
    
    @IBOutlet weak var popUpHeadingHeightConstraint: NSLayoutConstraint!
    
    //MARK:- VARIABLES
    
    var giftCatId = ""
    var occationId = ""
    var shopId = ""
    var giftListResponse : GiftListResponse?
    var shoulShowStore = true
    var filterOrSortBy = ""
    var sortby = ""
    var sort_order = ""
    var query = ""
//    var sortOptions = ["popularity","Price - Low to High","Price - High to Low", "name" , "rating"]
    var sortOptions = ["product_name","price","price"]
    var sortOrders = ["asc","asc","desc"]
    var sortOptionsNames = [NSLocalizedString("Name", comment: ""),NSLocalizedString("Price - Low to High", comment: ""),NSLocalizedString("Price - High to Low", comment: "")]
    var sortImages = ["Sort_Name","Sort_LowToHigh","Sort_HighToLow"]
//    var sortOptionsNames = [NSLocalizedString("Popularity", comment: ""),NSLocalizedString("Price - Low to High", comment: ""),NSLocalizedString("Price - High to Low", comment: ""),NSLocalizedString("Name", comment: ""),NSLocalizedString("Rating", comment: "")]
    let tableViewCellHeight = 50
    var selectedSortRow = 10
    var filterSelectedIndexPath = 0
    var filterOption = false
    var filterCount = 0
    var filterId = [Int]()
    var filterOptionData = [[String]]()
    var filterOptionDataOrg = [[String]]()
    var filterSelectedArray = [String]()
    var filterIdOrg = [Int]()
    var navigationItemTitle = "GIFTS"
    var filterOptionDelete = false
    var noRecord = false
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.txtSearch.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 50, y: 0, width: 15, height: 15))
        let image = UIImage(named: "search")
        self.txtSearch.leftView = imageView
        self.txtSearch.delegate = self
        self.txtSearch.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        
        imageView.image = image
        self.popUpView.isHidden = true
        if let sdkVersion = Bundle(for: GiftsListViewController.self).infoDictionary?["CFBundleShortVersionString"] {
            print(sdkVersion)
        }
        
        print(self.giftCatId)
//        self.popUpContentView.layer.cornerRadius = ((self.popUpContentView.frame.size.width) / 2) - 170
        self.popUpContentView.layer.cornerRadius = 15
        self.lblShopByCategory.text = self.shoulShowStore ? "Shop by Store" : "Search By Category"
        self.shopByOccationViewHeightConstraint.constant = 0
        self.occationView.isHidden = true
//        self.navigationItem.title = "GIFTS"
        self.navigationItem.title = self.navigationItemTitle
        //self.navigationItem.hidesBackButton = true

        self.tabBarController?.tabBar.subviews[3].isHidden = false
        self.tabBarController?.delegate = self
        
        self.giftCatCollectionView.register(UINib(nibName: "GiftBoxCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftBoxCategoriesCollectionViewCell")
        self.shopByOccationCollectionView.register(UINib(nibName: "TagsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagsCollectionViewCell")
        self.filterOptionCollectionView.register(UINib(nibName: "FilterOptionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FilterOptionCollectionViewCell")
        self.giftsListCollectionView.register(UINib(nibName: "GiftListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftListCollectionViewCell")
        self.popUpTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.getGiftItems()
        //self.getGiftItemsAlamofire()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.subviews[4].isHidden = false
        self.tabBarController?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    //MARK:- API CALL
    func getGiftItems(){
        
        let progressHUD = ProgressHUDD(text: "")
        self.view.addSubview(progressHUD)
        
        //check internet connection
        guard Reachability.isConnectedToNetwork() else {
            progressHUD.hide()
            //noNetworkAlert(presenting: vc)
            AlertController.alert(withMessage: "Network connection not available!", presenting: self)
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let userId = appDelegate.userProfileDetails.value(forKey: "user_id") ?? ""
        
        
        //category_id, user_id,occasion_id,shop_id
        
        //let url = parentURL + giftItemsUrl + "&category_id=\(self.giftCatId)&user_id=\(userId)&occasion_id=\(self.occationId)&shop_id=\(self.shopId)"
        
        var paramsString = "&user_id=\(userId)"
        if self.giftCatId  != ""{
            paramsString = paramsString + "&category_id=\(self.giftCatId)"
        }
        
        if self.occationId  != ""{
            paramsString = paramsString + "&occasion_id=\(self.occationId)"
        }
        
        if self.shopId  != ""{
            paramsString = paramsString + "&shop_id=\(self.shopId)"
        }
        
        if self.sortby != ""{
            paramsString = paramsString + "&sortby=\(self.sortby)"
        }
        
        if self.sort_order != ""{
            paramsString = paramsString + "&sort_order=\(self.sort_order)"
        }
        
        if self.query != ""{
            paramsString = paramsString + "&query=\(self.query)"
        }
        
        if self.filterIdOrg.count != 0{
            var filterOption = "["
            filterOption += "\(self.filterIdOrg[0])"
            if self.filterIdOrg.count > 1{
                for i in 1...(self.filterIdOrg.count - 1){
            //                let data = self.filterId[i]
                    filterOption += ","
                    filterOption += "\(self.filterIdOrg[i])"
                }
            }
            filterOption += "]"
            paramsString = paramsString + "&filter_id=\(filterOption)"
        }
        
        let url = parentURL + giftItemsUrl + paramsString
        
        print(url)
        guard let serviceUrl = URL(string: url) else { return }
        let parameterDictionary = [:] as NSDictionary
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("text/html; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
//            if let response = response {
//                print(response)
//            }
            
            if let data = data {
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    print(json)
                    
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(GiftListResponse.self, from: data)
                    
//                    print(response)
                    
                    self.giftListResponse = response
                    
                    print(self.giftListResponse!)
                    if self.giftListResponse?.text == "No records found"{
//                        self.catViewHeightConstraint.constant = 0
//                        self.giftCatCollectionView.isHidden = true
                        self.noRecord = true
                        let alert = UIAlertController(title: "", message: "No records found", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "ok", style: .default) { (action) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(ok)
                        self.present(alert,animated: true)
                    }
                    DispatchQueue.main.async {
                        progressHUD.hide()
                        self.setContentView()
                    }
                    
                } catch {
                    print("data convert to model class error : ",error)
                    progressHUD.hide()
                }
            }
        }.resume()
        self.filterOptionDelete = false
    }
    
    
    //MARK:- METHODS
    
    func setContentView(){

        self.giftCatCollectionView.reloadData()
        self.shopByOccationCollectionView.reloadData()
        self.giftsListCollectionView.reloadData()

        self.clearAllView.addBorder(1, .lightGray)
        //print(response)


        if self.shoulShowStore{
            let catCount = self.giftListResponse?.shop?.count ?? 0
            if catCount > 1 && !self.noRecord{
                self.catViewHeightConstraint.constant = 150
                self.giftCatCollectionView.isHidden = false
            }else{
                self.catViewHeightConstraint.constant = 0
                self.giftCatCollectionView.isHidden = true
            }
        }else{
            if self.giftListResponse?.category?.count ?? 0 == 0 || self.noRecord{
                self.catViewHeightConstraint.constant = 0
                self.giftCatCollectionView.isHidden = true
            }else{
            self.catViewHeightConstraint.constant = 150
            self.giftCatCollectionView.isHidden = false
            }
        }
        if self.filterSelectedArray.count == 0{
            self.filterOptionViewHeightConstraint.constant = 0
            self.filterOptionView.isHidden = true
        }else{
            self.filterOptionViewHeightConstraint.constant = 40
            self.filterOptionView.isHidden = false
        }
        self.filterOptionCollectionView.reloadData()
        let selectedCatName = self.giftListResponse?.category?.filter{"\($0.catID ?? -1)" == self.giftCatId}.first?.name ?? ""
        let selectedOccationName = self.giftListResponse?.occasion?.filter{"\($0.occaID ?? -1)" == self.occationId}.first?.name ?? ""
        //self.lblListTitle.text = "\(selectedCatName + (selectedOccationName == "" ? "" : " for \(selectedOccationName)"))"

        self.lblListTitle.text = selectedCatName == "" ? selectedOccationName : "\(selectedCatName + (selectedOccationName == "" ? "" : " for \(selectedOccationName)"))"

        self.setContentViewHeight()


    }
    
    func setContentViewHeight(){
        
        self.view.layoutIfNeeded()
        self.giftListViewHeightConstraint.constant = self.giftsListCollectionView.contentSize.height + 45
        self.view.layoutIfNeeded()
        let height1 = self.catViewHeightConstraint.constant + self.filterOptionViewHeightConstraint.constant
        //self.mainContentViewHeightConstraint.constant = self.catViewHeightConstraint.constant + self.shopByOccationViewHeightConstraint.constant +  self.giftListViewHeightConstraint.constant + 12 + 60
        self.mainContentViewHeightConstraint.constant = height1 + self.shopByOccationViewHeightConstraint.constant +  self.giftListViewHeightConstraint.constant + 12 //+ 60
        let filterCount = self.giftListResponse?.filters?.count ?? 0
        if filterCount != 0{
            for _ in 0...((self.giftListResponse?.filters!.count)! - 1){
                
                self.filterOptionData += [self.filterSelectedArray]
                self.filterOptionDataOrg += [self.filterSelectedArray]
            
            }
        }
        print(self.filterOptionData)
        print(self.filterOptionDataOrg)
    }
    func filterAction(){
        
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //        let nextVc = storyBoard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        //        self.present(nextVc,animated: true)
                self.lblPopUpHeading.text = "FILTERS"
                self.filterOrSortBy = "FILTERS"
                self.popUpBottomButtonViewHeightConstraint.constant = 80
                self.filterCount = self.giftListResponse?.filters?.count ?? 0
                print(filterCount)
                self.popUpTableViewHeightConstraint.constant = CGFloat((filterCount * self.tableViewCellHeight) + 1)
                self.popUpViewheightConstraint.constant = self.popUpHeadingHeightConstraint.constant + self.popUpTableViewHeightConstraint.constant + self.popUpBottomButtonViewHeightConstraint.constant + 5 + 8
                UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.popUpView.isHidden = false
                    })
        //        self.popUpView.isHidden = false
                self.popUpTableView.reloadData()
            }
    
    func removeFiltrOption(name:String,index:Int){
        
        let filterCount = self.giftListResponse?.filters?.count ?? 0
        var deleted = false
        for i in 0...(filterCount - 1) {
            let valueCount = (self.giftListResponse?.filters?[i].values?.count)!
            for j in 0...(valueCount - 1){
                let valueName = self.giftListResponse?.filters?[i].values?[j].name
                
                if valueName == name{
                    
                    let id = self.giftListResponse?.filters?[i].values?[j].id
                    
                    if self.filterIdOrg.contains(id!){
                        let indexx = self.filterIdOrg.firstIndex(of: id!)!
                        self.filterIdOrg.remove(at: indexx)
                    }
                    
                    let selectedFilterCount = self.filterOptionData.count
                    for i in 0...(selectedFilterCount - 1){
                        if self.filterOptionData[i].contains(name){
                            let indexxx = self.filterOptionData[i].firstIndex(of: name)!
                            self.filterOptionData[i].remove(at: indexxx)
                            deleted = true
                            break
                        }
                    }
                }
                if deleted{
                    break
                }
            }
            if deleted{
                break
            }
        }
        if deleted{
            self.filterSelectedArray.remove(at: index)
            self.getGiftItems()
        }
        
    }
    //MARK:- COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.giftCatCollectionView{
            
            if self.shoulShowStore{
                return self.giftListResponse?.shop?.count ?? 0
            }else{
                return self.giftListResponse?.category?.count ?? 0
            }
            
        }else if collectionView == self.shopByOccationCollectionView{
            return self.giftListResponse?.occasion?.count ?? 0
        }else if collectionView == self.giftsListCollectionView{
            return self.giftListResponse?.values?.count ?? 0
        }else if collectionView == self.filterOptionCollectionView{
            return self.filterSelectedArray.count
        }
        return 0
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.giftCatCollectionView{//gift cat
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftBoxCategoriesCollectionViewCell", for: indexPath) as! GiftBoxCategoriesCollectionViewCell
            
            if self.shoulShowStore{
                
                cell.lblTitle.isHidden = true
                cell.mainContentView.addBorder(1.0, Colors.mainTxtColor.withAlphaComponent(0.5))
                cell.imgItem.backgroundColor = UIColor.lightGray
                
                let storeData = self.giftListResponse?.shop?[indexPath.row]
                cell.lblTitle.text = storeData?.name
                cell.imgItem.setImage(withUrlString: storeData?.image ?? "")
                    
            }else{
                
                //design
                cell.lblTitle.isHidden = false
                cell.mainContentView.addBorder(0, Colors.mainTxtColor)
                cell.imgItem.backgroundColor = UIColor.lightGray
                
                //data
                let giftCatData = self.giftListResponse?.category?[indexPath.row]
                cell.lblTitle.text = giftCatData?.name
                cell.imgItem.setImage(withUrlString: giftCatData?.image ?? "")
                
            }
      
            return cell
            
        }else if collectionView == self.shopByOccationCollectionView{//shop by occation
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsCollectionViewCell
            
            //design
            self.view.layoutIfNeeded()
            cell.layoutIfNeeded()
            
            if indexPath.row % 3 == 0{
                cell.mainContentView.addGradient(colorOne: Colors.gradOneStartColor, colorTwo: Colors.gradOneEndColor)
            }else if indexPath.row % 3 == 1{
                cell.mainContentView.addGradient(colorOne: Colors.gradThreeStartColor, colorTwo: Colors.gradThreeEndColor)
            }else{
                cell.mainContentView.addGradient(colorOne: Colors.gradTwoStartColor, colorTwo: Colors.gradTwoEndColor)
            }
            
            cell.lblItem.isHidden = false
            cell.mainContentView.addBorder(0, Colors.mainTxtColor)
            
            //data
            let occationData = self.giftListResponse?.occasion?[indexPath.row]
            cell.lblItem.text = occationData?.name
            
            return cell
            
        }else if collectionView == self.filterOptionCollectionView{//filter option
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterOptionCollectionViewCell", for: indexPath) as! FilterOptionCollectionViewCell
            cell.lblFilterOption.text = self.filterSelectedArray[indexPath.row]
            cell.btnDel.addTapGestureRecognizer {
                if !self.filterOptionDelete{
                print("deleting")
                let name = self.filterSelectedArray[indexPath.row]
                self.removeFiltrOption(name: name, index: indexPath.row)
                    self.filterOptionDelete = true
                }
            }
            cell.addBorder(1, .lightGray)
            cell.layer.cornerRadius = 6
            return cell
        }else{//gift list
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftListCollectionViewCell", for: indexPath) as! GiftListCollectionViewCell
            
            let productData = self.giftListResponse?.values?[indexPath.row]
            
            cell.lblGiftName.text = productData?.productName
            cell.lblStore.text = "\(productData?.price ?? -1) QAR"
            cell.lblStore.textColor = .lightGray
            cell.imgGift.setImage(withUrlString: productData?.imgDefault ?? "")
            
            cell.lblSoldOut.isHidden = productData?.stockAvailability == "1"
            
            cell.salesTagText = productData?.saleTagText
            
            cell.addShadow()
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.giftCatCollectionView{//cat collection view
            
            let side = self.giftCatCollectionView.frame.height//(self.giftCatCollectionView.bounds.size.width/3) - 12
            return CGSize(width: side, height: side)
            
        }else if collectionView == self.shopByOccationCollectionView{//shop by occation collection view
            
            return CGSize(width: 150, height: self.shopByOccationCollectionView.frame.height)
            
        }else if collectionView == self.giftsListCollectionView{//gift list collection view
            
            self.view.layoutIfNeeded()

            
            let side = (UIScreen.main.bounds.width/2) - 10
            print("self.view.width",self.view.frame.width)
            print("cell width",side)
            print("UIScreen width",UIScreen.main.bounds.width )
            
            
//            if isiPhone5() {
//                width = 150
//            }
            return CGSize(width: side, height: side * 1.3)
            
        }else if collectionView == self.filterOptionCollectionView{
            return CGSize(width: 60, height: (self.filterOptionCollectionView.frame.height) - 5)
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.shopByOccationCollectionView{
            return UIEdgeInsets(top: 0,left: 12,bottom: 0,right: 12)
        }
        return UIEdgeInsets(top: 0,left: 8,bottom: 0,right: 8)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.giftsListCollectionView{

            //let nextVc = MarketDetailViewController()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "marketDetailView") as! MarketDetailViewController
            nextVc.selectedProductId = "\(self.giftListResponse?.values?[indexPath.row].productID ?? -1)"
            nextVc.isGift = "true"
            self.navigationController?.pushViewController(nextVc, animated: true)

        }else if collectionView == self.giftCatCollectionView{//category

            let nextVc = GiftsListViewController()
            nextVc.shoulShowStore = self.shoulShowStore
            if self.shoulShowStore{
            
                nextVc.shopId = "\(self.giftListResponse?.shop?[indexPath.row].storeID ?? 0)"
                nextVc.navigationItemTitle = self.navigationItemTitle + " -> " + "\(self.giftListResponse?.shop?[indexPath.row].name ?? "Gift")"
//                self.shopId = "\(self.giftListResponse?.shop?[indexPath.row].storeID ?? 0)"
//                self.getGiftItems()
                
            }else{
                let giftCatData = self.giftListResponse?.category?[indexPath.row]
                nextVc.giftCatId = "\(giftCatData?.catID ?? -1)"
                nextVc.navigationItemTitle = self.navigationItemTitle + " -> " + "\(giftCatData?.name ?? "Gift")"
//                self.giftCatId = "\(giftCatData?.catID ?? -1)"
//                self.getGiftItems()
            }
            
            self.navigationController?.pushViewController(nextVc, animated: true)

        }else if collectionView == self.shopByOccationCollectionView{//occation

            let occationData = self.giftListResponse?.occasion?[indexPath.row]
            self.occationId = "\(occationData?.occaID ?? -1)"
            self.getGiftItems()

        }
//        else if collectionView == self.filterOptionCollectionView{//filter option
//
//        }
    }
    //MARK:- Button Action
    
    
    @IBAction func filterAction(_ sender: UIButton) {

//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextVc = storyBoard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
//        self.present(nextVc,animated: true)
//        self.lblPopUpHeading.text = "FILTERS"
//        self.filterOrSortBy = "FILTERS"
//        self.popUpBottomButtonViewHeightConstraint.constant = 80
//        self.filterCount = self.giftListResponse?.filters?.count ?? 0
//        print(filterCount)
//        self.popUpTableViewHeightConstraint.constant = CGFloat((filterCount * self.tableViewCellHeight) + 1)
//        self.popUpViewheightConstraint.constant = self.popUpHeadingHeightConstraint.constant + self.popUpTableViewHeightConstraint.constant + self.popUpBottomButtonViewHeightConstraint.constant + 5 + 8
//        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
//            self.popUpView.isHidden = false
//            })
////        self.popUpView.isHidden = false
//        self.popUpTableView.reloadData()
        self.filterOptionData = self.filterOptionDataOrg
        self.filterId = self.filterIdOrg
        self.filterAction()
    }
    
    @IBAction func sortByAction(_ sender: UIButton) {
        self.lblPopUpHeading.text = "SORT BY"
        self.filterOrSortBy = "SORT BY"
        self.popUpBottomButtonViewHeightConstraint.constant = 0
        self.popUpTableViewHeightConstraint.constant = CGFloat((self.sortOptions.count * self.tableViewCellHeight) + 1)
        self.popUpViewheightConstraint.constant = self.popUpHeadingHeightConstraint.constant + self.popUpTableViewHeightConstraint.constant + self.popUpBottomButtonViewHeightConstraint.constant + 5
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.popUpView.isHidden = false
            })
//        self.popUpView.isHidden = false
        self.popUpTableView.reloadData()
    }
    
    @IBAction func deliveryDateAction(_ sender: UIButton) {
        
    }
    @IBAction func filterClearAllAction(_ sender: Any) {
        self.filterId.removeAll()
        for i in 0...(self.filterOptionData.count - 1){
            self.filterOptionData[i].removeAll()
        }
    }
    @IBAction func filterConfirmAction(_ sender: Any) {
        if self.filterOption{
            self.filterOption = false
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.popUpView.isHidden = true
            })
            self.filterAction()
        }else{
            self.filterIdOrg = self.filterId
            self.filterOptionDataOrg = self.filterOptionData
            print("filterId")
            print(self.filterId)
            print("filterIdOrg")
            print(self.filterIdOrg)
            self.popUpView.isHidden = true
            self.getGiftItems()
        }
        
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVc = storyBoard.instantiateViewController(withIdentifier: "fourthv") as! SearchViewController
        nextVc.searchType = "gift"
        self.navigationController?.pushViewController(nextVc, animated: true)

    }
    
    
    //    MARK:- Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            if touch.view != self.popUpContentView{
//                dismiss(animated: true, completion: nil)
                self.popUpView.isHidden = true
                self.filterOption = false
            }
        }
    }
//    //MARK:- TABBAR DELEGATE
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
//        if viewController == self.tabBarController?.viewControllers?[3]{
//
//            self.navigationController?.popViewController(animated: true)
//            return false
//
//        }
//
//        return true
//
//    }
    

}


//    func getGiftItemsAlamofire(){
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let userId = appDelegate.userProfileDetails.value(forKey: "user_id") ?? ""
//        let url = parentURL + giftItemsUrl + "&category_id=\(self.giftCatId)&user_id=\(userId)"
//        print(url)
////        getResponseFromServer(url: url, params: [:], vc: self, onSuccess: { (responseDict) in
////            print(responseDict)
////        }) { (error, responseError) in
////            print(error ?? "",responseError ?? "")
////        }
//
//
//        Alamofire.request(url, method: HTTPMethod.post, parameters: [:],encoding: JSONEncoding.default, headers: nil).responseString {
//            response in
//
//            print(response)
//
//            switch response.result {
//            case .success:
//                //            if let responseDict:NSDictionary =  response.value as? NSDictionary {
//                //
//                //                success(responseDict)
//                //                progressHUD.hide()
//                //            }
//
//                break
//            case .failure(let error):
//
//                //progressHUD.hide()
//
//                AlertController.alert(withMessage: "Sorry, Something went wrong", presenting: self)
//                //failure(error, nil)
//            }
//        }
//
//
////        Alamofire.request(url, method: HTTPMethod.get, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
////            response in
////
////            print(response)
////
////            //print("\(String(describing: response.response?.statusCode))")
////
////            switch response.result {
////            case .success:
////                if let responseDict:NSDictionary =  response.value as! NSDictionary? {
////
////                    success(responseDict)
////
////                    progressHUD.hide()
////                }
////
////                break
////            case .failure(let error):
////
////                progressHUD.hide()
////                //makeAlert(title: "Sorry", message: "Something went wrong", presenting: vc)
////                failure(error, response)
////            }
////        }
//
//
//
//    }
extension GiftsListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filterOrSortBy == "FILTERS"{
            return self.filterCount
//            return self.giftListResponse?.filters?.count ?? 0
//            return 1
        }else if self.filterOrSortBy == "SORT BY"{
            return self.sortOptions.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.lblData.textColor = .lightGray
        if self.filterOrSortBy == "FILTERS"{
            cell.imgSort.isHidden = true
            cell.imgSortWidth.constant = 0
            cell.lblDataLeading.constant = 0
            if !self.filterOption{
                cell.lblData.textColor = UIColor(named: "MainTxtColor")
                cell.lblOptions.isHidden = true
                cell.lblData.text = self.giftListResponse?.filters?[indexPath.row].filter_name
                let optionCount = self.filterOptionData[indexPath.row].count
                if optionCount != 0{
                    cell.lblOptions.isHidden = false
                    cell.lblOptions.text = self.filterOptionData[indexPath.row][0]
                    let count = self.filterOptionData[indexPath.row].count
                    if count > 1{
                        for i in 1...(count - 1){
                            cell.lblOptions.text! += ","
                            cell.lblOptions.text! += self.filterOptionData[indexPath.row][i]
//                            cell.lblOptions.text! += self.filterOptionData[indexPath.row][i][0]
                        }
                        
                    }
                }
            }else{
                cell.lblOptions.isHidden = true
                cell.lblData.text = self.giftListResponse?.filters?[self.filterSelectedIndexPath].values?[indexPath.row].name
                let id = (self.giftListResponse?.filters?[self.filterSelectedIndexPath].values?[indexPath.row].id)!
                if self.filterId.contains(id){
                    cell.lblData.textColor = UIColor(named: "SortFilter")
                }
            }
            
            cell.imgfilterOrSortBy.image = #imageLiteral(resourceName: "ArrowRight")
        }else if  self.filterOrSortBy == "SORT BY"{
            cell.lblData.textColor = .lightGray
            cell.lblOptions.isHidden = true
            cell.lblData.text = self.sortOptionsNames[indexPath.row]
            cell.imgSort.isHidden = false
            cell.imgSortWidth.constant = 25
            cell.lblDataLeading.constant = 10
            cell.imgSort.image = UIImage(named: self.sortImages[indexPath.row])
            cell.imgfilterOrSortBy.image = #imageLiteral(resourceName: "ArrowR")
            if self.selectedSortRow == indexPath.row{
                cell.imgfilterOrSortBy.image = #imageLiteral(resourceName: "check")
                cell.lblData.textColor = .black
            }else{
                cell.lblData.textColor = .lightGray
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.filterOrSortBy == "FILTERS"{
            if !self.filterOption{
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.popUpView.isHidden = true
                })
            self.lblPopUpHeading.text = self.giftListResponse?.filters?[indexPath.row].filter_name
            self.filterOrSortBy = "FILTERS"
            self.popUpBottomButtonViewHeightConstraint.constant = 80
            self.filterCount = self.giftListResponse?.filters?[indexPath.row].values?.count ?? 0
//            let filterValuesCount = self.giftListResponse?.filters?[indexPath.row].values?.count
            print(filterCount)
            self.filterOption = true
            self.popUpTableViewHeightConstraint.constant = CGFloat((filterCount * self.tableViewCellHeight) + 1)
            self.popUpViewheightConstraint.constant = self.popUpHeadingHeightConstraint.constant + self.popUpTableViewHeightConstraint.constant + self.popUpBottomButtonViewHeightConstraint.constant + 5 + 8
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.popUpView.isHidden = false
                })
    //        self.popUpView.isHidden = false
            self.filterSelectedIndexPath = indexPath.row
            self.popUpTableView.reloadData()
            }else{

                let id = (self.giftListResponse?.filters?[self.filterSelectedIndexPath].values?[indexPath.row].id)!
                if self.filterId.contains(id){
                    let indexx = self.filterId.firstIndex(of: id)
                    self.filterId.remove(at: indexx!)
                }else{
                    self.filterId.append(id)
                }
                let name = (self.giftListResponse?.filters?[self.filterSelectedIndexPath].values?[indexPath.row].name)!
                if self.filterOptionData[self.filterSelectedIndexPath].contains(name){
                  let indexx = self.filterOptionData[self.filterSelectedIndexPath].firstIndex(of: name)
                    self.filterOptionData[self.filterSelectedIndexPath].remove(at: indexx!)
                }else{
                    self.filterOptionData[self.filterSelectedIndexPath].append(name)
                }
                if self.filterSelectedArray.contains(name){
                    let indexx = self.filterSelectedArray.firstIndex(of: name)
                    self.filterSelectedArray.remove(at: indexx!)
                }else{
                    self.filterSelectedArray.append(name)
                }
                self.popUpTableView.reloadData()
                print(self.filterId)
                print(self.filterOptionData)
                print(self.filterSelectedArray)
                
            }
        }else if  self.filterOrSortBy == "SORT BY"{
            self.selectedSortRow = indexPath.row
            self.sortby = self.sortOptions[indexPath.row]
//            if indexPath.row == 0{
//                self.sort_order = "asc"
//            }else{
                self.sort_order = self.sortOrders[indexPath.row]
//            }
            self.getGiftItems()
            self.popUpTableView.reloadData()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.popUpView.isHidden = true
//            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.tableViewCellHeight)
    }
    
    
}

extension GiftsListViewController: UITextFieldDelegate,UISearchTextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    @objc func textFieldDidChange(sender: UITextField){
        self.query = self.txtSearch.text!
        self.getGiftItems()
        if self.txtSearch.text == ""{
            dismissKeyboard()
        }
    }
}
