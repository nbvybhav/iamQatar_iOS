

//
//  MainCategoryViewController.m
//  IamQatar
//
//  Created by alisons on 11/18/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "MainCategoryViewController.h"
#import "constants.pch"
#import "LoginViewController.h"
#import "historyListViewController.h"
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>
#import "AddAddressViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MainCatCollectionViewCell.h"
#import "categoryViewController.h"
#import "EventsHome.h"
#import "MallListViewController.h"
#import "OrderHistoryViewController.h"
#import "ProductListViewCell.h"
#import "RetailDetailViewController.h"
#import "GiftCategoryViewController.h"
#import "EventDetalPage.h"
#import "IamQatar-Swift.h"
#import <Twitter/Twitter.h>

@interface MainCategoryViewController ()

@end

@implementation MainCategoryViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    NSMutableArray *fullUrlArray;
    NSArray *advtLinkArray ;
    NSArray *cat_icon_array;
    NSArray *cat_id_array;
    NSArray *cat_name_array;
    NSArray *cat_status_array;
    NSArray *cat_type_array;
    NSArray *cat_item_id_array;
    
    NSArray *featured_name_array;
    NSArray *featured_price_array;
    NSArray *featured_image_array;
    NSArray *featured_id_array;
    NSArray *stock_array;
    NSArray *featuredItemsArray;
    
    NSArray *newArrival_name_array;
    NSArray *newArrival_price_array;
    NSArray *newArrival_image_array;
    NSArray *newArrival_id_array;
    NSArray *newArrivalStock_array;
    NSArray *newArrivalArray;
    
    NSMutableArray *fullCategoryDetails;
    NSMutableArray *advtImageUrlArray;
    NSMutableArray *bannerTitleArray;
    NSMutableArray *bannerDescArray;
    int deviceHieght;
    
    NSMutableArray *bannerLinkTypeArray;
    NSMutableArray *bannerPageLinkArray;
    NSMutableArray *bannerClickRedirectIdArray;
    NSMutableArray *bannerFlipsArray;
    NSTimer *featureListTimer;
    
}
- (IBAction)testAction:(UIButton *)sender {
    
    
    //kolamazz
    //    GiftboxHomeViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"GiftboxHomeViewController"];
    //    [self.navigationController pushViewController:vc animated:YES];
    //
    GiftboxHomeViewController *vc = [[GiftboxHomeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    //    GiftCategoryViewController *vc = [[GiftCategoryViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)viewDidLoad {
    
    FOUNDATION_EXPORT const unsigned char FrameworkVersionString[];
    
    
    //self.title = @"I AM QATAR";
    //UIImage *img = [UIImage imageNamed:@"iq logo.png"];
    //    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //    [imgView setImage:img];
    //    // setContent mode aspect fit
    //    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    //    self.navigationItem.titleView = imgView;
    
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"logo_bottom"]
                                     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarController.tabBar.items.lastObject.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    
    cat_name_array = [[NSArray alloc]init];
    advtLinkArray  = [[NSArray alloc]init];
    cat_icon_array = [[NSArray alloc]init];
    cat_id_array   = [[NSArray alloc]init];
    cat_status_array = [[NSArray alloc]init];
    cat_type_array = [[NSArray alloc]init];
    cat_item_id_array = [[NSArray alloc]init];
    
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
    
    UISwipeGestureRecognizer * swipeleftMenu=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleftMenu.direction=UISwipeGestureRecognizerDirectionLeft;
    [menu addGestureRecognizer:swipeleftMenu];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    menuHideTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    [self.view addGestureRecognizer:menuHideTap];
    menuHideTap.enabled = NO;
    
    menuHideTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    [self.view addGestureRecognizer:menuHideTap];
    menuHideTap.enabled = NO;
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    
    //Setting shadow and corner radius for imageview
    _shadowView.backgroundColor = [UIColor clearColor];
    [_shadowView  addSubview:_ivAdvt];
    [_shadowView addSubview:_ivAdvt];
    
    _ivAdvt.layer.masksToBounds = YES;
    _shadowView.layer.masksToBounds = NO;
    // set imageview corner
    //_ivAdvt.layer.cornerRadius = 10.0;
    // set avatar imageview border
    [_ivAdvt.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [_ivAdvt.layer setBorderWidth: 2.0];
    // set holder shadow
    [_shadowView.layer setShadowOffset:CGSizeZero];
    [_shadowView.layer setShadowOpacity:0.5];
    _shadowView.clipsToBounds = NO;
    
    //Title attribute string
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: _lblTitle.attributedText];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor orangeColor]
                 range:NSMakeRange(0, 3)];
    [_lblTitle setAttributedText: text];
    
    //collectionview cell Nib registration
    [self.mainCatCollectionview registerNib:[UINib nibWithNibName:@"MainCatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MainCatCollectionViewCell"];
    _mainCatCollectionview.clipsToBounds = NO;
    [self.featuredProductsCollectionView registerNib:[UINib nibWithNibName:@"ProductListViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductListViewCell"];
    _featuredProductsCollectionView.clipsToBounds = NO;
//    [self.neewArrivalCollectionView registerNib:[UINib nibWithNibName:@"ProductListViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductListViewCell"];
//    _neewArrivalCollectionView.clipsToBounds = NO;
    
    //Tab bar tintcolor
    self.tabBarController.tabBar.tintColor = [UIColor lightGrayColor];
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor lightGrayColor];
    
    _bannerViewHeightConstraint.constant = self.view.frame.size.width / 1.7;
    
    
    
    //tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    self.tabBarController.tabBarItem.imageInsets = UIEdgeInsetsMake(20, 20, 20, 20 );
    
    
    //OBSERVE ORDER SUCCESFULY PLACED NOTIFICATION AND MOVE TO MARKET DETIALS
    [[NSNotificationCenter defaultCenter] addObserverForName:@"DEL_SUCCESS_NOTI" object:nil queue:nil usingBlock:^(NSNotification *note)
     {
        NSLog(@"The action I was waiting for is complete!!!");
        
        [self gotoFirstVc];
        
        MarketViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"marketView"];
        [self.navigationController pushViewController:vc animated:FALSE];
        
        self.tabBarController.selectedIndex = 2;
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}




-(void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    
    [featureListTimer invalidate];
    menuHideTap.enabled = NO;
    menuHideTap.enabled = NO;
    [menu setHidden:YES];
    isSelected = NO;
    menu.frame = CGRectMake(-290, 0, 275, deviceHieght);
    
    //[[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:FALSE] ;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:true];
    
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:TRUE animated:YES];
    [super viewWillAppear:YES];
    [self getAdDetails:^(BOOL finished) {
        if(finished){
            [self->_mainCatCollectionview reloadData];
            [self->_featuredProductsCollectionView reloadData];
//            [self->_neewArrivalCollectionView reloadData];
            
            //sliding banner imageView
            self->_bannerTitleLbl.text = [self->bannerTitleArray objectAtIndex:0];
            self->_bannerDescLbl.text  = [self->bannerDescArray objectAtIndex:0];
            self->_ivAdvt.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
            self->_ivAdvt.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
            self->_ivAdvt.slideshowTimeInterval = 5.5f;
            self->_ivAdvt.slideshowShouldCallScrollToDelegate = YES;
            self->_ivAdvt.imageCounterDisabled = YES;
            
            //Setting collectionview hieght based on content
            CGRect rectangle;
            rectangle = self.mainCatCollectionview.frame;
            rectangle.size = [self.mainCatCollectionview.collectionViewLayout collectionViewContentSize];
            self.mainCatCollectionview.frame = rectangle;
            self.catCollectionViewHeightConstraint.constant = rectangle.size.height;
            
            self->_lblFeaturedProducts.frame = CGRectMake(self->_lblFeaturedProducts.frame.origin.x, self->_mainCatCollectionview.frame.origin.y+self->_mainCatCollectionview.frame.size.height+10, self->_lblFeaturedProducts.frame.size.width, self->_lblFeaturedProducts.frame.size.height);
            
//            self->_featuredProductsCollectionView.frame = CGRectMake(self->_featuredProductsCollectionView.frame.origin.x, self->_lblFeaturedProducts.frame.origin.y+self->_lblFeaturedProducts.frame.size.height+10, self->_featuredProductsCollectionView.frame.size.width, self->_featuredProductsCollectionView.frame.size.height);
            
            self->_featuredProductsCollectionView.frame = CGRectMake(self->_featuredProductsCollectionView.frame.origin.x, self->_lblFeaturedProducts.frame.origin.y+self->_lblFeaturedProducts.frame.size.height+25, self->_featuredProductsCollectionView.frame.size.width, self->_featuredProductsCollectionView.frame.size.height);
            
//            self->_lblNeewArrival.frame = CGRectMake(self->_lblNeewArrival.frame.origin.x, self->_featuredProductsCollectionView.frame.origin.y+self->_featuredProductsCollectionView.frame.size.height+10, self->_lblNeewArrival.frame.size.width, self->_lblNeewArrival.frame.size.height);
//
//            self->_neewArrivalCollectionView.frame = CGRectMake(self->_neewArrivalCollectionView.frame.origin.x, self->_lblNeewArrival.frame.origin.y+self->_lblNeewArrival.frame.size.height+10, self->_neewArrivalCollectionView.frame.size.width, self->_neewArrivalCollectionView.frame.size.height);
            
            //Setting main scrollview Hieght
            self.mainScrollView.scrollEnabled = YES;
            [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self->_featuredProductsCollectionView.frame.origin.y + self->_featuredProductsCollectionView.frame.size.height+40)];
//            [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self->_neewArrivalCollectionView.frame.origin.y + self->_neewArrivalCollectionView.frame.size.height+20)];
            [self addTimer];
        }
    }];
    
    
    NSString *plistVal = [[NSString alloc]init];
    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];
    
    if([plistVal isEqualToString:@"YES"]){
        [menu.btnLogout setTitle:@"Log In" forState:UIControlStateNormal];
    }else{
        [menu.btnLogout setTitle:@"Log Out" forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotifier) name:@"UIApplicationDidBecomeActiveNotification" object:nil];
    
    //Cart check
    long cartCount = [[Utility getfromplist:@"cartCount" plist:@"iq"]integerValue];
    
    if (cartCount != 0) {
        NSString * value=[NSString stringWithFormat:@"%ld",cartCount];
        [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:value];
    }else{
        [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:nil];
    }
    
    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"HomeScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    //-----hiding tabar item at index 4 (back button)-------//
    //[[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:YES] ;
    //[[[self.tabBarController.tabBar subviews]objectAtIndex:4] setAlpha:0.5] ;
    self.tabBarController.delegate = self;
    //[self.tabBarController.tabBarItem setBadgeColor:[UIColor greenColor]];
    
    //    for (int i = 0; i < [[self.tabBarController.tabBar subviews] count]; i++) {
    //
    //        [[[self.tabBarController.tabBar subviews] objectAtIndex:i] setAccessibilityLabel:@"pala"];
    //
    //    }
    
    
    //    for (int i = 0; i < [[self.tabBarController.tabBar subviews] count]; i++) {
    //        printf("kola tag : %s", [[[self.tabBarController.tabBar subviews] objectAtIndex:i] accessibilityLabel]);
    //    }
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


