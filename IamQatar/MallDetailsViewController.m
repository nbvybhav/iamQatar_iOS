//
//  MallDetailsViewController.m
//  IamQatar
//
//  Created by User on 22/06/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import "MallDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <GoogleMaps/GoogleMaps.h>
#import <UIImageView+WebCache.h>
#import "NewsFeedsViewController.h"
#import "StoreListViewController.h"
#import "newsFeedTableViewCell.h"
#import "MainCatCollectionViewCell.h"
#import "MallCategoryCell.h"
#import "ImagePreviewCell.h"
#import "EXPhotoViewer.h"
#import "RetailDetailViewController.h"
#import "IamQatar-Swift.h"

@interface MallDetailsViewController ()

@end

@implementation MallDetailsViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;
    UITableView *newsfeedTableView;

    NSArray *bannersArray;
    NSArray *bannersTitleArray;
    NSArray *bannersDescArray;

    NSArray *news;
    NSString *newsTitle;
    NSString *newsDescription;
    NSString *newsBannerImg;
    NSString *newsReporeter;
    NSString *newsDate;

//    NSString *address;
//    NSString *contactNumber;
//    NSString *lattitude;
//    NSString *longitude;
//    NSString *mallName;
//    NSString *openingHours;
//    NSString *url;
//    NSArray *mallDetails;

    NSArray *categoryArray;
    NSArray *catIdArray;
    NSArray *catNameArray;

    NSArray *mallCategoriesArray;
    NSArray *mallCatNameArray;
    NSArray *mallCatTypeArray;
    NSArray *mallCatIconArray;
    NSArray *mallCatDetailArray;
    NSArray *mallCatIdArray;
    NSMutableArray *galleryArray;

    NSMutableArray *bannerLinkTypeArray;
    NSMutableArray *bannerPageLinkArray;
    NSMutableArray *bannerClickRedirectIdArray;
}

//MARK:- VIEW DID LOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];

    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapAction:)];
    singleFingerTap.delegate = self;
    [_bgView addGestureRecognizer:singleFingerTap];

    [self.mainScrollView addSubview:_txtViewInPopUpView];

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

    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];


    //collectionview cell Nib registration
    [_mallCategoryCollectionView registerNib:[UINib nibWithNibName:@"MallCategoryCell" bundle:nil] forCellWithReuseIdentifier:@"MallCategoryCell"];
    _mallCategoryCollectionView.clipsToBounds = NO;

    [_imagePreviewCollectionView registerNib:[UINib nibWithNibName:@"ImagePreviewCell" bundle:nil] forCellWithReuseIdentifier:@"ImagePreviewCell"];
    _imagePreviewCollectionView.clipsToBounds = NO;


    [self getMallDetailsCall:^(BOOL finished) {
        if(finished){
            //sliding imageView
            self->_bannerTitle.text = [NSString stringWithFormat:@"%@",[self->bannersTitleArray objectAtIndex:0]];
            self->_bannerDesc.text  = [NSString stringWithFormat:@"%@",[self->bannersDescArray objectAtIndex:0]];
            self->_bannerView.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
            self->_bannerView.pageControl.pageIndicatorTintColor = [UIColor blackColor];
            self->_bannerView.slideshowTimeInterval = 5.5f;
            self->_bannerView.slideshowShouldCallScrollToDelegate = YES;
            self->_bannerView.imageCounterDisabled = YES;

            if([self->news count]>0){
                self->_newsFeedTitle.text = [NSString stringWithFormat:@"%@",[[self->news objectAtIndex:0] valueForKey:@"title"]];
                self->_newsFeedDesc.text = [NSString stringWithFormat:@"%@",[[self->news objectAtIndex:0] valueForKey:@"description"]];
            }
            self->_newsFeedView.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
            self->_newsFeedView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
            self->_newsFeedView.slideshowTimeInterval = 4.0f;
            self->_newsFeedView.slideshowShouldCallScrollToDelegate = YES;
            self->_newsFeedView.imageCounterDisabled = YES;
            self->_newsFeedView.scrollView.pagingEnabled = YES;
            [self setUI];
        }
    }];
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
    [tracker set:kGAIScreenName value:@"Mall Details screen"];
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
}


