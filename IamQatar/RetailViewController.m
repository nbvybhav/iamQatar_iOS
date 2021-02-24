//
//  RetailViewController.m
//  IamQatar
//
//  Created by alisons on 9/4/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "RetailViewController.h"
#import "RetailCell.h"
#import "RetailDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "constants.pch"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MarketDetailViewController.h"
#import "EXPhotoViewer.h"
#import "IamQatar-Swift.h"

@interface RetailViewController ()

@end

@implementation RetailViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    NSMutableArray *retailItems;
    NSMutableArray *bannerArray;
    NSMutableArray *bigImgArray;
    NSMutableArray *idArray;
    NSMutableArray *flipsArray;
    NSMutableArray *linkArray;
    NSMutableArray *linkTypeArray;
    NSMutableArray *productIdArray;
    NSMutableArray *titleArray;
    NSMutableArray *addressArray;
    NSMutableArray *valadityArray;
    NSMutableArray *expiryDateArray;
    NSMutableArray *offerArray;
    NSMutableArray *marketItems;
    int deviceHieght;
}

//MARK:- VIEW DID LOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];

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
    
    self.title = @"SALES & PROMOTIONS";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(gotoSearch:)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColor.lightGrayColor;
}

- (void) gotoSearch:(UIButton *) sender
{
    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];

    if([_pushedFrom isEqualToString:@"todaysDeal"])
    {
        vc.searchType = @"todaysdeals";
    }else if([_pushedFrom isEqualToString:@"whatsNew"])
    {
       vc.searchType = @"whatsNew";
    }else if ([_pushedFrom isEqualToString:@"categoryItem"])
    {
       vc.searchType = @"promotions";
    }
    else{
       vc.searchType = @"retails";
    }

    [self.navigationController pushViewController:vc animated:false];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:true];
    [super viewWillAppear:animated];

    NSString *plistVal = [[NSString alloc]init];
    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];

    if([plistVal isEqualToString:@"YES"]){
        [menu.btnLogout setTitle:@"Log In" forState:UIControlStateNormal];
    }else{
        [menu.btnLogout setTitle:@"Log Out" forState:UIControlStateNormal];
    }

    //-----showing tabar item at index 2 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;
    
    if([_pushedFrom isEqualToString:@"todaysDeal"])
    {
        //Google Analytics tracker
        id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
        [tracker set:kGAIScreenName value:@"Todays deal"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        _searchBar.placeholder  = @"Search for Todays deal";

        [self getTodaysDealItems];
    }else if([_pushedFrom isEqualToString:@"whatsNew"])
    {
        //Google Analytics tracker
        id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
        [tracker set:kGAIScreenName value:@"Whats new"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
         _searchBar.placeholder  = @"Search for Whats new";
        
        [self getWhatsNewItems];
    }else if ([_pushedFrom isEqualToString:@"categoryItem"])
    {
        //Google Analytics tracker
        id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
        [tracker set:kGAIScreenName value:@"Sales & promo"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        _searchBar.placeholder  = @"Search for Sales & Promo";

        [self getCategoryItems];
    }
    else{
        _pushedFrom =@"retail";
        [self getRetailItems];
    }
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    //-----showing tabar item at index 2 (back button)-------//
//    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
//    self.tabBarController.delegate = self;
//}

-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(-290, 0, 275, deviceHieght);
    
    retailItems      = nil;
    bannerArray      = nil;
    idArray          = nil;
    bigImgArray      = nil;
}



//MARK:- MENU SWIPE
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


//MARK:- API CALL
-(void)getTodaysDealItems{
    
    if ([Utility reachable]) {

        [ProgressHUD show];
        NSString *urlString;

        //If coming from search page
        if (_selectedSearchItem != nil){
            urlString = [NSString stringWithFormat:@"%@api.php?page=getTodaysDeals&id=%@",parentURL,_selectedSearchItem];
        }else{ //else
            urlString = [NSString stringWithFormat:@"%@%@",parentURL,todaysDeailAPI];
        }

        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             
             if ([text isEqualToString: @"Success!"])
             {
                 self->retailItems      = [responseObject objectForKey:@"value"];
                 self->bannerArray      = [self->retailItems valueForKey:@"banner"];
                 self->idArray          = [self->retailItems valueForKey:@"id"];
                 self->linkArray        = [self->retailItems valueForKey:@"pagelink"];
                 self->linkTypeArray    = [self->retailItems valueForKey:@"link_type"];
                 self->productIdArray   = [self->retailItems valueForKey:@"product_id"];
                 self->bigImgArray      = [self->retailItems valueForKey:@"image"];
                 self->titleArray       = [self->retailItems valueForKey:@"name"];
                 self->flipsArray       = [[self->retailItems valueForKey:@"flips"]valueForKey:@"image"];
             }
             
            if([self->flipsArray count]<1)
             {
                 self->_lblNoRecords.hidden = NO;
             }else{
                 self->_lblNoRecords.hidden = YES;
             }
             
             NSLog(@"JSON: %@", responseObject);
             [self.retailTableView reloadData];
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

-(void)getWhatsNewItems{
    
    if ([Utility reachable]) {
    
       [ProgressHUD show];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,whatsNewAPI];
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             
             if ([text isEqualToString: @"Success!"])
             {
                 self->retailItems      = [responseObject objectForKey:@"value"];
                 self->bannerArray      = [self->retailItems valueForKey:@"banner"];
                 self->idArray          = [self->retailItems valueForKey:@"id"];
                 self->linkArray        = [self->retailItems valueForKey:@"pagelink"];
                 self->linkTypeArray    = [self->retailItems valueForKey:@"link_type"];
                 self->productIdArray   = [self->retailItems valueForKey:@"product_id"];
                 self->bigImgArray      = [self->retailItems valueForKey:@"image"];
                 self->titleArray       = [self->retailItems valueForKey:@"name"];
             }
             
            if([self->bannerArray count]<1)
             {
                 self->_lblNoRecords.hidden = NO;
             }else{
                 self->_lblNoRecords.hidden = YES;
             }
             
             NSLog(@"JSON: %@", responseObject);
             [self.retailTableView reloadData];
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

-(void)getCategoryItems
{
    if ([Utility reachable]) {
    
        [ProgressHUD show];
        NSString *urlString;

        if (_selectedSearchItem != nil){
            urlString = [NSString stringWithFormat:@"%@api.php?page=getSales_Promotions&id=%@",parentURL,_selectedSearchItem];
        }else{
            if ([_type  isEqual: @"OfferFilter"]) {
                urlString = [NSString stringWithFormat:@"%@api.php?page=getSales_Promotions&offer_id=%@",parentURL,_catId];
            }else {
                urlString = [NSString stringWithFormat:@"%@api.php?page=getSales_Promotions&category_id=%@",parentURL,_catId];
            }
        }
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             NSLog(@"JSON: %@", responseObject);
             
             if ([text isEqualToString: @"Success!"])
             {
                 self->retailItems      = [responseObject objectForKey:@"value"];
                 self->bannerArray      = [self->retailItems valueForKey:@"banner"];
                 self->bigImgArray      = [self->retailItems valueForKey:@"image"];
                 self->idArray          = [self->retailItems valueForKey:@"promo_id"];
                 self->linkArray        = [self->retailItems valueForKey:@"pagelink"];
                 self->linkTypeArray    = [self->retailItems valueForKey:@"link_type"];
                 self->productIdArray   = [self->retailItems valueForKey:@"product_id"];
                 self->titleArray       = [self->retailItems valueForKey:@"name"];
                 self->addressArray     = [self->retailItems valueForKey:@"address"];
                 self->valadityArray    = [self->retailItems valueForKey:@"validity"];//expiry_date
                 self->expiryDateArray  = [self->retailItems valueForKey:@"expiry_date"];
                 self->offerArray       = [self->retailItems valueForKey:@"offer"];
             }
             
            if([self->bannerArray count]<1)
             {
                 self->_lblNoRecords.hidden = NO;
             }else{
                 self->_lblNoRecords.hidden = YES;
             }
             
             
             [self.retailTableView reloadData];
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

-(void)getRetailItems {
    if ([Utility reachable]) {
        
        [ProgressHUD show];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,getRetailUrl];
        NSDictionary *param = [NSDictionary dictionaryWithObject:_catId forKey:@"store_id"];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             NSLog(@"JSON: %@", responseObject);
             
             if ([text isEqualToString: @"Success!"])
             {
                 self->retailItems      = [responseObject objectForKey:@"value"];
                 self->bannerArray      = [self->retailItems valueForKey:@"banner"];
                 self->idArray          = [self->retailItems valueForKey:@"retail_id"];
                 self->flipsArray       = [[self->retailItems valueForKey:@"flips"]valueForKey:@"image"];
                 self->titleArray       = [self->retailItems valueForKey:@"name"];
                 
             }
             
            if([self->bannerArray count]<1)
             {
                 self->_lblNoRecords.hidden = NO;
             }else{
                 self->_lblNoRecords.hidden = YES;
             }
             
             
             [self.retailTableView reloadData];
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

//MARK:- TABLE VIEW DELEGATES
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat ht;
    if ([_pushedFrom isEqualToString:@"retail"]) {
        ht = 150.0;
    }else{
        ht = 328;
    }
    return ht;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [bannerArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RetailCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RetailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    // ... set up the cell here ...
   
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,[bannerArray objectAtIndex:indexPath.row]]];
    cell.backgroundColor = [UIColor whiteColor];
    cell.expiryDateBg.layer.cornerRadius = 10.0;
    cell.expiryDateBg.layer.masksToBounds= YES;
    
    cell.lblExpiryDate.hidden = YES;
    cell.expiryDateBg.hidden  = YES;
    
    cell.continerView.layer.cornerRadius = 10.0;
    cell.continerView.layer.masksToBounds= YES;
    [cell.shadowView.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.shadowView.layer setShadowOpacity:0.2];
    [cell.shadowView.layer setShadowRadius:5.0];
    [cell.shadowView.layer setShadowOffset:CGSizeMake(2.0, 5.0)];

    cell.ivBgImage.contentMode   = UIViewContentModeScaleToFill;
    cell.ivBgImage.clipsToBounds = true;

    int deviceWidth = [UIScreen mainScreen].bounds.size.width;
    [cell.ivBgImage sd_setImageWithURL:imageUrl];

//    [cell.ivBgImage sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            float widthRatio = cell.ivBgImage.bounds.size.width / cell.ivBgImage.image.size.width;
//            float heightRatio = cell.ivBgImage.bounds.size.height / cell.ivBgImage.image.size.height;
//            float scale = MIN(widthRatio, heightRatio);
//            float imageWidth = scale * cell.ivBgImage.image.size.width;
//            float imageHeight = scale * cell.ivBgImage.image.size.height;
//
//            cell.ivBgImage.frame = CGRectMake(0, 0, imageWidth, imageHeight);
//            cell.ivBgImage.center = cell.ivBgImage.superview.center;
//    }];


    cell.lblTitle.text   = [titleArray objectAtIndex:indexPath.row];
    cell.lblAddress.text = [addressArray objectAtIndex:indexPath.row];
    cell.lblOffer.text   = [offerArray objectAtIndex:indexPath.row];
    
    if(![[valadityArray objectAtIndex:indexPath.row]isEqualToString:@""] && ![_pushedFrom isEqualToString:@"todaysDeal"]){
         cell.lblExpiryDate.hidden = NO;
         cell.expiryDateBg.hidden  = NO;

        //Date Formatting
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *expiryDate = [[NSDate alloc] init];
        expiryDate = [dateFormatter dateFromString:[expiryDateArray objectAtIndex:indexPath.row]];

        // converting into our required date format
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        NSString *reqDateStr = [dateFormatter stringFromDate:expiryDate];


        cell.lblExpiryDate.text   = [NSString stringWithFormat:@"Valid till: %@",reqDateStr];
        
        float widthIs = cell.lblExpiryDate.intrinsicContentSize.width+60;
        
        cell.lblExpiryDate.frame = CGRectMake(cell.lblExpiryDate.frame.origin.x, cell.lblExpiryDate.frame.origin.y, widthIs, cell.lblExpiryDate.frame.size.height);
        cell.expiryDateBg.frame = CGRectMake(cell.expiryDateBg.frame.origin.x, cell.expiryDateBg.frame.origin.y, widthIs, cell.expiryDateBg.frame.size.height);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RetailDetailViewController *view= [self.storyboard instantiateViewControllerWithIdentifier:@"retailDetailView"];

    if ([[linkTypeArray objectAtIndex:indexPath.row]isEqual:@"product"])
    {
        if ([Utility reachable]) {
            [ProgressHUD show];
            NSString *pid = [productIdArray objectAtIndex:indexPath.row];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,getProductDetails];
            NSDictionary *param = [[NSDictionary alloc]initWithObjectsAndKeys:pid,@"product_id", nil];

//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [manager GET:urlString parameters:param headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 NSString *text = [responseObject objectForKey:@"text"];
                 if ([text isEqualToString: @"Success!"])
                 {
                     self->marketItems        = [responseObject objectForKey:@"value"];
                 }

                 NSLog(@"JSON: %@", responseObject);
                 MarketDetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"marketDetailView"];
                 view.selectedProductId = pid;
                 //view.productId              = pid;

                 [self.navigationController pushViewController:view animated:YES];
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
    else if (![[linkArray objectAtIndex:indexPath.row] isEqualToString:@""])
    {
      NSURL *url ;

        NSString *myURLString = [linkArray objectAtIndex:indexPath.row];

        if ([myURLString.lowercaseString hasPrefix:@"http://"]||[myURLString.lowercaseString hasPrefix:@"https://"]) {
            url = [NSURL URLWithString:myURLString];
        } else {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",myURLString]];
        }

//        [[UIApplication sharedApplication] openURL:url];
        UIApplication *application = [UIApplication sharedApplication];
//        NSURL *URL = [NSURL URLWithString:simple];
        [application openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                 NSLog(@"Opened url");
            }
        }];
    }else if([[flipsArray objectAtIndex:indexPath.row] count]>0)
    {
            view.flipsArray = [flipsArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:view animated:YES];

    }else{
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,[bigImgArray objectAtIndex:indexPath.row]]];
        UIImageView *iv= [[UIImageView alloc]init];
        iv.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        [EXPhotoViewer showImageFrom:iv];
    }
}

//MARK:- TAB BAR DELEGATES
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
    {
        if (isSelected) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->isSelected = NO;
                self->menu.frame=CGRectMake(-290, 0, 275, self->deviceHieght);
            } completion:^(BOOL finished){
                // if you want to do something once the animation finishes, put it here
                self->menuHideTap.enabled = NO;
                [self->menu setHidden:YES];
            }];
        }else{
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self->menu setHidden:NO];
                self->menuHideTap.enabled = YES;
                self->isSelected = YES;
                
                if ([[UIScreen mainScreen] bounds].size.height == 736.0){
                    self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
                }
                else if([[UIScreen mainScreen] bounds].size.height == 667.0){
                    self->menu.frame=CGRectMake(0, 0, 275,self->deviceHieght );
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
        //[self.navigationController popViewControllerAnimated:YES];
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

//MARK:- BTN ACTONS
- (IBAction)searchAction:(id)sender {
    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];

    if([_pushedFrom isEqualToString:@"todaysDeal"])
    {
        vc.searchType = @"todaysdeals";
    }else if([_pushedFrom isEqualToString:@"whatsNew"])
    {
       vc.searchType = @"whatsNew";
    }else if ([_pushedFrom isEqualToString:@"categoryItem"])
    {
       vc.searchType = @"promotions";
    }
    else{
       vc.searchType = @"retails";
    }

    [self.navigationController pushViewController:vc animated:false];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    menuHideTap.enabled = NO;
        [menu setHidden:YES];
//    isSelected = NO;
//    menu.frame=CGRectMake(0, 625, 275, 335);
}

//MARK:- POP UP MENU DELEGATES
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

@end