//MARK: Featured product cell autoscroll
- (void)addTimer{
    featureListTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:featureListTimer forMode:NSRunLoopCommonModes];
    //self.timer = timer;
}
- (void)nextPage{
    
    CGRect visibleRect = (CGRect){.origin = _featuredProductsCollectionView.contentOffset, .size = _featuredProductsCollectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [_featuredProductsCollectionView indexPathForItemAtPoint:visiblePoint];
    
    if(visibleIndexPath.row == [featured_id_array count]-2){
        //If current cell is 'last cell' scroll to first one back
        [_featuredProductsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                                atScrollPosition:UICollectionViewScrollPositionLeft
                                                        animated:true];
    }else{
        //get cell size
        CGSize cellSize = CGSizeMake(self.featuredProductsCollectionView.frame.size.width, self.featuredProductsCollectionView.frame.size.height);
        
        //get current content Offset of the Collection view
        CGPoint contentOffset = _featuredProductsCollectionView.contentOffset;
        
        //scroll to next cell
        [_featuredProductsCollectionView scrollRectToVisible:CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height) animated:true];
    }

//    CGRect visibleRect1 = (CGRect){.origin = _neewArrivalCollectionView.contentOffset, .size = _neewArrivalCollectionView.bounds.size};
//    CGPoint visiblePoint1 = CGPointMake(CGRectGetMidX(visibleRect1), CGRectGetMidY(visibleRect1));
//    NSIndexPath *visibleIndexPath1 = [_neewArrivalCollectionView indexPathForItemAtPoint:visiblePoint1];
//
//    if(visibleIndexPath1.row == [newArrival_id_array count]-2){
//        //If current cell is 'last cell' scroll to first one back
//        [_neewArrivalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
//                                                atScrollPosition:UICollectionViewScrollPositionLeft
//                                                        animated:true];
//    }else{
//        //get cell size
//        CGSize cellSize = CGSizeMake(self.neewArrivalCollectionView.frame.size.width, self.neewArrivalCollectionView.frame.size.height);
//
//        //get current content Offset of the Collection view
//        CGPoint contentOffset = _neewArrivalCollectionView.contentOffset;
//
//        //scroll to next cell
//        [_neewArrivalCollectionView scrollRectToVisible:CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height) animated:true];
//    }
    
}




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
        self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);self->
        isSelected = YES;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
}

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    // NSArray* advtImageUrlArray = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageUrl"]];
    
    fullUrlArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[advtImageUrlArray count]; i++)
    {
        NSString *url =[NSString stringWithFormat:@"%@%@",parentURL,[advtImageUrlArray objectAtIndex:i]];
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
    _bannerTitleLbl.text = [bannerTitleArray objectAtIndex:index];
    _bannerDescLbl.text  = [bannerDescArray objectAtIndex:index];
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
        
    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"promo_item"]){
        RetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
        vc.pushedFrom = @"categoryItem";
        vc.type  = @"";
        vc.selectedSearchItem = [bannerClickRedirectIdArray objectAtIndex:index];
        [self.navigationController pushViewController:vc animated:YES];
        
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
        
    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"event_details"]){
        EventDetalPage *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetails"];
        vc.fromNotificationTap = NO;
        vc.selectedEventId = [bannerClickRedirectIdArray objectAtIndex:index];
        [self.navigationController pushViewController:vc animated:NO];
        
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
                    self->bannerFlipsArray = [[responseObject objectForKey:@"flyers"]valueForKey:@"image"];
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

#pragma mark - Collectionview delegates
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1){
        //Main category collectionView
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if (result.height <= 568)               //iPhone 5 or less
        {
            return CGSizeMake(100, 120);
        }
        else if(result.height ==  736.0)        //iPhone 6p
        {
            return CGSizeMake(129 , 150);
        }
        else if((int)[[UIScreen mainScreen] bounds].size.height ==  812.0)//iPhone X
        {
            return CGSizeMake(120 , 150);
        }
        else if((int)[[UIScreen mainScreen] bounds].size.height ==  896.0)//iPhone XR, XSMax
        {
            return CGSizeMake(128 , 150);
        }
        else
        {
            return CGSizeMake(119 , 140);
        }
    }else{
        // Featured Products collectionView
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if (result.height <= 568)              //iPhone 5 or less
        {
            return CGSizeMake(80, 120);
        }
        else if(result.height ==  736.0)       //iPhone 6p
        {
            return CGSizeMake(120 , 160);
        }else
        {
            return CGSizeMake(110 , 150);
        }
    }
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(collectionView.tag == 1){
        //Main category collectionView
        return [cat_name_array count];
    }else if (collectionView.tag == 3){
        // New Arrival collectionView
        return [newArrival_name_array count];
    }else{
        // Featuerd Products collectionView
        return [featured_name_array count];
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1){
        //Main category collectionView
        MainCatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainCatCollectionViewCell" forIndexPath:indexPath];
        NSString *iconUrl =[NSString stringWithFormat:@"%@%@",parentURL,[cat_icon_array objectAtIndex:indexPath.row]];
        
        NSString *bgImage;
        NSInteger index = indexPath.row+1;
        
        //Logic for bg gradient (repeating 6 images)
        if (index>6) {
            index = index%6;
            if(index==0){
                index=1;
            }
            bgImage =[NSString stringWithFormat:@"categoryBg%ld.png",(long)index];
        }else{
            bgImage =[NSString stringWithFormat:@"categoryBg%ld.png",(long)index];
        }
        
        cell.categoryBg.image =[UIImage imageNamed:bgImage];
        cell.categoryIcon.contentMode   = UIViewContentModeScaleAspectFit;
        [cell.categoryIcon sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
        cell.categoryTxt.text = [cat_name_array objectAtIndex:indexPath.row];
        
        return cell;
    }else if (collectionView.tag == 3){
        // Featured Products collectionView
        ProductListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductListViewCell" forIndexPath:indexPath];
        
        cell.bgImage.layer.cornerRadius = 10.0;
        cell.bgImage.layer.masksToBounds = YES;
        
        cell.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.contentView.layer.shadowRadius = 5.0f;
        cell.contentView.layer.shadowOffset = CGSizeZero;
        cell.contentView.layer.shadowOpacity = 0.6f;
        cell.layer.masksToBounds = NO;
//        _neewArrivalCollectionView.layer.masksToBounds = NO;
        
        //'Sold out' view if qty is zero
        //        if([[stock_array objectAtIndex:indexPath.row]intValue]<1)
        //        {
        //            cell.noStockFadeView.hidden = NO;
        //        }else{
        //            cell.noStockFadeView.hidden = YES;
        //        }
        
        NSString *subUrl = [newArrival_image_array objectAtIndex:indexPath.row];
        NSURL *imageUrl    = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,subUrl]];
        cell.productImage.contentMode   = UIViewContentModeScaleAspectFit;
        [cell.productImage sd_setImageWithURL:imageUrl];
        
        cell.lblItemName.text = [NSString stringWithFormat:@"%@",[newArrival_name_array objectAtIndex:indexPath.row]];
        float price = [[newArrival_price_array objectAtIndex:indexPath.row]floatValue];
        cell.lblPrice.text    = [NSString stringWithFormat:@"%.02f QAR",price];
        