//MARK:- API CALL
- (void)getMallDetailsCall:(myCompletion)compBlock{

    if([Utility reachable]){

        [ProgressHUD show];
        NSDictionary *parameters = @{@"mall_id":_mallId};
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager POST:[NSString stringWithFormat:@"%@%@",parentURL,getMallDetailsAPI] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             if ([text isEqualToString: @"Success!"])
             {
                 NSLog(@"JSON: %@", responseObject);
                 self->mallCategoriesArray    = [[responseObject objectForKey:@"value"]valueForKey:@"extradetails"];
                 self->mallCatNameArray       = [self->mallCategoriesArray valueForKey:@"column_name"];
                 self->mallCatTypeArray       = [self->mallCategoriesArray valueForKey:@"type"];
                 self->mallCatIconArray       = [self->mallCategoriesArray valueForKey:@"icon"];
                 self->mallCatDetailArray     = [self->mallCategoriesArray valueForKey:@"details"];
                 self->mallCatIdArray         = [self->mallCategoriesArray valueForKey:@"category_id"];
                 self->galleryArray           = [[responseObject objectForKey:@"gallery"]valueForKey:@"image"];


//                 address        = [mallDetails valueForKey:@"address"];
//                 contactNumber  = [mallDetails valueForKey:@"contact_number"];
//                 lattitude      = [mallDetails valueForKey:@"latitude"];
//                 longitude      = [mallDetails valueForKey:@"longitude"];
//                 mallName       = [mallDetails valueForKey:@"mall_name"];
//                 openingHours   = [mallDetails valueForKey:@"opening_hours"];
//                 url            = [mallDetails valueForKey:@"website_url"];

                 self.title = [[[responseObject valueForKey:@"value"] valueForKey:@"details"] valueForKey:@"mall_name"];
                 self->categoryArray  = [[responseObject objectForKey:@"value"]valueForKey:@"categories"];
                 self->catIdArray     = [self->categoryArray valueForKey:@"id"];
                 self->catNameArray   = [self->categoryArray valueForKey:@"name"];

                 if([[responseObject objectForKey:@"banners"]count]>0){
                     self->bannersArray         = [[responseObject objectForKey:@"banners"]valueForKey:@"banner"];
                     self->bannersDescArray     = [[responseObject objectForKey:@"banners"]valueForKey:@"description"];
                     self->bannersTitleArray    = [[responseObject objectForKey:@"banners"]valueForKey:@"title"];
                     self->bannerLinkTypeArray  = [[responseObject valueForKey:@"banners"]valueForKey:@"link_type"];
                     self->bannerPageLinkArray  = [[responseObject valueForKey:@"banners"]valueForKey:@"pagelink"];
                     self->bannerClickRedirectIdArray = [[responseObject valueForKey:@"banners"]valueForKey:@"product_id"];
                 }
                 
                 self->news  = [[responseObject objectForKey:@"value"]objectForKey:@"news"];
                 if([self->news count]>0){
                     self->newsTitle            = [[self->news valueForKey:@"title"]objectAtIndex:0];
                     self->newsDescription      = [[self->news valueForKey:@"description"]objectAtIndex:0];
                     self->newsBannerImg        = [[self->news valueForKey:@"image"]objectAtIndex:0];
                     self->newsReporeter        = [[self->news valueForKey:@"reporter"]objectAtIndex:0];
                     self->newsDate             = [[self->news valueForKey:@"created_date"]objectAtIndex:0];
                 }
             }

             [self->_imagePreviewCollectionView reloadData];
             [self->_mallCategoryCollectionView reloadData];
             [ProgressHUD dismiss];

             compBlock (YES);

         } failure:^(NSURLSessionTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             [ProgressHUD dismiss];
         }];
    }else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}



//MARK:- METHODS

// MENU SWIPE
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


