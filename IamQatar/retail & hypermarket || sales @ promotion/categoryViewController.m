//
//  ThirdViewController.m
//  IamQatar
//
//  Created by alisons on 8/18/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "categoryViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "constants.pch"
#import "CategoryCollectionViewCell.h"
#import "FilterCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "RetailViewController.h"
#import "RetailCollectionViewCell.h"
#import "RetailDetailViewController.h"
#import "MarketViewController.h"
#import "IamQatar-Swift.h"

CGFloat gap = 18;

@interface categoryViewController ()

@end

@implementation categoryViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    NSMutableArray *fullCategoryDetails;
    NSArray *catSlugArray;
    NSArray *catIconArray;
    NSArray *catNameArray;
    NSArray *catIdArray;
    NSArray *catStatusArray;
    NSArray *offersNameArray;
    NSArray *offersIdArray;
    NSArray *storeDetails;
    NSArray *storeIdArray;
    NSArray *storeIconArray;
    NSArray *storeNameArray;
    NSMutableArray *flyerImagesArray;
    NSArray *store_Offer_NameArray;
    NSArray *store_Offer_IdArray;
    int deviceHieght;

    NSArray *bannersImageArray;
    NSArray *bannersDescriptionArray;
    NSArray *bannersTitleArray;
    NSMutableArray *bannerLinkTypeArray;
    NSMutableArray *bannerPageLinkArray;
    NSMutableArray *bannerClickRedirectIdArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *newBackButton =
            [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                             style:UIBarButtonItemStylePlain
                                            target:nil
                                            action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"logo_bottom"]
                                     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    deviceHieght = [[UIScreen mainScreen] bounds].size.height;
    
    //--------setting menu frame---------//
    isSelected = NO;
    menu= [[Menu alloc]init];
    NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"Menu" owner:self options:nil];
    menu = [nib1 objectAtIndex:0];
    menu.frame=CGRectMake(-290, 0, 275,deviceHieght);
    menu.delegate = self;
    //[self.view addSubview:menu];
    [self.tabBarController.view addSubview:menu];
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];

    menuHideTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    [self.view addGestureRecognizer:menuHideTap];
    menuHideTap.enabled = NO;
    swipeleft.cancelsTouchesInView = YES;
    
    menuHideTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    [self.view addGestureRecognizer:menuHideTap];
    menuHideTap.enabled = NO;
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    swiperight.cancelsTouchesInView = YES;
    
    //Collectionview cell Nib registration
    [self.salesAndPromoCollectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCollectionViewCell"];
    [self.filterCollectionView registerNib:[UINib nibWithNibName:@"FilterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FilterCollectionViewCell"];
    [self.salesAndPromoCollectionView registerNib:[UINib nibWithNibName:@"RetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RetailCollectionViewCell"];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    if #available(iOS 11.0, *) {
//    scrollView.contentInsetAdjustmentBehavior = .never
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = false
//    }

    //UIsearchBar placeholder text color
//    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];

    if( [_categoryType isEqualToString:@"1"])
    {
        _titleLblOne.text      = @"Search by Stores";
        _lblSearchByOffer.text = @"Search by Category";
        _searchBar.placeholder = @"Search for Retail items..";
        self.title = @"RETAIL & HYPERMARKET";
    }else{
        _titleLblOne.text      = @"Search by Category";
        _lblSearchByOffer.text = @"Search by Offer";
        _searchBar.placeholder = @"Search for Sales & Promo..";
        self.title = @"SALES & PROMOTIONS";
    }
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
        self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
        self->isSelected = YES;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
}


#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    NSMutableArray *fullUrlArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[bannersImageArray count]; i++)
    {
        NSString *url =[NSString stringWithFormat:@"%@%@",parentURL,[bannersImageArray objectAtIndex:i]];
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
    _bannerTitleLbl.text = [bannersTitleArray objectAtIndex:index];
    _bannerDescLbl.text  = [bannersDescriptionArray objectAtIndex:index];
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
//            [manager GET:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
             [manager GET:urlString parameters:param headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 NSMutableArray *bannerFlipsArray;
                 NSString *text = [responseObject objectForKey:@"text"];
                 if ([text isEqualToString: @"Success!"])
                 {
                     bannerFlipsArray = [[responseObject objectForKey:@"flyers"]valueForKey:@"image"];
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
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

#pragma mark - Collectionview delegates
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1)
    {
        if ((int)[[UIScreen mainScreen] bounds].size.height <= 568)  //iphone 5 or less
        {
            return CGSizeMake(90, 80);
        }
        else if((int)[[UIScreen mainScreen] bounds].size.height ==  736.0) //iphone 6p
        {
            return CGSizeMake(125 , 105);
        }
        else if((int)[[UIScreen mainScreen] bounds].size.height ==  812.0)//iPhone X
        {
            return CGSizeMake(110 , 100);
        }
        else if((int)[[UIScreen mainScreen] bounds].size.height ==  896.0)//iPhone XR, XSMax
        {
            return CGSizeMake(125 , 100);
        }
        else {
            return CGSizeMake(110 , 100);
        }
        
    }else{

        if([store_Offer_NameArray count] > 0){
            int width = [self widthOfString:[store_Offer_NameArray objectAtIndex:indexPath.row] withFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
            return CGSizeMake(width+25,50);
        }else if([offersNameArray count] > 0){
            int width = [self widthOfString:[offersNameArray objectAtIndex:indexPath.row] withFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
            return CGSizeMake(width+25,50);
        }
        else{
            return CGSizeZero;
        }
    }
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag == 1){
        if( [_categoryType isEqualToString:@"1"])
        {
            return [storeNameArray count];
        }else{
            return [catNameArray count];
        }
    }else{
        if( [_categoryType isEqualToString:@"1"])
        {
          return [store_Offer_NameArray count];
        }else{
          return [offersNameArray count];
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tag> %ld",(long)collectionView.tag);
    if (collectionView.tag == 1) {
        
        NSString *bgImage;
        NSInteger index = indexPath.row+1;
        NSString *iconUrl;
        
        if( [_categoryType isEqualToString:@"1"])
        {
            RetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RetailCollectionViewCell" forIndexPath:indexPath];
            
            cell.iconImage.layer.masksToBounds = YES;
            
            cell.shadowView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            cell.shadowView.layer.shadowRadius = 4.0;
            cell.shadowView.layer.shadowOffset = CGSizeZero;
            cell.shadowView.layer.shadowOpacity = 0.8;
            cell.layer.masksToBounds = NO;
            _salesAndPromoCollectionView.layer.masksToBounds = NO;
            cell.shadowView.layer.cornerRadius = 12.0;
            
            iconUrl = [NSString stringWithFormat:@"%@%@",parentURL,[storeIconArray objectAtIndex:indexPath.row]];
            cell.iconImage.contentMode   = UIViewContentModeScaleAspectFit;
            [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
            return  cell;
        }else{
            
            CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionViewCell" forIndexPath:indexPath];
            
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
            
            
           
            
            cell.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            cell.contentView.layer.shadowRadius = 4.0f;
            cell.contentView.layer.shadowOffset = CGSizeMake(8.0, 5.0f);;
            cell.contentView.layer.shadowOpacity = 0.8f;
            cell.layer.masksToBounds = NO;
            _salesAndPromoCollectionView.layer.masksToBounds = NO;
            
            iconUrl = [NSString stringWithFormat:@"%@%@",parentURL,[catIconArray objectAtIndex:indexPath.row]];
            cell.iconImage.contentMode   = UIViewContentModeScaleAspectFit;
            [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:iconUrl]];

            cell.gradientImage.image = [UIImage imageNamed:bgImage];
            cell.textLbl.text = [NSString stringWithFormat:@"%@",[catNameArray objectAtIndex:indexPath.row]];
            
            return cell;
        }
    }else{
        if( [_categoryType isEqualToString:@"1"])//retail and hypermarket offer
        {
            FilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCollectionViewCell" forIndexPath:indexPath];
           
            NSString *bgImage;
            NSInteger index = indexPath.row+1;

            //Logic for bg gradient
            if (index>3) {
                index = index%3;
                if(index==0){
                    index=3;
                }
                //bgImage =[NSString stringWithFormat:@"SearchTag%ld.png",(long)index];
                bgImage =[NSString stringWithFormat:@"grad%ld.png",(long)index];
            }else{
                //bgImage =[NSString stringWithFormat:@"SearchTag%ld.png",(long)index];
                bgImage =[NSString stringWithFormat:@"grad%ld.png",(long)index];
            }

            //bgImage =[NSString stringWithFormat:@"SearchTag1.png"];
            [cell.offerBtn setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
            //[cell.offerBtn setTitle:[offersNameArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
            
            //OfferBtn is used as color gradient
            cell.lblText.text = [NSString stringWithFormat:@"%@",[store_Offer_NameArray objectAtIndex:indexPath.item]];
            
//            [cell.offerBtn addCornerRadius:3];//.layer.cornerRadius = 3;
//            [cell.offerBtn removeGradient];
//            [cell.offerBtn addGradientWithColorOne: nil colorTwo:nil];
//            cell.offerBtn.clipsToBounds = true;
            

            return cell;
        }else{//sales and promotion
            
            FilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCollectionViewCell" forIndexPath:indexPath];
            
            NSString *bgImage;
            NSInteger index = indexPath.row+1;

            //Logic for bg gradient
            if (index>3) {
                index = index%3;
                if(index==0){
                    index=3;
                }
                //bgImage =[NSString stringWithFormat:@"SearchTag%ld.png",(long)index];
                bgImage =[NSString stringWithFormat:@"grad%ld.png",(long)index];
            }else{
                //bgImage =[NSString stringWithFormat:@"SearchTag%ld.png",(long)index];
                bgImage =[NSString stringWithFormat:@"grad%ld.png",(long)index];
            }
            //bgImage =[NSString stringWithFormat:@"SearchTag1.png"];
            [cell.offerBtn setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
            [cell.offerBtn setTitle:[offersNameArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
//            [[self view] layoutIfNeeded];
//
//            [[self view] layoutIfNeeded];
//            //OfferBtn is used as olor gradient
//            [cell.offerBtn addCornerRadius:3];//.layer.cornerRadius = 3;
//            [cell.offerBtn addGradientWithColorOne: nil colorTwo:nil];
//            cell.offerBtn.clipsToBounds = true;
//            [[self view] layoutIfNeeded];
            
            return cell;
        }
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (collectionView.tag == 1) { //Main CollectionView 
        
        //_categoryType = 1 : sales and promotion
        //_categoryType = 2 : retail and hypermarket offer
        
        
        if( [_categoryType isEqualToString:@"2"]) {
            //Navigation to sales n promo banner lists
            RetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
            vc.pushedFrom = @"categoryItem";
            vc.type  = @"";
            vc.catId = [catIdArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
        //Navigation to stores pages
        RetailDetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"retailDetailView"];
        NSArray *flyersArray = [[storeDetails objectAtIndex:indexPath.row] valueForKey:@"flyers"];
        
        if([flyersArray count] > 0)  {
            
            flyerImagesArray = [[[storeDetails objectAtIndex:indexPath.row] valueForKey:@"flyers"]valueForKey:@"image"];
            vc.flipsArray = flyerImagesArray;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [AlertController alertWithMessage:@"No records found!" presentingViewController:self];
        }
    }
  }else{
      if( [_categoryType isEqualToString:@"2"]) {
           // Filter collectioView in sales n promo
          RetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
          vc.pushedFrom = @"categoryItem";
          vc.type  = @"OfferFilter";
          vc.catId = [offersIdArray objectAtIndex:indexPath.row];
          [self.navigationController pushViewController:vc animated:YES];
      }else{
           // Filter collectioView in Stores page
          MarketViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"marketView"];
          vc.storeOfferId = [store_Offer_IdArray objectAtIndex:indexPath.row];
          vc.type         = @"storeOffer";
          [self.navigationController pushViewController:vc animated:YES];
      }
  }
}

//MARK:- METHODS

-(void)setUI{

    //Setting shadow and corner radius for imageview
    //    _shadowView.backgroundColor = [UIColor clearColor];
    //    _shadowView.center = _ivAdvt.center;
    //    [_shadowView addSubview:_ivAdvt];
    //    _ivAdvt.center = CGPointMake(_shadowView.frame.size.width/2.0f, _shadowView.frame.size.height/2.0f);
    

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

    [self.view layoutIfNeeded];
    //_shadowView.frame = CGRectMake(0,100, self.view.frame.size.width, self.view.frame.size.width / 1.6);
    //_ivAdvt.frame = CGRectMake(0,0, _shadowView.frame.size.width, _shadowView.frame.size.height);
    _shadowViewHeightConstraint.constant = self.view.frame.size.width / 1.7;
    [self.view layoutIfNeeded];

    if([_categoryType isEqualToString:@"1"]){
        //Setting 'filter collectionview' frame
        //self.lblSearchByOffer.frame = CGRectMake(_lblSearchByOffer.frame.origin.x,_lblSearchByOffer.frame.origin.y, _filterCollectionView.frame.size.width, 0);
        self.lblSearchByOffer.frame = CGRectMake(_lblSearchByOffer.frame.origin.x,(_shadowView.frame.origin.y + _shadowView.frame.size.height), _filterCollectionView.frame.size.width, 0);
        self.filterCollectionView.frame = CGRectMake(_filterCollectionView.frame.origin.x,(_lblSearchByOffer.frame.origin.y + _lblSearchByOffer.frame.size.height), _filterCollectionView.frame.size.width, 0);
        
        //Setting 'titleLblOne' frame
        self.titleLblOne.frame = CGRectMake(_titleLblOne.frame.origin.x, (self.filterCollectionView.frame.origin.y + self.filterCollectionView.frame.size.height + gap), _titleLblOne.frame.size.width, _titleLblOne.frame.size.height);
        
    }else{
        //Setting 'filter collectionview' frame
        
        self.lblSearchByOffer.frame = CGRectMake(_lblSearchByOffer.frame.origin.x,(_shadowView.frame.origin.y + _shadowView.frame.size.height + gap), _filterCollectionView.frame.size.width, 18);
        
        self.filterCollectionView.frame = CGRectMake(_filterCollectionView.frame.origin.x,(_lblSearchByOffer.frame.origin.y + _lblSearchByOffer.frame.size.height), _filterCollectionView.frame.size.width, _filterCollectionView.frame.size.height);
        
        //Setting 'titleLblOne' frame
        self.titleLblOne.frame = CGRectMake(_titleLblOne.frame.origin.x, (self.filterCollectionView.frame.origin.y + self.filterCollectionView.frame.size.height), _titleLblOne.frame.size.width, _titleLblOne.frame.size.height);
    }
    

    //Setting collectionview hieght based on content
    CGRect rectangle;
    rectangle = self.salesAndPromoCollectionView.frame;
    rectangle.size = [self.salesAndPromoCollectionView.collectionViewLayout collectionViewContentSize];
    self.salesAndPromoCollectionView.frame = rectangle;

    //Setting 'sales and promo collectionview' frame
    self.salesAndPromoCollectionView.frame = CGRectMake(_salesAndPromoCollectionView.frame.origin.x,(_titleLblOne.frame.origin.y + _titleLblOne.frame.size.height) + gap, _salesAndPromoCollectionView.frame.size.width, _salesAndPromoCollectionView.frame.size.height);

    //Setting scrollview Hieght
    self.mainScrollView.scrollEnabled = YES;
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.salesAndPromoCollectionView.frame.origin.y + self.salesAndPromoCollectionView.frame.size.height+60)];


    if((int)[[UIScreen mainScreen] bounds].size.height ==  896.0){
         [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.salesAndPromoCollectionView.frame.origin.y + self.salesAndPromoCollectionView.frame.size.height+90)];
    }else{
         [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.salesAndPromoCollectionView.frame.origin.y + self.salesAndPromoCollectionView.frame.size.height+60)];
    }

    [self.mainScrollView layoutIfNeeded];
}


-(void)getCategories:(NSString*) catType :(myCompletion)compBlock{
    
  if ([Utility reachable]) {

    [ProgressHUD show];
    
      NSURL *url;
      if([catType isEqualToString:@"1"]){
          url = [NSURL URLWithString:getRetaiCategoryUrl];
      }else if([catType isEqualToString:@"2"]){
          url = [NSURL URLWithString:getSalesCategoryUrl];
      }
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,url] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,url] parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
    {
        NSString *text = [responseObject objectForKey:@"text"];
        NSString *code = [responseObject objectForKey:@"code"];
        //if ([text isEqualToString: @"Success!"])
        if ([code isEqualToString: @"200"])
        {
            if( [catType isEqualToString:@"1"])//RETAIL & HYPERMARKET
            {
                self->storeDetails   = [responseObject objectForKey:@"stores"];
                self->storeNameArray = [self->storeDetails valueForKey:@"store_name"];
                self->storeIconArray = [self->storeDetails valueForKey:@"store_icon"];
                self->storeIdArray   = [self->storeDetails valueForKey:@"retail_store_id"];
                self->store_Offer_IdArray   = [[responseObject objectForKey:@"value"] valueForKey:@"retail_cat_id"];
                self->store_Offer_NameArray = [[responseObject objectForKey:@"value"] valueForKey:@"name"];
                self->bannersImageArray = [[responseObject valueForKey:@"banners"]valueForKey:@"banner"];
                self->bannersTitleArray = [[responseObject valueForKey:@"banners"]valueForKey:@"title"];
                self->bannersDescriptionArray = [[responseObject valueForKey:@"banners"]valueForKey:@"description"];
                self->bannerLinkTypeArray = [[responseObject valueForKey:@"banners"]valueForKey:@"link_type"];
                self->bannerPageLinkArray = [[responseObject valueForKey:@"banners"]valueForKey:@"pagelink"];
                self->bannerClickRedirectIdArray = [[responseObject valueForKey:@"banners"]valueForKey:@"product_id"];
                
                
                NSString *showSearch = [responseObject objectForKey:@"show_search"];
                
                if ([showSearch  isEqual: @"1"]){
                    
                    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(gotoSearch:)];
                    self.navigationItem.rightBarButtonItem.tintColor = UIColor.lightGrayColor;
                    
                }else{
                    
                }
                
            }else{//sales and promotions
                
                //add search btn
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(gotoSearch:)];
                self.navigationItem.rightBarButtonItem.tintColor = UIColor.lightGrayColor;
                
                self->fullCategoryDetails = [responseObject objectForKey:@"value"];
                self->catNameArray   = [self->fullCategoryDetails valueForKey:@"name"];
                self->catIdArray     = [self->fullCategoryDetails valueForKey:@"promo_cat_id"];
                self->catIconArray   = [self->fullCategoryDetails valueForKey:@"app_icon"];
                self->catSlugArray   = [self->fullCategoryDetails valueForKey:@"cat_slug"];
                self->catStatusArray = [self->fullCategoryDetails valueForKey:@"status"];
                self->offersNameArray   = [[responseObject valueForKey:@"offers"]valueForKey:@"name"];
                self->offersIdArray     = [[responseObject valueForKey:@"offers"]valueForKey:@"promo_offer_id"];
                self->bannersImageArray = [[responseObject valueForKey:@"banners"]valueForKey:@"banner"];
                self->bannersTitleArray = [[responseObject valueForKey:@"banners"]valueForKey:@"title"];
                self->bannersDescriptionArray = [[responseObject valueForKey:@"banners"]valueForKey:@"description"];
                self->bannerLinkTypeArray = [[responseObject valueForKey:@"banners"]valueForKey:@"link_type"];
                self->bannerPageLinkArray = [[responseObject valueForKey:@"banners"]valueForKey:@"pagelink"];
                self->bannerClickRedirectIdArray = [[responseObject valueForKey:@"banners"]valueForKey:@"product_id"];
            }
        }

        compBlock (YES);
//        [_salesAndPromoCollectionView reloadData];
//        [_filterCollectionView reloadData];
//        [self setUI];
        [ProgressHUD dismiss];
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [ProgressHUD dismiss];
    }];
  }
  else{
      [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
  }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    menuHideTap.enabled = NO;
        [menu setHidden:YES];
//    isSelected = NO;
//    menu.frame=CGRectMake(-290, 0, 275, 335);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    [self getCategories:_categoryType:^(BOOL finished) {
        if(finished){
            //sliding imageView
            self->_bannerTitleLbl.text = [self->bannersTitleArray objectAtIndex:0];
            self->_bannerDescLbl.text  = [self->bannersDescriptionArray objectAtIndex:0];
            self->_ivAdvt.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
            self->_ivAdvt.pageControl.pageIndicatorTintColor = [UIColor blackColor];
            self->_ivAdvt.slideshowTimeInterval = 5.5f;
            self->_ivAdvt.slideshowShouldCallScrollToDelegate = YES;
            self->_ivAdvt.imageCounterDisabled = YES;

            self->_filterCollectionView.delegate = self;
            self->_filterCollectionView.dataSource = self;
            self->_salesAndPromoCollectionView.dataSource = self;
            self->_salesAndPromoCollectionView.delegate = self;
            
            
            [self->_salesAndPromoCollectionView reloadData];
            [self->_filterCollectionView reloadData];
            [self setUI];
            
        }
    }];
    
    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Sales & promo category"];
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
    menu.frame = CGRectMake(-290, 0, 275, deviceHieght);
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
    {
        if (isSelected) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->isSelected = NO;
                self->menu.frame=CGRectMake(-290, 0,275, self->deviceHieght);
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
      //comment
    }
}


