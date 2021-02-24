//
//  MallListViewController.m
//  IamQatar
//
//  Created by User on 21/06/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import "MallListViewController.h"
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import <UIImageView+WebCache.h>
#import "MallDetailsViewController.h"
#import "MallListCellTableViewCell.h"
#import "RetailDetailViewController.h"
#import "IamQatar-Swift.h"

@interface MallListViewController ()

@end

@implementation MallListViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;

    NSArray *bannersArray;
    NSArray *bannerTitleArray;
    NSArray *bannerDescArray;
    NSArray *iconArray;
    NSArray *mallNameArray;
    NSArray *locationArray;
    NSArray *mallIdArray;
    NSArray *mallDetails;

    NSMutableArray *bannerLinkTypeArray;
    NSMutableArray *bannerPageLinkArray;
    NSMutableArray *bannerClickRedirectIdArray;
}

//MARK:- VIEW DIDLOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MALLS";
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

    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
//     self.automaticallyAdjustsScrollViewInsets = NO;
    _searchBar.placeholder = @"Search for Stores..";


    [self getMallListCall:^(BOOL finished) {
        if(finished){
            //sliding imageView
            self->_bannerTitle.text = [self->bannerTitleArray objectAtIndex:0];
            self->_bannerDesc.text  = [self->bannerDescArray objectAtIndex:0];
            self->_bannerView.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
            self->_bannerView.pageControl.pageIndicatorTintColor = [UIColor blackColor];
            self->_bannerView.slideshowTimeInterval = 5.5f;
            self->_bannerView.slideshowShouldCallScrollToDelegate = YES;
            self->_bannerView.imageCounterDisabled = YES;
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
    [tracker set:kGAIScreenName value:@"Mall list"];
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

//MARK:- METHODS
-(void)setUI{

    //corner radius & shadow
    //Setting shadow and corner radius for imageview
    _shadowView.backgroundColor = [UIColor clearColor];
    [_shadowView  addSubview:_bannerView];
    //_shadowView.center = _ivAdvt.center;
    //[_shadowView addSubview:_bannerView];
    // _ivAdvt.center = CGPointMake(_shadowView.frame.size.width/2.0f, _shadowView.frame.size.height/2.0f);

    _bannerView.layer.masksToBounds = YES;
    _shadowView.layer.masksToBounds = NO;
    _shadowView.clipsToBounds = true;
    // set imageview corner
    //_bannerView.layer.cornerRadius = 10.0;
    // set avatar imageview border
//    [_bannerView.layer setBorderColor: [[UIColor clearColor] CGColor]];
//    [_bannerView.layer setBorderWidth: 2.0];

    // set holder shadow
    [_shadowView.layer setShadowOffset:CGSizeZero];
    [_shadowView.layer setShadowOpacity:0.8];
    [_shadowView.layer setShadowRadius:4.0];
    _shadowView.clipsToBounds = NO;

    [self.mallListTableView setContentInset:UIEdgeInsetsMake(12, 0, 12, 0)];
    self.mallListTableView.estimatedRowHeight = 120;
    self.mallListTableView.rowHeight = UITableViewAutomaticDimension;
    
    /**** set frame size of tableview according to number of cells ****/
    _mallListTableView.scrollEnabled = NO;
    [_mallListTableView setFrame:CGRectMake(_mallListTableView.frame.origin.x, _mallListTableView.frame.origin.y, _mallListTableView.frame.size.width,(110 *[mallNameArray count]))];

    
    [self.view layoutIfNeeded];
    CGFloat deviceWidth = [UIScreen mainScreen].bounds.size.width;
   
//    CGFloat bannerWidth = deviceWidth - (self.bannerView.frame.origin.x * 2);
//    _bannerView.frame = CGRectMake(self.bannerView.frame.origin.x, self.bannerView.frame.origin.y,bannerWidth , bannerWidth/2.1);
    
    _bannerDesc.frame = CGRectMake(30, self.bannerView.frame.origin.y + self.bannerView.frame.size.height - self.bannerDesc.frame.size.height - 5,_bannerView.frame.size.width - 10 , _bannerDesc.frame.size.height);
    _bannerTitle.frame = CGRectMake(30, self.bannerDesc.frame.origin.y - 30 ,_bannerView.frame.size.width , _bannerDesc.frame.size.height);
    [self.view layoutIfNeeded];

//    //Setting collectionview hieght based on content
//    CGRect rectangle;
//    rectangle = self.categoryCollectionView.frame;
//    rectangle.size = [self.categoryCollectionView.collectionViewLayout collectionViewContentSize];
//    self.categoryCollectionView.frame = rectangle;
//
//    //Calendar button frame
//    self.calendarBtn.frame = CGRectMake(self.calendarBtn.frame.origin.x, (self.categoryCollectionView.frame.origin.y + self.categoryCollectionView.frame.size.height + 10), self.calendarBtn.frame.size.width, self.calendarBtn.frame.size.height);
//
    //Setting scrollview Hieght
    self.mainScrollView.scrollEnabled = YES;
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.mallListTableView.frame.origin.y + self.mallListTableView.contentSize.height+30)];
    
    self.mainContentViewHeightConstraint.constant = self.mainScrollView.contentSize.height;
    _bannerViewHeightConstraint.constant = self.view.frame.size.width / 1.7;
    
    //[_mainScrollView setContentOffset:CGPointMake(0, -62) animated:FALSE];


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


#pragma mark - KIImagePager Delegate & DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    NSMutableArray *fullUrlArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[bannersArray count]; i++)
    {
        NSString *url =[NSString stringWithFormat:@"%@%@",parentURL,[bannersArray objectAtIndex:i]];
        [fullUrlArray addObject:url];
    };
    NSArray *returnArray = [fullUrlArray copy];
    return returnArray;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleToFill;
}

- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
    _bannerTitle.text = [bannerTitleArray objectAtIndex:index];
    _bannerDesc.text  = [bannerDescArray objectAtIndex:index];
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
}