-(void)setUI{
    //corner radius & shadow
    //Setting shadow and corner radius for imageview

    _shadowView.backgroundColor = [UIColor clearColor];
    [_shadowView  addSubview:_bannerView];
    //_shadowView.center = _ivAdvt.center;
    //[_shadowView addSubview:_bannerView];

    _bannerView.layer.masksToBounds = YES;
    _shadowView.layer.masksToBounds = NO;
    // set imageview corner
    //_bannerView.layer.cornerRadius = 10.0;
    // set avatar imageview border
    [_bannerView.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [_bannerView.layer setBorderWidth: 2.0];
    // set holder shadow
    [_shadowView.layer setShadowOffset:CGSizeZero];
    [_shadowView.layer setShadowOpacity:0.5];
    _shadowView.clipsToBounds = NO;


    [self.view layoutIfNeeded];
    CGFloat deviceWidth = [UIScreen mainScreen].bounds.size.width;


    if([galleryArray count]>0)
    {
        _lblGalleryTitle.hidden = NO;
    }else{
        _lblGalleryTitle.hidden = YES;
    }

    //Setting 'category' collectionview hieght based on content
    CGRect categoryCollectionViewRectangle;
    categoryCollectionViewRectangle = _mallCategoryCollectionView.frame;
    categoryCollectionViewRectangle.size = [_mallCategoryCollectionView.collectionViewLayout collectionViewContentSize];
    _mallCategoryCollectionView.frame = categoryCollectionViewRectangle;

    _mallCategoryCollectionView.frame = CGRectMake(_mallCategoryCollectionView.frame.origin.x, _mallCategoryCollectionView.frame.origin.y, _mallCategoryCollectionView.frame.size.width, _mallCategoryCollectionView.frame.size.height);

    _lblGalleryTitle.frame = CGRectMake(_lblGalleryTitle.frame.origin.x, _mallCategoryCollectionView.frame.origin.y+_mallCategoryCollectionView.frame.size.height+10, _lblGalleryTitle.frame.size.width, _lblGalleryTitle.frame.size.height);

    //Setting 'imagePreview' collectionview hieght based on content
    CGRect rectangle;
    rectangle = self.imagePreviewCollectionView.frame;
    rectangle.size = [self.imagePreviewCollectionView.collectionViewLayout collectionViewContentSize];
    self.imagePreviewCollectionView.frame = rectangle;

    _imagePreviewCollectionView.frame = CGRectMake(_imagePreviewCollectionView.frame.origin.x, _lblGalleryTitle.frame.origin.y+_lblGalleryTitle.frame.size.height + 10, _imagePreviewCollectionView.frame.size.width, _imagePreviewCollectionView.frame.size.height);

    //*********** news feed *********//
    if([news count]>0)  {

        //NewsFeeds Title Label
        UILabel *feedsTitleLbl = [[UILabel alloc]init];
        feedsTitleLbl.frame = CGRectMake(_lblGalleryTitle.frame.origin.x, _imagePreviewCollectionView.frame.origin.y+_imagePreviewCollectionView.frame.size.height + 10, _imagePreviewCollectionView.frame.size.width,30);
        feedsTitleLbl.font = _lblSearchForStore.font;
        feedsTitleLbl.text = @"News and Latest Feeds";
        [self.mainScrollView addSubview:feedsTitleLbl];

        _newsFeedShadowView.frame = CGRectMake(_newsFeedShadowView.frame.origin.x, feedsTitleLbl.frame.origin.y+feedsTitleLbl.frame.size.height, _imagePreviewCollectionView.frame.size.width, 80);
        _newsFeedTitle.frame =CGRectMake(_newsFeedShadowView.frame.origin.x+10, _newsFeedShadowView.frame.origin.y+5, _newsFeedTitle.frame.size.width, 20);
        _newsFeedDesc.frame  =CGRectMake(_newsFeedShadowView.frame.origin.x+10, _newsFeedTitle.frame.origin.y+_newsFeedTitle.frame.size.height, _newsFeedDesc.frame.size.width, 20);
        _newsFeedDesc.textColor = [UIColor lightGrayColor];

        //Setting shadow for 'newsfeedview'
        [_newsFeedShadowView.layer setShadowOffset:CGSizeZero];
        [_newsFeedShadowView.layer setShadowOpacity:0.6];
        [_newsFeedShadowView.layer setShadowColor:[[UIColor grayColor]CGColor]];
        _newsFeedShadowView.layer.cornerRadius = 10;

        //Setting Label size dynamically
        _newsFeedDesc.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize maximumLabelSize = CGSizeMake(_newsFeedDesc.frame.size.width, 60);
        CGSize expectSize= [_newsFeedDesc sizeThatFits:maximumLabelSize];
        _newsFeedDesc.frame = CGRectMake(_newsFeedDesc.frame.origin.x, _newsFeedDesc.frame.origin.y, _newsFeedDesc.frame.size.width, expectSize.height+10);

        [self.mainScrollView addSubview:_newsFeedShadowView];
        [self.mainScrollView addSubview:_newsFeedTitle];
        [self.mainScrollView addSubview:_newsFeedDesc];

        [self.mainScrollView setContentSize:CGSizeMake(_newsFeedShadowView.frame.size.width,_newsFeedShadowView.frame.origin.y + _newsFeedShadowView.frame.size.height + 60)];

    }else{
        //Setting scrollview Hieght
        self.mainScrollView.scrollEnabled = YES;
        [self.mainScrollView setContentSize:CGSizeMake(_mainScrollView.frame.size.width,_imagePreviewCollectionView.frame.origin.y + _imagePreviewCollectionView.frame.size.height + 40)];
    }
}

-(void)addShadowTo:(UIView*)view{

    UIView *shadowView = [[UIView alloc] initWithFrame:view.frame];

    [shadowView.layer setShadowOffset:CGSizeZero];
    [shadowView.layer setShadowOpacity:0.5];
    [shadowView.layer setShadowColor:[[UIColor grayColor]CGColor]];

    shadowView.backgroundColor = [UIColor whiteColor];
    [view.superview addSubview:shadowView];
    shadowView.layer.cornerRadius = view.layer.cornerRadius;
    [view.superview bringSubviewToFront:view];
}

- (void)bgTapAction:(UITapGestureRecognizer *)recognizer {
    _popUpView.hidden = YES;
    _txtViewInPopUpView.hidden    = YES;
    _mainScrollView.scrollEnabled = YES;
    _lblPopUpTitle.hidden         = YES;
    _bgView.hidden                = YES;
    _containerView.hidden         = YES;
}


- (IBAction)searchTap:(id)sender {
    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];
    vc.searchType = @"stores";
    [self.navigationController pushViewController:vc animated:false];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    //    isSelected = NO;
    //    menu.frame=CGRectMake(0, 625, 275, 335);
}