//        NSString *salesTagText = [[newArrivalArray objectAtIndex:indexPath.row] valueForKey:@"sale_tag_text"];
        
//        if ([salesTagText  isEqual: @""]){
            cell.saleTagView.hidden = true;
//        }else{
//            cell.saleTagView.hidden = false;
//            cell.lblSalesTag.text = salesTagText;
//        }
//
        
        return cell;
    }else{
        // Featured Products collectionView
        ProductListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductListViewCell" forIndexPath:indexPath];
        
        cell.bgImage.layer.cornerRadius = 10.0;
        cell.bgImage.layer.masksToBounds = YES;
        
        cell.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.contentView.layer.shadowRadius = 5.0f;
        cell.contentView.layer.shadowOffset = CGSizeZero;
        cell.contentView.layer.shadowOpacity = 0.6f;
        cell.layer.masksToBounds = NO;
        _featuredProductsCollectionView.layer.masksToBounds = NO;
        
        //'Sold out' view if qty is zero
        //        if([[stock_array objectAtIndex:indexPath.row]intValue]<1)
        //        {
        //            cell.noStockFadeView.hidden = NO;
        //        }else{
        //            cell.noStockFadeView.hidden = YES;
        //        }
        
        NSString *subUrl = [featured_image_array objectAtIndex:indexPath.row];
        NSURL *imageUrl    = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,subUrl]];
        cell.productImage.contentMode   = UIViewContentModeScaleAspectFit;
        [cell.productImage sd_setImageWithURL:imageUrl];
        
        cell.lblItemName.text = [NSString stringWithFormat:@"%@",[featured_name_array objectAtIndex:indexPath.row]];
        float price = [[featured_price_array objectAtIndex:indexPath.row]floatValue];
        cell.lblPrice.text    = [NSString stringWithFormat:@"%.02f QAR",price];
        
        NSString *salesTagText = [[featuredItemsArray objectAtIndex:indexPath.row] valueForKey:@"sale_tag_text"];
        
        if ([salesTagText  isEqual: @""]){
            cell.saleTagView.hidden = true;
        }else{
            cell.saleTagView.hidden = false;
            cell.lblSalesTag.text = salesTagText;
        }
        
        
        return cell;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView.tag == 1){
        //Main category
        // animate the cell user tapped on
        UICollectionViewCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:(UIViewAnimationOptionTransitionNone)
                         animations:^{
            NSLog(@"animation start");
            cell.transform = CGAffineTransformMakeScale(1.05,1.05);
        }
                         completion:^(BOOL finished){
            NSLog(@"animation end");
            cell.transform = CGAffineTransformMakeScale(1,1);
            
            categoryViewController *categoryVc= [self.storyboard instantiateViewControllerWithIdentifier:@"categoryView"];
            
            NSLog(@"catType>%@",self->cat_type_array);
            NSString *typeVal = [NSString stringWithFormat:@"%@",[self->cat_type_array objectAtIndex:indexPath.row]];
            
            if([typeVal isEqualToString:@"1"]){//retail and hypermarket offer
                
                categoryVc.categoryType = @"1";
                [self.navigationController pushViewController:categoryVc animated:YES];
                
            }else if([typeVal isEqualToString:@"2"]){//sale and promotion
                
                categoryVc.categoryType = @"2";
                [self.navigationController pushViewController:categoryVc animated:YES];
                
            }else if([typeVal isEqualToString:@"3"]){//event
                
                NSString *itemID = [NSString stringWithFormat:@"%@",[self->cat_item_id_array objectAtIndex:indexPath.row]];
                if(itemID != NULL && ![itemID  isEqual: @"0"] && ![itemID  isEqual: @""]){ // goto event list
                    
                    EventsList *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"eventList"];
                    vc.eventCatId = [self->cat_item_id_array objectAtIndex:indexPath.row];
                    vc.eventName  = [self->cat_name_array objectAtIndex:indexPath.row];
                    NSLog(@"%@",vc.eventCatId);
                    NSLog(@"%@",vc.eventName);
                    vc.IsCalendar = @"No";
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    
                }else{// goto event home
                    EventsHome *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"eventsHome"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
                
            }else if([typeVal isEqualToString:@"4"]){ // iaq market
                
                NSString *itemID = [NSString stringWithFormat:@"%@",[self->cat_item_id_array objectAtIndex:indexPath.row]];
                if(itemID != NULL && ![itemID isEqual: @"0"] && ![itemID  isEqual: @""]){ // goto event list
                    
                    MarketViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"marketView"];
                    vc.storeID = [self->cat_item_id_array objectAtIndex:indexPath.row];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    
                    MarketNewHomePageViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"MarketNewHomePageViewController"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
                
            }else if([typeVal isEqualToString:@"6"]){
                contestViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"contestView"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if([typeVal isEqualToString:@"7"]){
                MallListViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"MallListViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if([typeVal isEqualToString:@"10"]){
                //kolamazz
                GiftboxHomeViewController *vc = [[GiftboxHomeViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if([typeVal isEqualToString:@"11"]){
                //kolamazz
                IAQFeedsViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"IAQFeedsViewController"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
         ];
    }else if(collectionView.tag == 3){
        //New Arrival
        // animate the cell user tapped on
        UICollectionViewCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:(UIViewAnimationOptionTransitionNone)
                         animations:^{
            NSLog(@"animation start");
            cell.transform = CGAffineTransformMakeScale(1.05,1.05);
        }
                         completion:^(BOOL finished){
            NSLog(@"animation end");
            cell.transform = CGAffineTransformMakeScale(1,1);
            MarketDetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"marketDetailView"];
            vc.selectedProductId = [self->newArrival_id_array objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
         ];
    }else{
        //Featured product
        // animate the cell user tapped on
        UICollectionViewCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:(UIViewAnimationOptionTransitionNone)
                         animations:^{
            NSLog(@"animation start");
            cell.transform = CGAffineTransformMakeScale(1.05,1.05);
        }
                         completion:^(BOOL finished){
            NSLog(@"animation end");
            cell.transform = CGAffineTransformMakeScale(1,1);
            MarketDetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"marketDetailView"];
            vc.selectedProductId = [self->featured_id_array objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
         ];
    }
}

// MARK:- Animation On Highlight
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:(UIViewAnimationOptionTransitionNone)
                     animations:^{
        NSLog(@"animation start");
        cell.transform = CGAffineTransformMakeScale(1.05,1.05);
    }
                     completion:^(BOOL finished){
        NSLog(@"animation end");
    }
     ];
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:(UIViewAnimationOptionTransitionNone)
                     animations:^{
        NSLog(@"animation start");
        cell.transform = CGAffineTransformMakeScale(1,1);
    }
                     completion:^(BOOL finished){
        NSLog(@"animation end");
    }
     ];
}



-(void)updateNotifier{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate versionCheck];
}


