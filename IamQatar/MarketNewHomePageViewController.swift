//
//  MarketNewHomePageViewController.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 29/04/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class MarketNewHomePageViewController: UIViewController {

    //MARK:- VIEW DID LOAD
    @IBOutlet weak var bannerContView: UIView!
    @IBOutlet weak var bannerView: KIImagePager!
    
    @IBOutlet weak var storeStackView: UIStackView!
    @IBOutlet weak var productStackView: UIStackView!
    
    @IBOutlet weak var storeCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    @IBOutlet weak var storeCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblBannerTitle: UILabel!
    @IBOutlet weak var lblBannerDesc: UILabel!
    
    //MARK:- VARIABLES
    var responseStores = NSArray()
    var responseFeaturedProducts = NSArray()
    var responseBanner = NSArray()
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

            // api.php?page=iaqfeeds
            // category
            // api.php?page=market
            // api.php?page=getProductCategories
            // category_id, store_id
        
        self.setUi()
        
        
        self.getMarket()
               
    }

    
    //MARK:- API CALL
    func getMarket(category : String = ""){
        
        let apiService = ApiService.shared
        
        apiService.urlString = parentURL + getNewMarketHomePage
        apiService.target = self
        
        let paramter = ["user_id":userId()]
        
        apiService.parameter = paramter as [String : Any]
        
        apiService.fetchData { (responseDict, error) in
            
            if error == nil, let responseDict = responseDict{
                
                print(responseDict)
                
                DispatchQueue.main.async {
                    self.setContentView(responseDict:responseDict)
                }
                
            }
        }
    }
    
    //MARK:- METHODS
    func setUi(){
        
        self.storeCollectionView.delegate = self
        self.storeCollectionView.dataSource = self
        self.productCollectionView.delegate = self
        self.productCollectionView.dataSource = self
        
        self.storeCollectionView.register(UINib(nibName: "StoresCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StoresCollectionViewCell")
        
        self.productCollectionView.register(UINib(nibName: "GiftListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftListCollectionViewCell")
        
        self.bannerView.delegate = self
        self.bannerView.dataSource = self
        self.bannerView.slideshowTimeInterval = UInt(5.5)
        self.bannerView.imageCounterDisabled = true
        
        self.title = "IAQ MARKET"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    func setContentView(responseDict:NSDictionary){
        
        self.responseStores = (responseDict.value(forKey: "stores") ?? []) as! NSArray
        self.responseFeaturedProducts = (responseDict.value(forKey: "products") ?? []) as! NSArray
        self.responseBanner = (responseDict.value(forKey: "banners") ?? []) as! NSArray
        self.setBanner()
        
        self.storeCollectionView.reloadData()
        self.productCollectionView.reloadData()
        self.bannerView.reloadData()
        
        self.setContentViewHeight()
        
        
    }
    
    func setContentViewHeight(){
        
        self.bannerHeightConstraint.constant = self.view.frame.size.width / 1.7
        self.view.layoutIfNeeded()
        self.storeCollectionViewHeightConstraint.constant = self.storeCollectionView.contentSize.height + self.storeCollectionView.contentInset.top + self.storeCollectionView.contentInset.bottom
        self.view.layoutIfNeeded()
        
        let side = (self.productCollectionView.bounds.size.width/3)
        self.productCollectionViewHeightConstraint.constant = (side * 1.3)
        
    }
    
    fileprivate func setBanner() {
        
        if self.responseBanner.firstObject != nil{
            
            self.bannerContView.isHidden = false
            if let bannerDict = self.responseBanner.firstObject as? NSDictionary{
                
                self.lblBannerTitle.text = "\(bannerDict.value(forKey: "title") ?? "")"
                self.lblBannerDesc.text = "\(bannerDict.value(forKey: "description") ?? "")"
                
            }
            
        }else{
            self.bannerContView.isHidden = true
        }
        
        self.bannerView.reloadData()
    }

}

extension MarketNewHomePageViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.storeCollectionView {
            return self.responseStores.count
        }
        return self.responseFeaturedProducts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.storeCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoresCollectionViewCell", for: indexPath) as! StoresCollectionViewCell
            
            //data
            if let storeData = self.responseStores.object(at: indexPath.row) as? NSDictionary{
                
                cell.storeData = storeData
            }
            
            return cell
            
        }else{
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftListCollectionViewCell", for: indexPath) as! GiftListCollectionViewCell
            
            if let productData = self.responseFeaturedProducts.object(at: indexPath.row) as? NSDictionary{
                
                cell.lblGiftName.text = "\(productData.value(forKey: "product_name") ?? "")"
                cell.lblStore.text = price("\(productData.value(forKey: "price") ?? "")")
                cell.imgGift.setImage(withUrlString: "\(productData.value(forKey: "default") ?? "")")
                cell.lblSoldOut.isHidden = true//productData?.stockAvailability == "1"
                
                cell.salesTagText = "\(productData.value(forKey: "sale_tag_text") ?? "")"
                
            }
            
            
            return cell
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == self.productCollectionView{
            let side = (self.storeCollectionView.bounds.size.width/3) - 8//12
            return CGSize(width: side, height: side * 1.3)
        }

        //self.view.layoutIfNeeded()
        
        let width = (self.storeCollectionView.frame.width / 3) - 6
        let height = ((width * 74) / 95) + 54
        return CGSize(width: width, height: height)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.productCollectionView{
            return UIEdgeInsets(top: 0,left: 12,bottom: 12,right: 12)
        }
        return UIEdgeInsets(top: 0,left: 8,bottom: 0,right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.productCollectionView{
            
            //let nextVc = MarketDetailViewController()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "marketDetailView") as! MarketDetailViewController
            
            nextVc.selectedProductId = "\((self.responseFeaturedProducts.object(at: indexPath.row) as AnyObject).value(forKey: "product_id") ?? "")"
            nextVc.isGift = "false"
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }else{
            
            //let nextVc = MarketDetailViewController()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "marketView") as! MarketViewController
            nextVc.storeID = "\((self.responseStores.object(at: indexPath.row) as AnyObject).value(forKey: "id") ?? "")"
            //data
            if let storeData = self.responseStores.object(at: indexPath.row) as? NSDictionary{
                nextVc.title = "\(storeData.value(forKey: "name") ?? "IAQ MARKET")"
            }
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }
        
        
    }

}


extension MarketNewHomePageViewController : KIImagePagerDelegate,KIImagePagerDataSource{
    
    //MARK:- KI IMAGE PAGER DELEGATE
    func array(withImages pager: KIImagePager!) -> [Any]! {
        
        if let imageArray = self.responseBanner.value(forKey: "banner") as? NSArray{
            if imageArray.count > 0 {
                let imageUrlArray = imageArray.map{ parentURL + "\($0)" }
                //print(imageUrlArray)
                return imageUrlArray
            }
        }
        //print(imageArray)
        
        return []
    }
    
    func contentMode(forImage image: UInt, in pager: KIImagePager!) -> UIView.ContentMode {
        return .scaleAspectFill
    }
    
    func imagePager(_ imagePager: KIImagePager!, didSelectImageAt index: UInt) {
        
        if let selectedBanenrData = self.responseBanner.object(at: Int(index)) as? NSDictionary{
            
            let linkType = "\(selectedBanenrData.value(forKey: "link_type") ?? "")"
            let typeValue = "\(selectedBanenrData.value(forKey: "product_id") ?? "0")"
            let pageLink = "\(selectedBanenrData.value(forKey: "pagelink") ?? "")"
            
            self.redirectBannerTap(linkType: linkType, typeValue: typeValue, pageLink: pageLink)
            
        }
        
    }
    
    func imagePager(_ imagePager: KIImagePager!, didScrollTo index: UInt) {
        
        if let bannerDict = self.responseBanner.object(at: Int(index)) as? NSDictionary{
            
            self.lblBannerTitle.text = "\(bannerDict.value(forKey: "title") ?? "")"
            self.lblBannerDesc.text = "\(bannerDict.value(forKey: "description") ?? "")"
            
        }
        
    }
    
    func redirectBannerTap(linkType:String,typeValue:String,pageLink:String){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if linkType == "external"{
            
            let urlString = pageLink.contains("http://") ? pageLink : "http://" + pageLink
            guard let url = URL(string: urlString) else { return }
            UIApplication.shared.open(url)
            
        }else if linkType == "contest"{
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "contestView") as! contestViewController
            self.navigationController?.pushViewController(nextVc, animated: true)
            
            
        }else if linkType == "product"{
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "marketDetailView") as! MarketDetailViewController
            nextVc.selectedProductId = typeValue
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }else if linkType == "promo"{
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "retailView") as! RetailViewController
            nextVc.pushedFrom = ""
            nextVc.type = ""
            nextVc.catId = typeValue
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }else if linkType == "promo_item"{
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "retailView") as! RetailViewController
            nextVc.pushedFrom = ""
            nextVc.type = ""
            nextVc.selectedSearchItem = typeValue
            self.navigationController?.pushViewController(nextVc, animated: true)
            
            
        }else if linkType == "retails"{
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "marketView") as! MarketViewController
            nextVc.selectedRetailId = typeValue
            self.navigationController?.pushViewController(nextVc, animated: true)
            
            
        }else if linkType == "events"{
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "eventList") as! EventsList
            nextVc.eventCatId = typeValue
            nextVc.isCalendar = "No"
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }else if linkType == "event_details"{
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "eventDetails") as! EventDetalPage
            nextVc.fromNotificationTap = false
            nextVc.selectedEventId = [typeValue]
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }else if linkType == "malls"{
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "MallDetailsViewController") as! MallDetailsViewController
            nextVc.mallId = typeValue
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }else if linkType == "flyers"{
            
            self.getFlyersApi(pid:typeValue)
            
        }else if linkType == "iaqfeeds"{
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "MallDetailsViewController") as! FeedDetailsViewController
            nextVc.feedSlug = typeValue
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }
        
    }
    
    
}

extension MarketNewHomePageViewController{//get flayers
    
    func getFlyersApi(pid:String){
        
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
        
        let params = ["store_id":pid,
                      "user_id":userId]
        
        let Url = String(format: parentURL + getFlyers)
        guard let serviceUrl = URL(string: Url) else { return}
        let parameterDictionary = params as NSDictionary
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
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
                    let responseDict = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    print(responseDict)
                    
                    let flayerImagesArray = (((responseDict as AnyObject).value(forKey: "flyers") as AnyObject).value(forKey: "image") ?? []) as! NSArray
                    
                    
                    DispatchQueue.main.async {
                        
                        progressHUD.hide()
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextVc = storyBoard.instantiateViewController(withIdentifier: "retailDetailView") as! RetailDetailViewController
                        nextVc.flipsArray = flayerImagesArray.mutableCopy() as? NSMutableArray
                        self.navigationController?.pushViewController(nextVc, animated: true)
                        
                    }
                    
                    
                } catch {
                    print(error)
                    progressHUD.hide()
                }
            }
            }.resume()
        
        return
    }
    
}
