//
//  GiftboxHomeViewController.swift
//  IamQatar
//
//  Created by anuroop kanayil on 20/08/19.
//  Copyright © 2019 alisons. All rights reserved.
//

import UIKit



class GiftboxHomeViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,KIImagePagerDelegate,KIImagePagerDataSource,UITabBarDelegate {
    
    
    //MARK:- OUTLETS
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var giftBoxCatContView: UIView!
    @IBOutlet weak var giftBoxCatCollectionView: UICollectionView!
    @IBOutlet weak var giftBoxCatViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shopByOccationContView: UIView!
    @IBOutlet weak var shopByOccationCollectionView: UICollectionView!
    @IBOutlet weak var shopByOccationViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shopByStoreContView: UIView!
    @IBOutlet weak var shopByStoreCollectionView: UICollectionView!
    @IBOutlet weak var shopByStoreViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var featuredItemsContView: UIView!
    @IBOutlet weak var featuredItemsCollectionView: UICollectionView!
    @IBOutlet weak var featuredItemsViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var newArrivalContView: UIView!
    @IBOutlet weak var newArrivalCollectionView: UICollectionView!
    @IBOutlet weak var newArrivalViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var banner: KIImagePager!
    
    //MARK:- VARIABLES
    var collectioViewCellSide = 100
    //    var responseGiftCats = [GiftCategory]()
    //    var responseBanner = [Banner]()
    var responseMain : GiftHomeResponse?
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.mainScrollView.contentSize = CGSize(width: 0,height: self.mainScrollView.frame.size.height);
        
        self.setUi()
        