//MARK:- COLLECTIONVIEW DELEGATES
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize result = [[UIScreen mainScreen] bounds].size;

    if(collectionView.tag == 1){
        //Category cell
        if (result.height <= 568)
        {
            return CGSizeMake(90 , 55);
        }
        else if(result.height ==  736.0) //iPhone 6P
        {
            return CGSizeMake(122 , 85);
        }
        else if((int)[[UIScreen mainScreen] bounds].size.height ==  812.0)//iPhone X
        {
            return CGSizeMake(110 , 90);
        }
        else if((int)[[UIScreen mainScreen] bounds].size.height ==  896.0)//iPhone XR, XSMax
        {
            return CGSizeMake(120 , 105);
        }
        else
        {
            return CGSizeMake(110 , 55);
        }
    }else{
        //Image Preview cell
        if (result.height <= 568)
        {
            return CGSizeMake(98 , 115);
        }
        else if(result.height ==  736.0) //iPhone 6P
        {
            return CGSizeMake(127 , 130);
        }
        else if((int)[[UIScreen mainScreen] bounds].size.height ==  812.0)//iPhone X
        {
            return CGSizeMake(115 , 110);
        }
        else if((int)[[UIScreen mainScreen] bounds].size.height ==  896.0)//iPhone XR, XSMax
        {
            return CGSizeMake(127 , 115);
        }
        else
        {
            return CGSizeMake(115, 115);
        }
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag ==1){
        //Category cell
         return [mallCatNameArray count];
    }else{
        //Image Preview cell
         return [galleryArray count];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag ==1){
        MallCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MallCategoryCell" forIndexPath:indexPath];
        NSString *iconUrl =[NSString stringWithFormat:@"%@%@",parentURL,[mallCatIconArray objectAtIndex:indexPath.row]];

        NSString *bgImage;
        NSInteger index = indexPath.row+1;

        //Logic for bg gradient (repeating 6 images)
        if (index>6) {
            index = index%6;
            if(index==0){
                index=1;
            }
            bgImage =[NSString stringWithFormat:@"EventCatBg%ld.png",(long)index];
        }else{
            bgImage =[NSString stringWithFormat:@"EventCatBg%ld.png",(long)index];
        }
        cell.cellBgImage.image = [UIImage imageNamed:bgImage];
        cell.shadowImg.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.shadowImg.layer.shadowRadius = 4.0f;
        cell.shadowImg.layer.shadowOffset = CGSizeMake(8.0, 5.0f);;
        cell.shadowImg.layer.shadowOpacity = 0.8f;
        cell.layer.masksToBounds = NO;

        cell.iconImage.contentMode   = UIViewContentModeScaleAspectFit;
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
        cell.txtCategory.text = [mallCatNameArray objectAtIndex:indexPath.row];

        return cell;
    }else{
         ImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImagePreviewCell" forIndexPath:indexPath];
         NSString *imageUrl =[NSString stringWithFormat:@"%@%@",parentURL,[galleryArray objectAtIndex:indexPath.row]];
        [cell.previewImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
         return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if(collectionView.tag ==2){
        //Gallery photo selection
        //Navigation to retail detailViewcontroller for image swipe
        RetailDetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"retailDetailView"];
        int position = (int) indexPath.row;

        if([galleryArray count] > 0)  {
            vc.flipsArray = galleryArray;
            vc.position = [[NSString alloc]init];
            vc.position = [NSString stringWithFormat:@"%d",position];
            [self.navigationController pushViewController:vc animated:YES];

        }else{
            [AlertController alertWithMessage:@"No records found!" presentingViewController:self];
        }
    }else{
        //Mall category selection
        NSString *mallCatTypeVal = [NSString stringWithFormat:@"%@",[mallCatTypeArray objectAtIndex:indexPath.row]];

        if([mallCatTypeVal isEqualToString:@"stores"]){
            //Stores
            StoreListViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreListViewController"];
            view.mallId     = _mallId;
            view.storeCatId = [mallCatIdArray objectAtIndex:indexPath.row];

            //To hide & show filter bar in store list
            if([mallCatTypeVal isEqualToString:@"stores"])//'0' shows stores of all categories
            {
                view.showFilterBar = @"YES";
            }else{
                view.showFilterBar = @"NO";
            }

            view.categoryArray = categoryArray;
            [self.navigationController pushViewController:view animated:YES];

        }else if([mallCatTypeVal isEqualToString:@"offerstores"]){
            //Stores
            StoreListViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreListViewController"];
            view.mallId     = _mallId;
            view.storeCatId = [mallCatIdArray objectAtIndex:indexPath.row];
            view.offerStores= @"YES";

            //To hide & show filter bar in store list
            if([mallCatTypeVal isEqualToString:@"offerstores"])//'0' shows stores of all categories
            {
                view.showFilterBar = @"YES";
            }else{
                view.showFilterBar = @"NO";
            }

            view.categoryArray = categoryArray;
            [self.navigationController pushViewController:view animated:YES];

        }else if([mallCatTypeVal isEqualToString:@"number"]){
            
            NSString *phoneNumber = [mallCatDetailArray objectAtIndex:indexPath.row];
            
            NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];

            NSLog(@"%@", cleanedString);
            //Contact us
//             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",cleanedString]]];
            UIApplication *application = [UIApplication sharedApplication];
//            NSURL *URL = [NSURL URLWithString:simple];
            [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",cleanedString]] options:@{} completionHandler:^(BOOL success) {
                if (success) {
                     NSLog(@"Opened url");
                }
            }];
        }else if([mallCatTypeVal isEqualToString:@"url"]){
            //Website
            NSString *url = [[NSString alloc]init];
            url = [NSString stringWithFormat:@"%@",[mallCatDetailArray objectAtIndex:indexPath.row]];

                if (!contains(url, @"http")) {
                    url = [NSString stringWithFormat:@"http://%@", url];
                }

                UIApplication *application = [UIApplication sharedApplication];
                NSURL *URL = [NSURL URLWithString:url];
                [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        NSLog(@"Opened url");
                    }else{
                        //hell
                    }
                }];

        }else if([mallCatTypeVal isEqualToString:@"latitude"]){
            //Map location
            NSString *latLong = [mallCatDetailArray objectAtIndex:indexPath.row];
            latLong =  [latLong stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *latLongArray = [latLong componentsSeparatedByString:@","];

            NSString *lattitude  = [NSString stringWithFormat:@"%@",[latLongArray objectAtIndex:0]];
            NSString *longitude  = [NSString stringWithFormat:@"%@",[latLongArray objectAtIndex:1]];

            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:@"comgooglemaps://"];
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    NSString *mapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@,%@&directionsmode=driving",lattitude,longitude];
                    [application openURL:[NSURL URLWithString:mapUrl] options:@{} completionHandler:nil];
                }else{
                    NSString *mapUrl = [NSString stringWithFormat:@"https://www.google.co.in/maps/dir/?saddr=%@,%@&directionsmode=driving",lattitude,longitude];
                     [application openURL:[NSURL URLWithString:mapUrl] options:@{} completionHandler:nil];
                }
            }];
        }else if([mallCatTypeVal isEqualToString:@"image"]){
            //Images
            NSMutableArray *images = [[[mallCategoriesArray objectAtIndex:indexPath.row]valueForKey:@"images"]valueForKey:@"image"];
            //Navigation to retail detailViewcontroller for image swipe
            RetailDetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"retailDetailView"];


            if([images count] > 0)  {
                vc.flipsArray = images;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [AlertController alertWithMessage:@"No records found!" presentingViewController:self];
            }
        }else if([mallCatTypeVal isEqualToString:@"text"]){
            //Text content
            _txtViewInPopUpView.text = [mallCatDetailArray objectAtIndex:indexPath.row];
            _containerView.layer.cornerRadius = 10.0;
            _lblPopUpTitle.text = [mallCatNameArray objectAtIndex:indexPath.row];

            // Getting rid of textView's padding
            _txtViewInPopUpView.textContainerInset = UIEdgeInsetsZero;
            _txtViewInPopUpView.textContainer.lineFragmentPadding = 0;

            // Setting height of textView to its contentSize.height
            CGRect textViewFrame = _txtViewInPopUpView.frame;
            textViewFrame.size = _txtViewInPopUpView.contentSize;
            _txtViewInPopUpView.frame = textViewFrame;

//            _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y, _containerView.frame.size.width, _txtViewInPopUpView.contentSize.height+5);;

            _popUpView.hidden = NO;
            _bgView.hidden    = NO;
            _containerView.hidden = NO;
            _txtViewInPopUpView.hidden = NO;
            _lblPopUpTitle.hidden         = NO;
            _mainScrollView.scrollEnabled = NO;
            [_containerView addSubview:_txtViewInPopUpView];
        }
    }
}

