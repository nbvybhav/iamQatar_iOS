//
//  MarketViewController.m
//  IamQatar
//
//  Created by alisons on 9/4/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "MarketViewController.h"
#import "MarketDetailViewController.h"
#import "constants.pch"
#import "UIImageView+WebCache.h"
#import "ProductListViewCell.h"
#import "ProductFilterCollectionViewCell.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SearchViewController.h"
#import "RetailDetailViewController.h"
#import "IamQatar-Swift.h"

@interface MarketViewController ()

@end

@implementation MarketViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    BOOL isFilterSelected;
    NSMutableArray *marketItems;
    NSMutableArray *nameArray;
    NSMutableArray *descArray;
    NSMutableArray *imageArray;
    NSMutableArray *priceArray;
    NSMutableArray *idArray;
    NSMutableArray *imgCountArray;
    NSMutableArray *stockArray;
    NSMutableArray *qtyArray;
    NSMutableArray *cat_id_array;
    NSMutableArray *cat_name_array;
    NSMutableArray *fullUrlArray;

    NSMutableArray *bannerUrlArray;
    NSMutableArray *bannerTitleArray;
    NSMutableArray *bannerDescArray;
    NSMutableArray *bannerLinkTypeArray;
    NSMutableArray *bannerPageLinkArray;
    NSMutableArray *bannerClickRedirectIdArray;
    NSMutableArray *bannerFlipsArray;
    UIButton       *searchBtnNew;

    BOOL isNewDataLoading;
    int start;
    int count;
    int deviceHieght;
}

//MARK:- VIEW DID LOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"IAQ MARKET22";
    
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    
    isNewDataLoading = false;
    
    deviceHieght = [[UIScreen mainScreen] bounds].size.height;

    //--------setting menu frame---------//
    isSelected = NO;
    menu= [[Menu alloc]init];
    NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"Menu" owner:self options:nil];
    menu = [nib1 objectAtIndex:0];
    menu.frame=CGRectMake(-290, 0, 275,deviceHieght);
    menu.delegate = self;
    [self.tabBarController.view addSubview:menu];
    menuHideTap.enabled = NO;
        [menu setHidden:YES];

    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];

    menuHideTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    [self.view addGestureRecognizer:menuHideTap];
    menuHideTap.enabled = NO;

    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    //Collectionview cell Nib registration
    [self.productListCollectionView registerNib:[UINib nibWithNibName:@"ProductListViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductListViewCell"];
    [self.filterCollectionView registerNib:[UINib nibWithNibName:@"ProductFilterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductFilterCollectionViewCell"];

    NSLog(@"selected>%@",_selectedRetailId);

    //_selectedRetailId = (NSString *)_selectedRetailId;

    //Searchbar placeholder
    if([_type isEqualToString:@"storeOffer"]||[ _selectedRetailId length]>0){
        _searchBar.placeholder = @"Search for Retail items..";
    }else{
        _searchBar.placeholder = @"Search for IAQ Market items..";
    }

    if([_selectedRetailId length]>0){   // from search
        [self getMarketItems:@"0" :@"0":_selectedRetailId];
    }else{
        [self getMarketItems:@"0" :@"0":_storeOfferId];
    }

    
    isFilterSelected = NO;
    
    
    _bannerVIewHeightConstraint.constant = self.view.frame.size.width / 1.7;
}




-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:true];
    NSString *plistVal = [[NSString alloc]init];
    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];

    if([plistVal isEqualToString:@"YES"]){
        [menu.btnLogout setTitle:@"Log In" forState:UIControlStateNormal];
    }else{
        [menu.btnLogout setTitle:@"Log Out" forState:UIControlStateNormal];
    }
    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Product screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(-290, 0, 275, deviceHieght);

//    _selectedRetailId = @"";
//    _type  =@"";
}