-(void)getAdDetails: (myCompletion)compBlock
{
    if ([Utility reachable]) {
        
        [ProgressHUD show];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSString *devicetoken = [NSString stringWithFormat:@"%@",[Utility getfromplist:@"deviceToken" plist:@"iq"]];
        devicetoken=[devicetoken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        devicetoken=[devicetoken stringByReplacingOccurrencesOfString:@">" withString:@""];
        devicetoken=[devicetoken stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *version       = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *model         = [NSString stringWithFormat:@"iphone"];
        NSString *deviceos      = [NSString stringWithFormat:@"IOS"];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:version,@"appversion",devicetoken,@"devicetoken",model,@"devicemodel",deviceos,@"deviceos",enviournment,@"environment",[appDelegate.userProfileDetails objectForKey:@"user_id"],@"user_id", nil];
        
        //NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[appDelegate.userProfileDetails objectForKey:@"user_id"],@"user_id", nil];
        
        
        [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,getAdvt] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
            NSString *text = [responseObject objectForKey:@"text"];
            NSString *badge = [[responseObject objectForKey:@"cart_count"]valueForKey:@"count"];
            [Utility addtoplist:badge key:@"cartCount" plist:@"iq"];
            
            long cartCount = [badge integerValue];
            
            //TODO:Show when cart is enabled
            if (cartCount != 0) {
                NSString * value=[NSString stringWithFormat:@"%ld",cartCount];
                [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:value];
            }else{
                [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:nil];
            }
            
            if ([text isEqualToString: @"Success!"])
            {
                self->advtImageUrlArray  = [[responseObject valueForKey:@"banners"]valueForKey:@"banner"];
                //advtLinkArray      = [[responseObject valueForKey:@"value"]valueForKey:@"ad_link"];
                self->bannerTitleArray   = [[responseObject valueForKey:@"banners"]valueForKey:@"title"];
                self->bannerDescArray    = [[responseObject valueForKey:@"banners"]valueForKey:@"description"];
                
                self->cat_name_array     = [[responseObject valueForKey:@"categories"]valueForKey:@"cat_name"];
                self->cat_icon_array     = [[responseObject valueForKey:@"categories"]valueForKey:@"cat_icon"];
                self->cat_id_array       = [[responseObject valueForKey:@"categories"]valueForKey:@"cat_id"];
                //cat_id_array       = [[responseObject valueForKey:@"categories"]valueForKey:@"cat_name"];
                self->cat_status_array   = [[responseObject valueForKey:@"categories"]valueForKey:@"status"];
                self->cat_type_array     = [[responseObject valueForKey:@"categories"]valueForKey:@"type"];
                self->cat_item_id_array  = [[responseObject valueForKey:@"categories"]valueForKey:@"item_id"];
                
                self->featuredItemsArray = [responseObject valueForKey:@"featued_items"];
                self->featured_name_array = [[responseObject valueForKey:@"featued_items"]valueForKey:@"product_name"];
                self->featured_price_array= [[responseObject valueForKey:@"featued_items"]valueForKey:@"price"];
                self->featured_image_array= [[responseObject valueForKey:@"featued_items"]valueForKey:@"default"];
                self->featured_id_array   = [[responseObject valueForKey:@"featued_items"]valueForKey:@"product_id"];
                self->stock_array         = [[responseObject valueForKey:@"featued_items"] valueForKey:@"stock_count"];
                
                self->newArrivalArray = [responseObject valueForKey:@"new_items"];
                self->newArrival_name_array = [[responseObject valueForKey:@"new_items"]valueForKey:@"product_name"];
                self->newArrival_price_array= [[responseObject valueForKey:@"new_items"]valueForKey:@"price"];
                self->newArrival_image_array= [[responseObject valueForKey:@"new_items"]valueForKey:@"default"];
                self->newArrival_id_array   = [[responseObject valueForKey:@"new_items"]valueForKey:@"product_id"];
                self->newArrivalStock_array         = [[responseObject valueForKey:@"new_items"] valueForKey:@"stock_count"];
                
                self->bannerLinkTypeArray = [[responseObject valueForKey:@"banners"]valueForKey:@"link_type"];
                self->bannerPageLinkArray = [[responseObject valueForKey:@"banners"]valueForKey:@"pagelink"];
                self->bannerClickRedirectIdArray = [[responseObject valueForKey:@"banners"]valueForKey:@"product_id"];
            }
            NSLog(@"JSON: %@", responseObject);
            compBlock (YES);
            [ProgressHUD dismiss];
            
        } failure:^(NSURLSessionTask *task, NSError *error) {
            NSLog(@"Error: %@", error);
            [ProgressHUD dismiss];
        }];
        
    }else{
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    menuHideTap.enabled = NO;
    [menu setHidden:YES];
    //    isSelected = NO;
    //    menu.frame=CGRectMake(0, 625, 275, 335);
}