//MARK:- IMAGE PAGER DELEGATE
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    if(pager.tag == 0){
        NSMutableArray *fullUrlArray = [[NSMutableArray alloc]init];
        for (int i=0; i<[bannersArray count]; i++)
        {
            NSString *url =[NSString stringWithFormat:@"%@%@",parentURL,[bannersArray objectAtIndex:i]];
            [fullUrlArray addObject:url];
        };
        NSArray *returnArray = [fullUrlArray copy];
        return returnArray;
    }else{
        NSMutableArray *fullUrlArray = [[NSMutableArray alloc]init];
        NSArray *newsArray = [[NSArray alloc]init];
        newsArray = [news valueForKey:@"title"];

        for (int i=0; i<[newsArray count]; i++)
        {
            NSString *url =[NSString stringWithFormat:@"empty"];
            [fullUrlArray addObject:url];
        };
        NSArray *returnArray = [fullUrlArray copy];
        return returnArray;
    }
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleToFill;
}

- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    if(imagePager.tag == 0)
    {
        NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
        _bannerTitle.text = [bannersTitleArray objectAtIndex:index];
        _bannerDesc.text  = [bannersDescArray objectAtIndex:index];

    }else{
        _newsFeedTitle.text = [NSString stringWithFormat:@"%@",[[news objectAtIndex:index] valueForKey:@"title"]];
        _newsFeedDesc.text = [NSString stringWithFormat:@"%@",[[news objectAtIndex:index] valueForKey:@"description"]];
    }
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    if(imagePager.tag == 0)
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

//                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                [manager GET:urlString parameters:param headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
                 {
                     NSMutableArray *bannerFlipsArray;
                     NSString *text = [responseObject objectForKey:@"text"];
                     if ([text isEqualToString: @"Success!"])
                     {
                         bannerFlipsArray        = [[responseObject objectForKey:@"flyers"]valueForKey:@"image"];
                     }

                     NSLog(@"JSON response: %@", responseObject);
                     RetailDetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"retailDetailView"];
                     vc.flipsArray = bannerFlipsArray;
                     [self.navigationController pushViewController:vc animated:YES];
                     [ProgressHUD dismiss];

                 } failure:^(NSURLSessionTask *task, NSError *error) {
                     NSLog(@"Error: %@", error);
                     [ProgressHUD dismiss];
                 }];
            }
        }
    }else{
        NewsFeedsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsFeedsViewController"];
        view.selectedNews      = [news objectAtIndex:index];
        [self.navigationController pushViewController:view animated:YES];
    }
}


//MARK:- TABBAR DELEGATE
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
    }else if (viewController == [self.tabBarController.viewControllers objectAtIndex:3])
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

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
    {

    }
}




//MARK:- POPUP MENU DELEGAES
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