//MARK:- MENU SWIPE METHODS
//---------------Menu swipe---------------
-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->menu.frame=CGRectMake(-290, 0, 275, self->deviceHieght);
        self->isSelected = NO;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        self->menuHideTap.enabled = NO;
        [self->menu setHidden:YES];
    }];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self->menu setHidden:NO];
        self->menuHideTap.enabled = YES;
        self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
        self->isSelected = YES;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
}

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    // NSArray* advtImageUrlArray = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageUrl"]];

    fullUrlArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[bannerUrlArray count]; i++)
    {
        NSString *url =[NSString stringWithFormat:@"%@%@",parentURL,[bannerUrlArray objectAtIndex:i]];
        [fullUrlArray addObject:url];
    };
    NSArray *returnArray = [fullUrlArray copy];

    return returnArray;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleToFill;
}

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
    _lblbannerTitle.text = [bannerTitleArray objectAtIndex:index];
    _lblBannerDesc.text  = [bannerDescArray objectAtIndex:index];
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);

    if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"external"]){

        NSString *link = [NSString stringWithFormat:@"%@",[bannerPageLinkArray objectAtIndex:index]];

        if ([link rangeOfString:@"http://"].location == NSNotFound) {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",link]] options:@{} completionHandler:nil];
        } else {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",link]] options:@{} completionHandler:nil];
        }
    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"contest"]){
        contestViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"contestView"];
        [self.navigationController pushViewController:view animated:YES];

    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"product"]){
        MarketDetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"marketDetailView"];
        view.selectedProductId  = [bannerClickRedirectIdArray objectAtIndex:index];
        [self.navigationController pushViewController:view animated:YES];

    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"promo"]){
        RetailViewController *view= [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
        view.pushedFrom = @"categoryItem";
        view.type  = @"";
        view.catId = [bannerClickRedirectIdArray objectAtIndex:index];
        [self.navigationController pushViewController:view animated:YES];

    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"retails"]){
        MarketViewController *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"marketView"];
        NSString *selectedRetailId= [bannerClickRedirectIdArray objectAtIndex:index];
        vc.selectedRetailId = selectedRetailId;
        [self.navigationController pushViewController:vc animated:YES];

    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"events"]){
        EventsList *view = [self.storyboard instantiateViewControllerWithIdentifier:@"eventList"];
        view.eventCatId = [bannerClickRedirectIdArray objectAtIndex:index];
        view.IsCalendar = @"No";
        [self.navigationController pushViewController:view animated:YES];

    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"malls"]){
        MallDetailsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"MallDetailsViewController"];
        view.mallId = [bannerClickRedirectIdArray objectAtIndex:index];
        [self.navigationController pushViewController:view animated:YES];

    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"flyers"]){
        if ([Utility reachable]) {
            [ProgressHUD show];
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            NSString *pid       = [bannerClickRedirectIdArray objectAtIndex:index];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,getFlyers];
            NSDictionary *param = [[NSDictionary alloc]initWithObjectsAndKeys:pid,@"store_id",[appDelegate.userProfileDetails objectForKey:@"user_id"],@"user_id", nil];

//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [manager GET:urlString parameters:param headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 NSString *text = [responseObject objectForKey:@"text"];
                 if ([text isEqualToString: @"Success!"])
                 {
                     self->bannerFlipsArray        = [[responseObject objectForKey:@"flyers"]valueForKey:@"image"];
                 }

                 NSLog(@"JSON response: %@", responseObject);
                 RetailDetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"retailDetailView"];
                vc.flipsArray = self->bannerFlipsArray;
                 [self.navigationController pushViewController:vc animated:YES];
                 [ProgressHUD dismiss];

             } failure:^(NSURLSessionTask *task, NSError *error) {
                 NSLog(@"Error: %@", error);
                 [ProgressHUD dismiss];
             }];
        }
    }
}


