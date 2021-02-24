//
//  IAQFeedsViewController.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 05/02/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit

class IAQFeedsViewController: BaseViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var feedsCollectionView: UICollectionView!
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var feedsCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerContView: UIView!
    @IBOutlet weak var bannerView: KIImagePager!
    @IBOutlet weak var lblBannerTitle: UILabel!
    @IBOutlet weak var lblBannerDesc: UILabel!
    
    //MARK:- VARIABLES
    var responseFeeds = NSArray()
    var responseCategories = NSArray()
    var responseBanner = NSArray()
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layoutIfNeeded()
        self.setUi()
        self.setContentViewHeight()
        
        self.getFeeds()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.feedsCollectionView.reloadData()
    }
    
    //MARK:- API CALL
    func getFeeds(category : String = ""){
        
        let apiService = ApiService.shared
        
        apiService.urlString = parentURL + IAQFeedsApi
        apiService.target = self
        
        let paramter = ["user_id":userId(),
                        "category":category]
        
        apiService.parameter = paramter as [String : Any]
        
        apiService.fetchData { (responseDict, error) in
            
            if error == nil, let responseDict = responseDict{
                
                DispatchQueue.main.async {
                    self.setContentView(responseDict: responseDict)
                }
                
            }
        }
    }

    
    //MARK:- METHODS
    fileprivate func setUi(){
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.feedsCollectionView.delegate = self
        self.feedsCollectionView.dataSource = self
        
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        
        
        self.categoryCollectionView.register(UINib(nibName: "TagsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagsCollectionViewCell")
        self.feedsCollectionView.register(UINib(nibName: "FeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeedCollectionViewCell")
        self.feedsCollectionView.reloadData()
        
        self.navigationItem.title = "IAQ FEEDS"
        
        self.lblBannerDesc.text = ""
        self.lblBannerTitle.text = ""
        
        self.bannerView.slideshowTimeInterval = UInt(5.5)
        self.bannerView.imageCounterDisabled = true
        self.bannerView.delegate = self
        self.bannerView.dataSource = self
        
    }
    
    fileprivate func setContentView(responseDict:NSDictionary){
        
        print(responseDict)
        
        if let feeds = responseDict.value(forKey: "value") as? NSArray{
            self.responseFeeds = feeds
        }
        
        if let categories = responseDict.value(forKey: "categories") as? NSArray{
            self.responseCategories = categories
        }
        
        if let banners = responseDict.value(forKey: "banners") as? NSArray{
            self.responseBanner = banners
        }
        
        //self.responseBanner = (responseDict.value(forKey: "banners") ?? []) as! NSArray
        //self.responseFeeds = (responseDict.value(forKey: "value") ?? []) as! NSArray
        //self.responseCategories = (responseDict.value(forKey: "categories") ?? []) as! NSArray
        
        
        self.setBanner()
        
        self.categoryCollectionView.isHidden = self.responseCategories.firstObject == nil
        
        
        setBanner()
        self.feedsCollectionView.reloadData()
        self.categoryCollectionView.reloadData()
        self.setContentViewHeight()

        
    }
    
    func setContentViewHeight(){
        
        self.bannerHeightConstraint.constant = self.view.frame.size.width / 1.7
        self.view.layoutIfNeeded()
        self.feedsCollectionViewHeightConstraint.constant = self.feedsCollectionView.contentSize.height + self.feedsCollectionView.contentInset.top + self.feedsCollectionView.contentInset.bottom
        self.view.layoutIfNeeded()
        
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


extension IAQFeedsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.categoryCollectionView {
            return self.responseCategories.count
        }
        return self.responseFeeds.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.categoryCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsCollectionViewCell
            
            //data
            if let catData = self.responseCategories.object(at: indexPath.row) as? NSDictionary{
                
                cell.lblItem.text = "\(catData.value(forKey: "name") ?? "")"
            }
            
            //design
            self.view.layoutIfNeeded()
            if indexPath.row % 3 == 0{
                cell.mainContentView.addGradient(colorOne: Colors.gradOneStartColor, colorTwo: Colors.gradOneEndColor)
            }else if indexPath.row % 3 == 1{
                cell.mainContentView.addGradient(colorOne: Colors.gradThreeStartColor, colorTwo: Colors.gradThreeEndColor)
            }else{
                cell.mainContentView.addGradient(colorOne: Colors.gradTwoStartColor, colorTwo: Colors.gradTwoEndColor)
            }
            self.view.layoutIfNeeded()
            
            return cell
            
            
        }else{
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewCell", for: indexPath) as! FeedCollectionViewCell
            
            if let feedData = self.responseFeeds[indexPath.row] as? NSDictionary{
                cell.feedData = feedData
            }
            
            return cell
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == self.categoryCollectionView{
            
            self.categoryCollectionView.layoutIfNeeded()
            let label = UILabel()
            label.text = "\((self.responseCategories.object(at: indexPath.row) as AnyObject).value(forKey: "name") ?? "")"
            label.font =  UIFont(name: "HelveticaNeue-Medium", size: 14)
            label.sizeToFit()
            label.layoutIfNeeded()
            let width = label.intrinsicContentSize.width + 20
            self.categoryCollectionView.layoutIfNeeded()
            
            return CGSize(width: width, height: self.categoryCollectionViewHeightConstraint.constant)
        }

        //self.view.layoutIfNeeded()
        let side = (self.feedsCollectionView.frame.width / 2) - 18
        return CGSize(width: side, height: side)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.categoryCollectionView{
            return UIEdgeInsets(top: 0,left: 12,bottom: 0,right: 12)
        }
        return UIEdgeInsets(top: 0,left: 12,bottom: 12,right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.categoryCollectionView{
            
            let id = "\((self.responseCategories.object(at: indexPath.row) as AnyObject).value(forKey: "id") ?? "")"
            self.getFeeds(category: id)
            
        }else{
            
            let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailsViewController") as! FeedDetailsViewController
            nextVc.feedSlug = "\((self.responseFeeds[indexPath.row] as AnyObject).value(forKey: "slug") ?? "")"
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }
        
    }

}

extension IAQFeedsViewController : KIImagePagerDelegate,KIImagePagerDataSource{
    
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
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "FeedDetailsViewController") as! FeedDetailsViewController
            nextVc.feedSlug = typeValue
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }
        
    }
    
    
}

extension IAQFeedsViewController{//get flayers
    
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