        self.getGiftCategories()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.subviews[4].isHidden = false
        self.tabBarController?.delegate = self
    }
    
    //MARK:- API CALL
    func getGiftCategories(){
        
        let progressHUD = ProgressHUDD(text: "")
        self.view.addSubview(progressHUD)
        
        //check internet connection
        guard Reachability.isConnectedToNetwork() else {
            progressHUD.hide()
            //noNetworkAlert(presenting: vc)
            AlertController.alert(withMessage: "Network connection not available!", presenting: self)
            return
        }
        
        //let Url = String(format: "http://client.alisonsinfomatics.com/qatardeals/api.php?page=getGiftsCategory")
        let Url = String(format: parentURL + giftCategoryUrl)
        print(Url)
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = [:] as NSDictionary
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
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    print(json)
                    
                    let decoder = JSONDecoder()
                    //decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(GiftHomeResponse.self, from: data)
                    self.responseMain = response
                    
                    //print(response)
                    
                    print(self.responseMain as Any)
                    
                    DispatchQueue.main.async {
                        progressHUD.hide()
                        self.setContentView()
                    }
                    
                    
                } catch {
                    print(error)
                    progressHUD.hide()
                }
            }
            }.resume()
        
    }
    
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
    
    
    //MARK:- METHODS
    func setUi(){
        
        self.navigationItem.title = "GIFTS"
        //self.navigationItem.hidesBackButton = true
        
//        self.giftBoxCatCollectionView.isScrollEnabled = false
        
        self.giftBoxCatCollectionView.register(UINib(nibName: "GiftBoxCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftBoxCategoriesCollectionViewCell")
        self.shopByOccationCollectionView.register(UINib(nibName: "GiftBoxCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftBoxCategoriesCollectionViewCell")
        self.shopByStoreCollectionView.register(UINib(nibName: "GiftBoxCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftBoxCategoriesCollectionViewCell")
        self.featuredItemsCollectionView.register(UINib(nibName: "GiftListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftListCollectionViewCell")
        self.newArrivalCollectionView.register(UINib(nibName: "GiftListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftListCollectionViewCell")
        
        //self.banner.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        self.banner.slideshowTimeInterval = UInt(5.5)
        //self.banner.slideshowShouldCallScrollToDelegate = true
        self.banner.imageCounterDisabled = true
        
        //        //-----showing tabar item at index 4 (back button)-------//
        //        [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
        //        self.tabBarController.delegate = self;
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(gotoSearch))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
        
    }
    
    func setContentView(){
        
        self.banner.reloadData()
        self.giftBoxCatCollectionView.reloadData()
        self.shopByOccationCollectionView.reloadData()
        self.shopByStoreCollectionView.reloadData()
        self.featuredItemsCollectionView.reloadData()
        self.newArrivalCollectionView.reloadData()
        
        self.setContentViewHeight()
        
    }
    
    func setContentViewHeight(){
        
        if self.responseMain?.banner?.count != 0{//banner
            self.bannerHeightConstraint.constant = self.view.frame.width / 1.7
            self.banner.isHidden = false
        }else{
            self.bannerHeightConstraint.constant = 0
            self.banner.isHidden = true
        }
        
        
        if self.responseMain?.occasion?.count != 0{//occation
            self.shopByOccationViewHeightConstraint.constant = CGFloat(self.collectioViewCellSide + 45)
            self.shopByOccationContView.isHidden = false
        }else{
            self.shopByOccationViewHeightConstraint.constant = 0
            self.shopByOccationContView.isHidden = true
        }
        
        if self.responseMain?.shop?.count != 0{//store
            self.shopByStoreViewHeightConstraint.constant = CGFloat(self.collectioViewCellSide + 45)
            self.shopByStoreContView.isHidden = false
        }else{
            self.shopByStoreViewHeightConstraint.constant = 0
            self.shopByStoreContView.isHidden = true
        }
        
        if self.responseMain?.featured?.count != 0{//featured
            self.view.layoutIfNeeded()
            let side = (self.giftBoxCatCollectionView.bounds.size.width/3) - 8//12
            self.featuredItemsViewHeightConstraint.constant = (side * 1.3 + 45) //CGFloat(self.collectioViewCellSide + 45)
            self.featuredItemsCollectionView.reloadData()
            self.view.layoutIfNeeded()
            self.featuredItemsContView.isHidden = false
        }else{
            self.featuredItemsViewHeightConstraint.constant = 0
            self.featuredItemsContView.isHidden = true
        }
        
        if self.responseMain?.newitems?.count != 0{//featured
            self.view.layoutIfNeeded()
            let side = (self.giftBoxCatCollectionView.bounds.size.width/3) - 8//12
            self.newArrivalViewHeightConstraint.constant = (side * 1.3 + 45) //CGFloat(self.collectioViewCellSide + 45)
            self.newArrivalCollectionView.reloadData()
            self.view.layoutIfNeeded()
            self.newArrivalContView.isHidden = false
        }else{
            self.newArrivalViewHeightConstraint.constant = 0
            self.newArrivalContView.isHidden = true
        }
        
        
        self.view.layoutIfNeeded()
     //   self.giftBoxCatViewHeightConstraint.constant = self.giftBoxCatCollectionView.contentSize.height + 45
        self.giftBoxCatViewHeightConstraint.constant = CGFloat(self.collectioViewCellSide + 45)
        self.view.layoutIfNeeded()
        
        
        
        //self.mainContentViewHeightConstraint.constant = self.featuredItemsContView.frame.origin.y + self.featuredItemsViewHeightConstraint.constant + 100
        let h1 =  self.bannerHeightConstraint.constant + self.giftBoxCatCollectionView.contentSize.height + self.newArrivalViewHeightConstraint.constant
        self.mainContentViewHeightConstraint.constant = h1 + self.shopByOccationViewHeightConstraint.constant + self.shopByStoreViewHeightConstraint.constant + self.featuredItemsViewHeightConstraint.constant + 100
        
        self.view.layoutIfNeeded()
    }
    
    func redirectBannerTap(linkType:String,typeValue:String,pageLink:String){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if linkType == "external"{
            
            //            NSString *link = [NSString stringWithFormat:@"%@",[bannerPageLinkArray objectAtIndex:index]];
            //
            //            if ([link rangeOfString:@"http://"].location == NSNotFound) {
            //                UIApplication *application = [UIApplication sharedApplication];
            //                [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",link]] options:@{} completionHandler:nil];
            //            } else {
            //                UIApplication *application = [UIApplication sharedApplication];
            //                [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",link]] options:@{} completionHandler:nil];
            //            }
            
            let urlString = pageLink.contains("http://") ? pageLink : "http://" + pageLink
            guard let url = URL(string: urlString) else { return }
            UIApplication.shared.open(url)
            
            
        }else if linkType == "contest"{
            
            //            contestViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"contestView"];
            //            [self.navigationController pushViewController:view animated:YES];
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "contestView") as! contestViewController
            self.navigationController?.pushViewController(nextVc, animated: true)
            
            
        }else if linkType == "product"{
            
            //            MarketDetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"marketDetailView"];
            //            view.selectedProductId  = [bannerClickRedirectIdArray objectAtIndex:index];
            //            [self.navigationController pushViewController:view animated:YES];
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "marketDetailView") as! MarketDetailViewController
            nextVc.selectedProductId = typeValue
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }else if linkType == "promo"{
            
            //            RetailViewController *view= [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
            //            view.pushedFrom = @"categoryItem";
            //            view.type  = @"";
            //            view.catId = [bannerClickRedirectIdArray objectAtIndex:index];
            //            [self.navigationController pushViewController:view animated:YES];
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "retailView") as! RetailViewController
            nextVc.pushedFrom = ""
            nextVc.type = ""
            nextVc.catId = typeValue
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }else if linkType == "promo_item"{
            
            //            RetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
            //            vc.pushedFrom = @"categoryItem";
            //            vc.type  = @"";
            //            vc.selectedSearchItem = [bannerClickRedirectIdArray objectAtIndex:index];
            //            [self.navigationController pushViewController:vc animated:YES];
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "retailView") as! RetailViewController
            nextVc.pushedFrom = ""
            nextVc.type = ""
            nextVc.selectedSearchItem = typeValue
            self.navigationController?.pushViewController(nextVc, animated: true)
            
            
        }else if linkType == "retails"{
//            MarketViewController *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"marketView"];
//            NSString *selectedRetailId= [bannerClickRedirectIdArray objectAtIndex:index];
//            vc.selectedRetailId = selectedRetailId;
//            [self.navigationController pushViewController:vc animated:YES];
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "marketView") as! MarketViewController
            nextVc.selectedRetailId = typeValue
            self.navigationController?.pushViewController(nextVc, animated: true)
            
            
       }else if linkType == "events"{
//            EventsList *view = [self.storyboard instantiateViewControllerWithIdentifier:@"eventList"];
//            view.eventCatId = [bannerClickRedirectIdArray objectAtIndex:index];
//            view.IsCalendar = @"No";
//            [self.navigationController pushViewController:view animated:YES];
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "eventList") as! EventsList
            nextVc.eventCatId = typeValue
            nextVc.isCalendar = "No"
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }else if linkType == "event_details"{
//            EventDetalPage *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetails"];
//            vc.fromNotificationTap = NO;
//            vc.selectedEventId = [bannerClickRedirectIdArray objectAtIndex:index];
//            [self.navigationController pushViewController:vc animated:NO];
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "eventDetails") as! EventDetalPage
            nextVc.fromNotificationTap = false
            nextVc.selectedEventId = [typeValue]
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }else if linkType == "malls"{
            
//            MallDetailsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"MallDetailsViewController"];
//            view.mallId = [bannerClickRedirectIdArray objectAtIndex:index];
//            [self.navigationController pushViewController:view animated:YES];
            
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "MallDetailsViewController") as! MallDetailsViewController
            nextVc.mallId = typeValue
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }else if linkType == "flyers"{
            
            self.getFlyersApi(pid:typeValue)
            
        }
        
    }
    
    
    //MARK:- BTN ACTIONS
    @IBAction func goToSearch(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVc = storyBoard.instantiateViewController(withIdentifier: "fourthv") as! SearchViewController
        nextVc.searchType = "gift"
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    @objc func gotoSearch(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVc = storyBoard.instantiateViewController(withIdentifier: "fourthv") as! SearchViewController
        nextVc.searchType = "gift"
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    
    
    //MARK:- KI IMAGE PAGER DELEGATE
    func array(withImages pager: KIImagePager!) -> [Any]! {
        
        let imageArray = (self.responseMain?.banner ?? []).map{$0.banner}
        //print(imageArray)
        if imageArray.count > 0 {
            let imageUrlArray = imageArray.map{ parentURL + "\($0 ?? "")" }
            //print(imageUrlArray)
            return imageUrlArray
        }
        
        return []
    }
    
    func contentMode(forImage image: UInt, in pager: KIImagePager!) -> UIView.ContentMode {
        return .scaleAspectFill
    }
    
    func imagePager(_ imagePager: KIImagePager!, didSelectImageAt index: UInt) {
        
        let selectedBanenrData = self.responseMain?.banner?[Int(index)]
        
        let linkType = "\(selectedBanenrData?.linkType ?? "")"
        let typeValue = "\(selectedBanenrData?.productID ?? 0)"
        let pageLink = "\(selectedBanenrData?.pagelink ?? "")"
        
        self.redirectBannerTap(linkType: linkType, typeValue: typeValue, pageLink: pageLink)
        
    }
    
    
    //MARK:- COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.giftBoxCatCollectionView{
            return (self.responseMain?.value ?? []).count
        }else if collectionView == self.shopByOccationCollectionView{
            return(self.responseMain?.occasion ?? []).count
        }else if collectionView == self.shopByStoreCollectionView{
            return(self.responseMain?.shop ?? []).count
        }else if collectionView == self.featuredItemsCollectionView{
            return(self.responseMain?.featured ?? []).count
        }else if collectionView == self.newArrivalCollectionView{
            return(self.responseMain?.newitems ?? []).count
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView != self.featuredItemsCollectionView && collectionView != self.newArrivalCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftBoxCategoriesCollectionViewCell", for: indexPath) as! GiftBoxCategoriesCollectionViewCell
            
            if collectionView == self.giftBoxCatCollectionView{//gift box cat
                
                cell.lblTitle.isHidden = false
                cell.mainContentView.addBorder(0, Colors.mainTxtColor)
                cell.imgItem.backgroundColor = UIColor.lightGray
                
                let giftCatData = self.responseMain?.value?[indexPath.row]//self.responseGiftCats[indexPath.row] as! NSDictionary
                cell.lblTitle.text = giftCatData?.name//"\(giftCatData.value(forKey: "name") ?? "")"
                
                cell.imgItem.setImage(withUrlString: giftCatData?.image ?? "")
                //cell.imgItem.setImage(withUrlString: "\(giftCatData.value(forKey: "image") ?? "")")
                cell.imgItem.cornerRadius = 7
                cell.imgItem.addBorder(0.5, .lightGray)
//                cell.addBorder(0.5, .lightGray)
                
                
                
            }else if collectionView == self.shopByOccationCollectionView{//occation
                
                cell.lblTitle.isHidden = false
                cell.mainContentView.addBorder(0, Colors.mainTxtColor)
                cell.imgItem.backgroundColor = UIColor.lightGray
                
                let occationData = self.responseMain?.occasion?[indexPath.row]
                cell.lblTitle.text = occationData?.name
                cell.imgItem.setImage(withUrlString: occationData?.image ?? "")
                cell.imgItem.cornerRadius = 7
                cell.imgItem.addBorder(0.5, .lightGray)
//                cell.addBorder(0.5, .lightGray)
                
            }else if collectionView == self.shopByStoreCollectionView{//shop by store
                
                cell.lblTitle.isHidden = true
                cell.mainContentView.addBorder(1.0, Colors.mainTxtColor.withAlphaComponent(0.5))
                cell.imgItem.backgroundColor = UIColor.lightGray
                
                let storeData = self.responseMain?.shop?[indexPath.row]
                cell.lblTitle.text = storeData?.name
                cell.imgItem.setImage(withUrlString: storeData?.image ?? "")
//                cell.imgItem.addBorder(0.5, .lightGray)
//                cell.addBorder(0.5, .lightGray)
                
            }
            
            return cell
            
        }else if collectionView == self.newArrivalCollectionView{//New Arrivals
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftListCollectionViewCell", for: indexPath) as! GiftListCollectionViewCell
            
            let productData = self.responseMain?.newitems?[indexPath.row]
            cell.lblGiftName.text = productData?.productName
            let price = (productData?.price)!
            let priceSTR = String(price)
            cell.lblStore.text = "\(priceSTR) QAR"
            cell.lblStore.textColor = .lightGray
            cell.imgGift.setImage(withUrlString: productData?.imgDefault ?? "")
            cell.lblSoldOut.isHidden = productData?.stockAvailability == "1"
            
            cell.salesTagText = productData?.saleTagText
            
            return cell
            
        }else {//featured product
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftListCollectionViewCell", for: indexPath) as! GiftListCollectionViewCell
            
            let productData = self.responseMain?.featured?[indexPath.row]
            cell.lblGiftName.text = productData?.productName
            let price = (productData?.price)!
            let priceSTR = String(price)
            cell.lblStore.text = "\(priceSTR) QAR"
            cell.lblStore.textColor = .lightGray
            cell.imgGift.setImage(withUrlString: productData?.imgDefault ?? "")
            cell.lblSoldOut.isHidden = productData?.stockAvailability == "1"
            
            cell.salesTagText = productData?.saleTagText
            
            return cell
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let side = (self.giftBoxCatCollectionView.bounds.size.width/3) - 8//12
//        if collectionView == self.giftBoxCatCollectionView{
//            return CGSize(width: side, height: side - 5)
////            return CGSize(width: side, height: side * 1.3)
//        }else
        if collectionView == self.featuredItemsCollectionView || collectionView == self.newArrivalCollectionView{
            return CGSize(width: side, height: side * 1.3)
        }else{
            return CGSize(width: self.collectioViewCellSide, height: self.collectioViewCellSide)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0,left: 8,bottom: 0,right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView == self.featuredItemsCollectionView{
            
            //let nextVc = MarketDetailViewController()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "marketDetailView") as! MarketDetailViewController
            nextVc.selectedProductId = "\(self.responseMain?.featured?[indexPath.row].productID ?? -1)"
            nextVc.isGift = "true"
            self.navigationController?.pushViewController(nextVc, animated: true)
            
            
        }else if collectionView == self.newArrivalCollectionView{
            
            //let nextVc = MarketDetailViewController()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextVc = storyBoard.instantiateViewController(withIdentifier: "marketDetailView") as! MarketDetailViewController
            nextVc.selectedProductId = "\(self.responseMain?.newitems?[indexPath.row].productID ?? -1)"
            nextVc.isGift = "true"
            self.navigationController?.pushViewController(nextVc, animated: true)
            
            
        }else{
            
            let nextVc = GiftsListViewController()
            
            if collectionView == self.giftBoxCatCollectionView{//category
                nextVc.giftCatId = "\(self.responseMain?.value?[indexPath.row].catID ?? -1)"
                nextVc.shoulShowStore = true
                nextVc.navigationItemTitle = "\(self.responseMain?.value?[indexPath.row].name ?? "Gift")"
            }else if collectionView == self.shopByOccationCollectionView{//occation
                nextVc.occationId = "\(self.responseMain?.occasion?[indexPath.row].occaID ?? -1)"
                nextVc.shoulShowStore = true
                nextVc.navigationItemTitle = "\(self.responseMain?.occasion?[indexPath.row].name ?? "Gift")"
            }else if collectionView == self.shopByStoreCollectionView{//shop
                nextVc.shopId = "\(self.responseMain?.shop?[indexPath.row].storeID ?? -1)"
                nextVc.shoulShowStore = false
                nextVc.navigationItemTitle = "\(self.responseMain?.shop?[indexPath.row].name ?? "Gift")"
            }
            
            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }
        
    }
    
    
//    //MARK:- TABBAR DELEGATE
//
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
//    func getGiftCategoriesClauserNotWorking(){
//
//        print(parentURL + giftCategoryUrl)
//
//        //let url = parentURL + giftCategoryUrl
//
////        getResponseFromServer(url: url , params: [:], vc: self, onSuccess: { (responseDict) in
////
////            print(responseDict)
////
////            let success = "\((responseDict as AnyObject).value(forKey: "code") ?? "")"
////            if success == "200"{
////
////                //self.setContentView(responseDict : responseDict)
////                let decoder = JSONDecoder()
////                //decoder.keyDecodingStrategy = .convertFromSnakeCase
////                let response = try decoder.decode(GiftHomeResponse.self, from: data)
////
////            }else{
////
////            }
////
////
////        } as! (Any) -> Void) { (error, responseError) in
////            print(error ?? "Error")
////        }
//
////        getResponseFromServer(url: "http://client.alisonsinfomatics.com/qatardeals/api.php?page=getGiftsCategory" , params: [:], vc: self, onSuccess: { (responseData) in
////
////            let decoder = JSONDecoder()
////            //decoder.keyDecodingStrategy = .convertFromSnakeCase
////            let response = try decoder.decode(GiftHomeResponse.self, from: responseData)
////            print(response)
////
////        }) { (error, responseError) in
////            print(error ?? "","\(String(describing: responseError))")
////        }
//
//    }