//MARK:- API CALL
-(void)getMarketItems: (NSString *) startHere :(NSString *) countHere :(NSString *)Id
{
    if ([Utility reachable]) {
        
        start = [startHere intValue];
        count = [countHere intValue];
        
       [ProgressHUD show];
        
        NSString *urlString;
        NSDictionary *param;
        
        //For retail & hyprmarket
        if ([_selectedRetailId length]>0){
            urlString = [NSString stringWithFormat:@"%@api.php?page=getRetails&id=%@",parentURL,Id];
            param = nil;
        }else{
            
            NSLog(@"%@",_storeID);
            
            if([_type isEqualToString:@"storeOffer"]){
                urlString = [NSString stringWithFormat:@"%@%@",parentURL,getRetailUrl];
                param = [NSDictionary dictionaryWithObjectsAndKeys:Id,@"category_id",_storeID,@"store_id", nil];
            }else{
                urlString = [NSString stringWithFormat:@"%@%@",parentURL,getProductListUrl];
                param = [NSDictionary dictionaryWithObjectsAndKeys:startHere,@"start",countHere,@"count",_storeID,@"store_id",Id,@"category_id", nil];
            }
        }

        NSLog(@"%@",param);
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:urlString parameters:param headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             NSLog(@"JSON: %@", responseObject);
             self.emptyView.hidden = YES;

             if ([text isEqualToString: @"Success!"])
             {
                 NSString *bannerStr = [NSString stringWithFormat:@"%lu", [[responseObject valueForKey:@"banners"]count]];
                 if(![bannerStr isEqualToString:@"0"]){
                     self->bannerUrlArray = [[responseObject valueForKey:@"banners"]valueForKey:@"banner"];
                     self->bannerTitleArray   = [[responseObject valueForKey:@"banners"]valueForKey:@"title"];
                     self->bannerDescArray    = [[responseObject valueForKey:@"banners"]valueForKey:@"description"];
                     self->bannerLinkTypeArray = [[responseObject valueForKey:@"banners"]valueForKey:@"link_type"];
                     self->bannerPageLinkArray = [[responseObject valueForKey:@"banners"]valueForKey:@"pagelink"];
                     self->bannerClickRedirectIdArray = [[responseObject valueForKey:@"banners"]valueForKey:@"product_id"];
                 }

                 //Setting kiimagepager banner
                 self->_lblbannerTitle.text = [self->bannerTitleArray objectAtIndex:0];
                 self->_lblBannerDesc.text  = [self->bannerDescArray objectAtIndex:0];
                 self->_ivBanner.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
                 self->_ivBanner.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
                 self->_ivBanner.slideshowTimeInterval = 5.5f;
                 self->_ivBanner.slideshowShouldCallScrollToDelegate = YES;
                 self->_ivBanner.imageCounterDisabled = YES;

                 if([self->_selectedRetailId length]>0){
                     self->nameArray = [[NSMutableArray alloc]init];
                     self->imageArray = [[NSMutableArray alloc]init];
                     self->idArray = [[NSMutableArray alloc]init];
                     self->priceArray = [[NSMutableArray alloc]init];
                     self->cat_id_array = [[NSMutableArray alloc]init];
                     self->cat_name_array = [[NSMutableArray alloc]init];

                     [self->nameArray addObject:[[[responseObject valueForKey:@"value"]valueForKey:@"name"]objectAtIndex:0]];
                     [self->imageArray addObject:[[[responseObject valueForKey:@"value"]valueForKey:@"banner"]objectAtIndex:0]];
                     [self->idArray addObject:[[[responseObject valueForKey:@"value"]valueForKey:@"retail_id"]objectAtIndex:0]];
                     [self->priceArray addObject:[[[responseObject valueForKey:@"value"]valueForKey:@"shop_name"]objectAtIndex:0]];
                     [self->cat_id_array addObject:[[responseObject valueForKey:@"categories"]valueForKey:@"retail_cat_id"]];
                     [self->cat_name_array addObject:[[responseObject valueForKey:@"categories"]valueForKey:@"name"]];
                     
                     self->cat_id_array = [self->cat_id_array lastObject];
                     self->cat_name_array = [self->cat_name_array lastObject];
                 }
                 else if([self->_type isEqualToString:@"storeOffer"]){
                     self->marketItems        = [responseObject objectForKey:@"value"];
                     self->nameArray          = [self->marketItems valueForKey:@"name"];
                     self->imageArray         = [self->marketItems valueForKey:@"banner"] ;
                     self->idArray            = [self->marketItems valueForKey:@"product_id"];
                     self->priceArray         = [self->marketItems valueForKey:@"shop_name"];
                     self->cat_id_array       = [[responseObject objectForKey:@"categories"]valueForKey:@"retail_cat_id"];
                     self->cat_name_array     = [[responseObject objectForKey:@"categories"]valueForKey:@"name"];
                 }
                 else{
                     self->marketItems        = [responseObject objectForKey:@"products"];
                     self->nameArray          = [self->marketItems valueForKey:@"product_name"];
                     self->imageArray         = [self->marketItems valueForKey:@"product_image"] ;
                     self->idArray            = [self->marketItems valueForKey:@"product_id"];
                     self->priceArray         = [self->marketItems valueForKey:@"newprice"];
                     self->imgCountArray      = [self->marketItems valueForKey:@"image_count"];
                     self->stockArray         = [self->marketItems valueForKey:@"outofstock"];
                     self->qtyArray           = [self->marketItems valueForKey:@"quantity"];
                     self->descArray          = [self->marketItems valueForKey:@"product_description"];
                     self->cat_id_array       = [[responseObject objectForKey:@"categories"]valueForKey:@"cat_id"];
                     self->cat_name_array     = [[responseObject objectForKey:@"categories"]valueForKey:@"name"];
                 }

                 if ([self->nameArray count]==0){
                     self->_emptyView.hidden = NO;
                     self->nameArray = [[NSMutableArray alloc]init];
                     [self.productListCollectionView reloadData];
                 }

             }else if ([text isEqualToString: @"No records found"]){

                 self->_emptyView.hidden = NO;
                 self->nameArray = [[NSMutableArray alloc]init];
                 [self.productListCollectionView reloadData];
             }else{
                 self->_emptyView.hidden = NO;
                 self->nameArray = [[NSMutableArray alloc]init];
                 [self.productListCollectionView reloadData];
             }

             [self.productListCollectionView reloadData];
             [self.filterCollectionView reloadData];
             //[self.productListCollectionView layoutIfNeeded];


             //Setting scrollview Hieght
            int count = (int)[self->nameArray count];
             if(count%2==1){
                 count = count + 1;
             }

             //banner not needed if showing retail items list
             CGFloat collectionViewHeight = (count*240)/2 ;
            CGFloat scrollHeight = self->_bannerView.frame.size.height + self->_filterCollectionView.frame.size.height + collectionViewHeight + 20;

            if([self->_type isEqualToString:@"storeOffer"]){
//                 _searchBar.hidden = NO;
//                 _btnSearch.hidden = NO;
                 //kolamazz
                 self.navigationItem.rightBarButtonItem.tintColor = UIColor.lightGrayColor;
                 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(gotoSearch:)];
                self->_btnSearch.frame = CGRectMake(self->_btnSearch.frame.origin.x, self->_btnSearch.frame.origin.y, self->_btnSearch.frame.size.width, 70);

                self->_filterCollectionView.frame = CGRectMake(self->_filterCollectionView.frame.origin.x, self->_searchBar.frame.origin.y + self->_searchBar.frame.size.height, self->_filterCollectionView.frame.size.width, self->_filterCollectionView.frame.size.height);
                self->_productListCollectionView.frame = CGRectMake(self->_productListCollectionView.frame.origin.x, self->_filterCollectionView.frame.origin.y + self->_filterCollectionView.frame.size.height + 18, self->_productListCollectionView.frame.size.width, collectionViewHeight);
                 //_lblLineDraw.hidden = YES;

                 self.mainScrollView.scrollEnabled = YES;
                 [self.mainScrollView setContentSize:CGSizeMake(self.productListCollectionView.frame.size.width, scrollHeight)];
                 [self.view layoutIfNeeded];
             }else{
                 
                 //self.navigationItem.rightBarButtonItem = nil;

                 //_lblLineDraw.hidden = NO;

                 self.productListCollectionView.frame = CGRectMake(self.productListCollectionView.frame.origin.x, self->_bannerView.frame.size.height + self->_filterCollectionView.frame.size.height + 18, self.productListCollectionView.frame.size.width, collectionViewHeight);
                 self.mainScrollView.scrollEnabled = YES;
                 [self.mainScrollView setContentSize:CGSizeMake(self.productListCollectionView.frame.size.width, scrollHeight)];
                 [self.view layoutIfNeeded];
             }


            self->isNewDataLoading  = false;
            if([self->_selectedRetailId length]>0){
                 self->_selectedRetailId = @"";
                 self->_type  =@"storeOffer";
             }
             [ProgressHUD dismiss];
             
         } failure:^(NSURLSessionTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             [ProgressHUD dismiss];
       }];
    }else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}