//-(void)advtTap: (UITapGestureRecognizer *)sender{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[advtLinkArray objectAtIndex:0]]];
//}

//MARK:- TAB BAR DELEGATE
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    jumpToHome = [NSString stringWithFormat:@"NO"];
    
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
        }
        else
        {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self->menu setHidden:NO];
                self->menuHideTap.enabled = YES;
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
    }else if(viewController == [self.tabBarController.viewControllers objectAtIndex:1]){
        //Jump to login screen
        NSString *plistVal = [[NSString alloc]init];
        plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];
        
        if([plistVal isEqualToString:@"YES"]){
            ////[AlertController alertWithMessage:@"Please Login!" presentingViewController:self];
            [Utility guestUserAlert:self];
            
            return NO;
        }else{
            return YES;
        }
    }else if (viewController == [self.tabBarController.viewControllers objectAtIndex:3])
    {
        //        [self.navigationController popViewControllerAnimated:YES];
        //
        //        [Utility exitAlert:self];
        //        return NO;
        //self.tabBarController.tabBar.selectedItem = [self.tabBarController.tabBar.items objectAtIndex:2];
    }
    return YES;
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
    {
        
    }
}

//- (IBAction)todaysDealAction:(id)sender
//{
//    RetailViewController *rv= [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
//    rv.pushedFrom = @"todaysDeal";
//    [self.navigationController pushViewController:rv animated:YES];
//}
//- (IBAction)whatsNewAction:(id)sender {
//    RetailViewController *rv= [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
//    rv.pushedFrom = @"whatsNew";
//    [self.navigationController pushViewController:rv animated:YES];
//}



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
    
//    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
//    NSString *userID = store.session.userID;
//    [store logOutUserID:userID];
    
    //Logout plist clear
    [Utility addtoplist:@"" key:@"login" plist:@"iq"];
    
    //Resetting 'skipped user' value
    [Utility addtoplist:@"NO"key:@"skippedUser" plist:@"iq"];
    
    [self.navigationController presentViewController:view animated:NO completion:nil];
}


- (IBAction)gotoGistPage:(id)sender {
    
    GiftCategoryViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"GiftCategoryViewController"];
    [self.navigationController pushViewController:view animated:YES];
    
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