//MARK:- API CALL
- (void)getMallListCall :(myCompletion)compBlock{
    if([Utility reachable]){

        [ProgressHUD show];
        //NSDictionary *parameters = @{@"user_id": [cartAppDelegate.userProfileDetails objectForKey:@"user_id"]};

//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,getMallListAPI] parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             if ([text isEqualToString: @"Success!"])
             {
                 NSLog(@"JSON: %@", responseObject);
                 self->mallDetails         = [[responseObject objectForKey:@"value"]valueForKey:@"malls"];
                 self->mallIdArray         = [self->mallDetails valueForKey:@"m_id"];
                 self->iconArray           = [self->mallDetails valueForKey:@"icon"];
                 self->mallNameArray       = [self->mallDetails valueForKey:@"mall_name"];
                 self->locationArray       = [self->mallDetails valueForKey:@"address"];

                 self->bannersArray        = [[responseObject objectForKey:@"banners"]valueForKey:@"banner"];
                 self->bannerDescArray     = [[responseObject objectForKey:@"banners"]valueForKey:@"description"];
                 self->bannerTitleArray    = [[responseObject objectForKey:@"banners"]valueForKey:@"title"];
                 self->bannerLinkTypeArray = [[responseObject valueForKey:@"banners"]valueForKey:@"link_type"];
                 self->bannerPageLinkArray = [[responseObject valueForKey:@"banners"]valueForKey:@"pagelink"];
                 self->bannerClickRedirectIdArray = [[responseObject valueForKey:@"banners"]valueForKey:@"product_id"];
             }

             compBlock (YES);
             [self.mallListTableView reloadData];
             [self setUI];
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



#pragma mark - Tabbar delegate
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mallNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MallListCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MallListCellTableViewCell"];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MallListCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.shadowView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.shadowView.layer.shadowRadius = 3;
    cell.shadowView.layer.shadowOffset = CGSizeZero;
    cell.shadowView.layer.shadowOpacity = 0.6;
    cell.layer.masksToBounds = NO;
    cell.shadowView.layer.cornerRadius = 10.0;

    cell.lblTitle.text    = [mallNameArray objectAtIndex:indexPath.row];
    cell.lblLocation.numberOfLines =3;
    cell.lblLocation.text = [locationArray objectAtIndex:indexPath.row];
    [cell.lblLocation sizeToFit];

    //Location label line adjustment
    int charSize = cell.lblLocation.font.lineHeight;
    int rHeight = 39;
    int lineCount = rHeight/charSize;

    if(lineCount > 2){
        cell.lblLocation.frame = CGRectMake(92, 28, 219, 39);
    }


    NSString *iconUrl  = [NSString stringWithFormat:@"%@%@",parentURL,[iconArray objectAtIndex:indexPath.row]];
    cell.iconImageView.contentMode   = UIViewContentModeScaleAspectFit;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.layer.masksToBounds = NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MallDetailsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"MallDetailsViewController"];
    view.mallId = [mallIdArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:view animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 120;
    return UITableViewAutomaticDimension;
    //return 95;
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


//MARK:- GO TO SEARCH
-(void)viewDidAppear:(BOOL)animated
{
    [[self view] layoutIfNeeded];
//
//    UIButton *searchBtn = [[UIButton alloc]init];
//    searchBtn.frame = CGRectMake([self view].frame.size.width - 50, 20, 25, 25);
//    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
//    [searchBtn addTarget:self action:@selector(gotoSearch:) forControlEvents:UIControlEventTouchUpInside];
//
//    [[self mainScrollView] addSubview:searchBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(gotoSearch:)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColor.lightGrayColor;
    
}
- (void) gotoSearch:(UIButton *) sender
{
    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];
    vc.searchType = @"stores";
    [self.navigationController pushViewController:vc animated:false];
}

@end