//MARK:- COLLECTION VIEW DELEGTES
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1)
    {
         // Products collectionView
        if ((int)[[UIScreen mainScreen] bounds].size.height <= 568)        //iPhone 5 or less
        {
            return CGSizeMake(145 , 210);
        }
        else if((int)[[UIScreen mainScreen] bounds].size.height ==  736.0) //iPhone 6p
        {
            return CGSizeMake(190 , 230);
        }
        else if((int)[[UIScreen mainScreen] bounds].size.height ==  896.0)//iPhone XR, XSMax
        {
            return CGSizeMake(190 , 230);
        }
        else
        {
            return CGSizeMake(170 , 230);
        }

    }else{
        //Filter collectionView
        return CGSizeMake(105 , 45);
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag == 1)
    {
        // Products collectionView
        return [nameArray count];
    }else{
        //Filter collectionView
        return [cat_id_array count];
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1) // Products collectionView
    {
        ProductListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductListViewCell" forIndexPath:indexPath];
        
        cell.bgImage.layer.cornerRadius = 10.0;
        cell.bgImage.layer.masksToBounds = YES;
        
        cell.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.contentView.layer.shadowRadius = 5.0f;
        cell.contentView.layer.shadowOffset = CGSizeZero;
        cell.contentView.layer.shadowOpacity = 0.8f;
        cell.layer.masksToBounds = NO;
        _productListCollectionView.layer.masksToBounds = NO;

        NSString *subUrl = [imageArray objectAtIndex:indexPath.row];
        NSURL *imageUrl    = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,subUrl]];
        cell.productImage.contentMode   = UIViewContentModeScaleAspectFit;
        [cell.productImage sd_setImageWithURL:imageUrl];
        
        cell.lblItemName.text = [NSString stringWithFormat:@"%@",[nameArray objectAtIndex:indexPath.row]];
        if([_type isEqualToString:@"storeOffer"]||[ _selectedRetailId length]>0){
            NSString *shopName = [priceArray objectAtIndex:indexPath.row];
            cell.lblPrice.text    = [NSString stringWithFormat:@"%@",shopName];
        }else{
            float price = [[priceArray objectAtIndex:indexPath.row]floatValue];
            cell.lblPrice.text    = [NSString stringWithFormat:@"%.02f QAR",price];
        }

        //Fade out view for 'out of stock' item
        NSString *stock = [NSString stringWithFormat:@"%@",[stockArray objectAtIndex:indexPath.row]];
        NSString *qty   = [NSString stringWithFormat:@"%@",[qtyArray objectAtIndex:indexPath.row]];
        if([stock isEqualToString:@"1"]){
            cell.noStockFadeView.hidden = NO;
            //cell.imgOnSale.hidden = YES;
        }else{
            //cell.imgOnSale.hidden = NO;
            cell.noStockFadeView.hidden = YES;
        }
        
        NSString *salesTagText = [[marketItems objectAtIndex:indexPath.row] valueForKey:@"sale_tag_text"];
        
        if ([salesTagText  isEqual: @""]){
            cell.saleTagView.hidden = true;
        }else{
            cell.saleTagView.hidden = false;
            cell.lblSalesTag.text = salesTagText;
        }

        return cell;
    }else{//Filter collectionView
        
        
        ProductFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductFilterCollectionViewCell" forIndexPath:indexPath];
        NSString *bgImage;
        NSInteger index = indexPath.row+1;
        
        //Logic for reeating bg gradient
        if (index>3) {
            index = index%3;
            if(index==0){
                index=1;
            }
            bgImage =[NSString stringWithFormat:@"grad%ld.png",(long)index];
        }else{
            bgImage =[NSString stringWithFormat:@"grad%ld.png",(long)index];
        }
      
        [cell.filterBtn setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
        //[cell.filterBtn setTitle:[cat_name_array objectAtIndex:indexPath.row] forState:UIControlStateNormal];

        cell.lblText.text = [NSString stringWithFormat:@"%@",[cat_name_array objectAtIndex:indexPath.item]];
        CGSize textSize;
        textSize = [[cat_name_array objectAtIndex:indexPath.item]
                    sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:12.0]}];
        
        [cell.lblText sizeThatFits:textSize];
        cell.filterBtn.frame = cell.lblText.frame;
        
        //OfferBtn is used as olor gradient
        [cell.filterBtn addCornerRadius:3];//.layer.cornerRadius = 3;
        //[cell.filterBtn addGradientWithColorOne: nil colorTwo:nil];
        cell.filterBtn.clipsToBounds = true;
          

        return  cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if(collectionView.tag == 1)
    {
        //Main collectionview
        if([_type isEqualToString:@"storeOffer"]||[ _selectedRetailId length]>0){
            NSLog(@"Store Offer or Clicked from banner");
        }else{
            MarketDetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"marketDetailView"];
            vc.selectedProductId = [idArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];

//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCATransactionAnimationTimingFunction];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromRight;
//            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//            [self.navigationController pushViewController:vc animated:NO];
        }
    }else{
        //Filter collectionview
        isFilterSelected = YES;
        [self getMarketItems:@"0" :@"0" :[NSString stringWithFormat:@"%@",[cat_id_array objectAtIndex:indexPath.row]]];
    }
}