-(IBAction)navigateToRetailPage:(id)sender
{
    RetailViewController *rv= [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
    rv.pushedFrom     = @"categoryItem";
    rv.type           = @"";
    rv.catId = [[NSString alloc]init];
    rv.catId = [[fullCategoryDetails objectAtIndex:[sender tag]]valueForKey:@"promo_cat_id"];
    [self.navigationController pushViewController:rv animated:YES];
}
- (IBAction)allSalesNpromoList:(id)sender {
    
    RetailViewController *rv= [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
    rv.pushedFrom     = @"categoryItem";
    rv.type           = @"All";
    rv.catId = [[NSString alloc]init];
    rv.catId = [fullCategoryDetails objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:rv animated:YES];
}

// you are not a new comment

- (IBAction)searchTap:(id)sender {
    
    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];

    if( [_categoryType isEqualToString:@"1"]) {
        
        vc.searchType = @"retails";
    }else{
        vc.searchType = @"promotions";
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
    ProfileViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
    [self.navigationController pushViewController:view animated:YES];

}
-(void)GoAboutUsPage:(Menu *)sender{
    AboutUsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutUsView"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)History:(Menu *)sender{
    OrderHistoryViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
    [self.navigationController pushViewController:view animated:YES];
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
    [[self view] layoutIfNeeded];
    [[self filterCollectionView] reloadData];
    
//    UIButton *searchBtn = [[UIButton alloc]init];
//    searchBtn.frame = CGRectMake([self view].frame.size.width - 50, 20, 25, 25);
//    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
//    [searchBtn addTarget:self action:@selector(gotoSearch:) forControlEvents:UIControlEventTouchUpInside];
//[[self mainScrollView] addSubview:searchBtn];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(gotoSearch:)];
//    self.navigationItem.rightBarButtonItem.tintColor = UIColor.lightGrayColor;

    
}
- (void) gotoSearch:(UIButton *) sender
{
    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];
    if( [_categoryType isEqualToString:@"1"])
    {
        vc.searchType = @"retails";
    }else{
        vc.searchType = @"promotions";
    }
    [self.navigationController pushViewController:vc animated:false];
    
}



@end