//MARK:- TAB BAR DELEGATES
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
    {
        if (isSelected)
        {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->isSelected = NO;
                self->menu.frame=CGRectMake(-290, 0, 275, self->deviceHieght);
            } completion:^(BOOL finished){
                // if you want to do something once the animation finishes, put it here
                self->menuHideTap.enabled = NO;
        [self->menu setHidden:YES];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self->menu setHidden:NO];
                self->menuHideTap.enabled = YES;
                self->isSelected = YES;
                
                if ([[UIScreen mainScreen] bounds].size.height == 736.0){
                    self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
                }
                else if([[UIScreen mainScreen] bounds].size.height == 667.0){
                    self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
                }
                else{
                    self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
                }
                
            } completion:^(BOOL finished){
                // if you want to do something once the animation finishes, put it here
            }];
        }
        return NO;
    }
    else if (viewController == [self.tabBarController.viewControllers objectAtIndex:3])
    {
        if(isFilterSelected)
        {
            if([_selectedRetailId length]>0){   // from search
                [self getMarketItems:@"0" :@"0":_selectedRetailId];
            }else{
                [self getMarketItems:@"0" :@"0":_storeOfferId];
            }
            isFilterSelected = NO;
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }


        //return NO;
    }else if(viewController == [self.tabBarController.viewControllers objectAtIndex:1]){
        //Jump to login screen
        NSString *plistVal = [[NSString alloc]init];
        plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];

        if([plistVal isEqualToString:@"YES"]){
            //[AlertController alertWithMessage:@"Please Login!" presentingViewController:self];
            [Utility guestUserAlert:self];
            return NO;
        }else{
            return YES;
        }
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(0, 625, 275, 335);
}

- (IBAction)searchTap:(id)sender {
    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];

    //Setting searchbar placeholder
    if([_type isEqualToString:@"storeOffer"]||[ _selectedRetailId length]>0){
        vc.searchType = @"retails";
    }else{
        vc.searchType = @"product";
    }


    [self.navigationController pushViewController:vc animated:false];
}

#pragma mark - PopUpMenu delegates
-(void)todaysDeal:(Menu *)sender{
    RetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
    view.pushedFrom = @"todaysDeal";
    [self.navigationController pushViewController:view animated:YES];
}
-(void)whatsNew:(Menu *)sender{
    RetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
    view.pushedFrom = @"whatsNew";
    [self.navigationController pushViewController:view animated:YES];
}
-(void)emergencyContact:(Menu *)sender{
    emergencyContactViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"contactView"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)contest:(Menu *)sender{

    NSString *plistVal = [[NSString alloc]init];
    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];

    if([plistVal isEqualToString:@"YES"]){
        LoginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];

        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
        [self.navigationController presentViewController:view animated:NO completion:nil];
    }else{
        contestViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"contestView"];
        [self.navigationController pushViewController:view animated:YES];
    }
}
-(void)GoProfilePage:(Menu *)sender{

    NSString *plistVal = [[NSString alloc]init];
    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];

    if([plistVal isEqualToString:@"YES"]){
        LoginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
        [self.navigationController presentViewController:view animated:NO completion:nil];
    }else{
        ProfileViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
        [self.navigationController pushViewController:view animated:YES];
    }
}
-(void)GoAboutUsPage:(Menu *)sender{
    AboutUsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutUsView"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)History:(Menu *)sender{

    NSString *plistVal = [[NSString alloc]init];
    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];

    if([plistVal isEqualToString:@"YES"]){
        LoginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];

        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
        [self.navigationController presentViewController:view animated:NO completion:nil];
    }else{
        OrderHistoryNewViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryNewViewController"];
        [self.navigationController pushViewController:view animated:YES];
    }
}
-(void)ContactUs:(Menu *)sender{
    ContactUsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)goTermsOfUse:(Menu *)sender{
    TermsAndConditionsVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsAndConditionsVC"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)LogOut:(Menu *)sender{
    LoginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
    
    //G+ signout
    GIDSignIn *signin = [GIDSignIn sharedInstance];
    [signin signOut];
    
    //Logout plist clear
    [Utility addtoplist:@"" key:@"login" plist:@"iq"];

    //Resetting 'skipped user' value
    [Utility addtoplist:@"NO"key:@"skippedUser" plist:@"iq"];
    
    
    [self.navigationController presentViewController:view animated:NO completion:nil];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



//MARK:- GO TO SEARCH
-(void)viewDidAppear:(BOOL)animated
{
    if(![_type isEqualToString:@"storeOffer"]){
        [[self view] layoutIfNeeded];

//        searchBtnNew = [[UIButton alloc]init];
//        searchBtnNew.frame = CGRectMake([self view].frame.size.width - 50, 20, 25, 25);
//        [searchBtnNew setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
//        [searchBtnNew addTarget:self action:@selector(gotoSearch:) forControlEvents:UIControlEventTouchUpInside];
//        [[self mainScrollView] addSubview:searchBtnNew];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(gotoSearch:)];
        self.navigationItem.rightBarButtonItem.tintColor = UIColor.lightGrayColor;
    }
}
- (void) gotoSearch:(UIButton *) sender
{
    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];
    //Setting searchbar placeholder
    if([_type isEqualToString:@"storeOffer"]||[ _selectedRetailId length]>0){
        vc.searchType = @"retails";
    }else{
        vc.searchType = @"product";
    }
    
    [self.navigationController pushViewController:vc animated:false];
}


@end
