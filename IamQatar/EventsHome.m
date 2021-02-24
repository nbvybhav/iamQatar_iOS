//
//  EventsHome.m
//  IamQatar
//
//  Created by alisons on 9/1/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "EventsHome.h"
#import "constants.pch"
#import "EventsList.h"
#import "EventDetalPage.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "CategoryCollectionViewCell.h"
#import "FilterCollectionViewCell.h"
#import "EventsCatCollectionViewCell.h"
#import "EventFilterCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "KIImagePager.h"
#import "SearchViewController.h"
#import "EventsList.h"
#import "CalendarViewController.h"
#import "RetailDetailViewController.h"
#import "IamQatar-Swift.h"

@interface EventsHome ()

@end

@implementation EventsHome
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    NSMutableArray *eventCatNameArray;
    NSMutableArray *eventCatIdArray;
    NSMutableArray *eventCatIconArray;
    NSString *dateHere;
    NSArray *filterArray;
    int deviceHieght;

    NSArray *bannersArray;
    NSArray *bannerDescArray;
    NSArray *bannerTitleArray;
    NSMutableArray *bannerLinkTypeArray;
    NSMutableArray *bannerPageLinkArray;
    NSMutableArray *bannerClickRedirectIdArray;
}


//MARK: VIEW DIDLOAD
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"EVENTS";
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    deviceHieght = [[UIScreen mainScreen] bounds].size.height;
    self.tabBarController.delegate = self;

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

    //UIsearchBar placeholder text color
//    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
//    self.automaticallyAdjustsScrollViewInsets = NO;


    //---------setting datepicker--------//
//  CGRect bounds = [self.view bounds];
//  int datePickerHeight = self.datepicker.frame.size.height;
//  self.datepicker.frame = CGRectMake(0, bounds.size.height - (datePickerHeight), self.datepicker.frame.size.width, self.datepicker.frame.size.height);
    //self.datepicker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    //self.datepicker .backgroundColor = [UIColor whiteColor];
    self.datepicker.datePickerMode  = UIDatePickerModeDate;
    self.datepicker.date=[NSDate date];
    //self.datepicker.minimumDate = [NSDate date];

    
    _DoneBtn = [[UIBarButtonItem alloc]init];
    
    // _viewDatePicker = [[UIView alloc]init];
    //[_viewDatePicker addSubview:self.datepicker];
   // [self.view addSubview:self.datepicker];
    //[self.view addSubview:_viewDatePicker];
    
    
    self.viewDatePicker.hidden = YES;
    self.datepicker.hidden = YES;
    
    //Collectionview cell Nib registration
    [self.categoryCollectionView registerNib:[UINib nibWithNibName:@"EventsCatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"EventsCatCollectionViewCell"];
   
    [self.filterCollectionView registerNib:[UINib nibWithNibName:@"EventFilterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"EventFilterCollectionViewCell"];
    
    filterArray = [NSArray arrayWithObjects:@"Today",@"Tomorrow",@"This Weekend",@"This Month", nil];
    _searchBar.placeholder = @"Search for Events..";

    [self getEventCategories:^(BOOL finished) {
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
    NSLog(@"Viewcontrollers:%@",[self.navigationController viewControllers]);

    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;

    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Events category"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];


    self.viewDatePicker.hidden = YES;
    self.datepicker.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(-290, 0, 275, deviceHieght);
    [self.datepicker removeFromSuperview];

    //    self.viewDatePicker.hidden = YES;
    //    self.datepicker.hidden = YES;
}


//MARK: MENU SWIPE METHODS
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


//MARK:-METHODS
-(void)setUI{
    
            //corner radius & shadow
            //Setting shadow and corner radius for imageview
    _shadowView.backgroundColor = [UIColor clearColor];
    //[_shadowView  addSubview:_bannerView];
            //_shadowView.center = _ivAdvt.center;
            // _ivAdvt.center = CGPointMake(_shadowView.frame.size.width/2.0f, _shadowView.frame.size.height/2.0f);
    
    
    _bannerView.layer.masksToBounds = YES;
    _shadowView.layer.masksToBounds = NO;
            // set imageview corner
            //_bannerView.layer.cornerRadius = 10.0;
            // set avatar imageview border
    //[_bannerView.layer setBorderColor: [[UIColor clearColor] CGColor]];
    //[_bannerView.layer setBorderWidth: 2.0];
            // set holder shadow
    [_shadowView.layer setShadowOffset:CGSizeZero];
    [_shadowView.layer setShadowOpacity:0.5];
    _shadowView.clipsToBounds = NO;
    
//    CGFloat bannerWidth = self.view.frame.size.width - (self.bannerView.frame.origin.x * 2);
//    _bannerView.frame = CGRectMake(self.bannerView.frame.origin.x, self.bannerView.frame.origin.y,bannerWidth , bannerWidth/2.1);
    
    
    
    _bannerDesc.frame = CGRectMake(30, self.bannerView.frame.origin.y + self.bannerView.frame.size.height - self.bannerDesc.frame.size.height - 5,_bannerView.frame.size.width - 10 , _bannerDesc.frame.size.height);
    _bannerTitle.frame = CGRectMake(30, self.bannerDesc.frame.origin.y - 30 ,_bannerView.frame.size.width , _bannerDesc.frame.size.height);
    
    _shadowViewHeightConstraint.constant = self.view.frame.size.width / 1.7;
    [self.view layoutIfNeeded];
    
    
    //Setting collectionview hieght based on content
    CGRect rectangle;
    rectangle = self.categoryCollectionView.frame;
    rectangle.size = [self.categoryCollectionView.collectionViewLayout collectionViewContentSize];
    self.categoryCollectionView.frame = rectangle;
    self.catCollectionViewHeightConstraint.constant = rectangle.size.height;
    
    //Calendar button frame
    //self.calendarBtn.frame = CGRectMake(self.calendarBtn.frame.origin.x, (self.categoryCollectionView.frame.origin.y + self.categoryCollectionView.frame.size.height + 10), self.calendarBtn.frame.size.width, self.calendarBtn.frame.size.height);
    
    self.calendarBtn.frame = CGRectMake(self.calendarBtn.frame.origin.x, (self.categoryCollectionView.frame.origin.y + self.categoryCollectionView.frame.size.height + 10), 150, 40);
    
    [self.calendarBtn addGradientWithColorOne:nil colorTwo:nil];
    [self.calendarBtn addCornerRadius:3];
    
    
    //Setting scrollview Hieght
    self.mainScrollView.scrollEnabled = YES;
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.calendarBtn.frame.origin.y + self.calendarBtn.frame.size.height + 40)];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
    self.viewDatePicker.hidden = YES;
    self.datepicker.hidden     = YES;

    //    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    //    isSelected = NO;
    //    menu.frame=CGRectMake(0, 625, 275, 335);
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}


- (IBAction)searchTap:(id)sender {
    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];
    vc.searchType = @"events";
    [self.navigationController pushViewController:vc animated:false];
}

- (IBAction)calendarAction:(id)sender {
    CalendarViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarViewController"];
    [self.navigationController pushViewController:view animated:YES];
}


#pragma mark - KIImagePager DataSource
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

#pragma mark - KIImagePager Delegate
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

#pragma mark - Collectionview delegates
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1)
    {

        if ((int)[[UIScreen mainScreen] bounds].size.height <= 568)         //iPhone 5 or less
        {
            return CGSizeMake(90, 80);
        }else if((int)[[UIScreen mainScreen] bounds].size.height ==  736.0) //iPhone 6p
        {
            return CGSizeMake(125 , 105);
        }else if((int)[[UIScreen mainScreen] bounds].size.height ==  812.0)//iPhone X
        {
             return CGSizeMake(115 , 105);
        }
        else if((int)[[UIScreen mainScreen] bounds].size.height ==  896.0)//iPhone XR, XSMax
        {
            return CGSizeMake(125 , 100);
        }
        else {
            return CGSizeMake(115 , 100);
        }
    }else{
         if((int)[[UIScreen mainScreen] bounds].size.height ==  736.0)//iPhone 6p
        {
            return CGSizeMake(110 , 50);
        }
         else if((int)[[UIScreen mainScreen] bounds].size.height >=  812.0)//iPhone X or greater
        {
            return CGSizeMake(120 , 50);
        }else{
            return CGSizeMake(88  , 50);
        }
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag == 1){
        return [eventCatNameArray count];
    }else{
        return 4;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1) {
        
        EventsCatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventsCatCollectionViewCell" forIndexPath:indexPath];
        
        NSString *bgImage;
        NSInteger index = indexPath.row+1;
        NSString *iconUrl;
        
        iconUrl = [NSString stringWithFormat:@"%@%@",parentURL,[eventCatIconArray objectAtIndex:indexPath.row]];
        cell.iconImage.contentMode   = UIViewContentModeScaleAspectFit;
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
        
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
        cell.gradientImage.image = [UIImage imageNamed:bgImage];
        
        
        cell.lblTitle.text = [NSString stringWithFormat:@"%@",[eventCatNameArray objectAtIndex:indexPath.row]];
        
        cell.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.contentView.layer.shadowRadius = 4.0f;
        cell.contentView.layer.shadowOffset = CGSizeMake(8.0, 5.0f);;
        cell.contentView.layer.shadowOpacity = 0.8f;
        cell.layer.masksToBounds = NO;
        _categoryCollectionView.layer.masksToBounds = NO;
        
        return cell;
    }else{
        EventFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventFilterCollectionViewCell" forIndexPath:indexPath];
        
        //Shadow
        cell.btnFilter.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
        cell.btnFilter.layer.shadowOffset = CGSizeMake(8.0, 5.0f);
        cell.btnFilter.layer.shadowOpacity = 0.8f;
        cell.btnFilter.layer.shadowRadius = 4.0f;
        cell.btnFilter.layer.masksToBounds = NO;
        cell.layer.masksToBounds = NO;
        
        NSString *bgImage;
        NSInteger index = indexPath.row+1;
        
        //Logic for bg gradient
        if (index>3) {
            index = index%3;
            if(index==0){
                index=1;
            }
            bgImage =[NSString stringWithFormat:@"grad%ld.png",(long)index];
        }else{
            bgImage =[NSString stringWithFormat:@"grad%ld.png",(long)index];
        }
        
        [cell.btnFilter setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
        
        
        [cell.btnFilter addCornerRadius:3];//.layer.cornerRadius = 3;
        //[cell.btnFilter removeGradient];
        //[cell.btnFilter addGradientWithColorOne: nil colorTwo:nil];
        cell.btnFilter.clipsToBounds = true;
        [cell.btnFilter setTitle:[filterArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        return cell;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == 1) {
        
        EventsList *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"eventList"];
        vc.eventCatId = [eventCatIdArray objectAtIndex:indexPath.row];
        vc.eventName  = [eventCatNameArray objectAtIndex:indexPath.row];
        vc.IsCalendar = @"No";
        [self.navigationController pushViewController:vc animated:YES];
 
    }else{

        EventsList *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"eventList"];
        NSDate *date = [NSDate date];
        NSString *dateString = [NSString stringWithFormat:@"%@",date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        NSDate *dateHere  = [dateFormatter dateFromString:dateString];

        // Converting Date Format
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *today = [dateFormatter stringFromDate:dateHere];
        NSDate *todaysDate =[dateFormatter dateFromString:today];
        NSArray *dayArray;

        if(indexPath.row == 0){//today

            dayArray = [NSArray arrayWithObjects:today, nil];

        }else if(indexPath.row == 1){//tomorrow
            
            NSDateComponents *dateComponents = [NSDateComponents new];
            dateComponents.day = 1;
            NSDate *tomorrow = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                            toDate: todaysDate
                                                                           options:0];
            
            dayArray = [NSArray arrayWithObjects:[dateFormatter stringFromDate : tomorrow] , nil];
            
        }else if(indexPath.row == 2){//weekend
 
            dayArray = [self daysThisWeek];

        }else if(indexPath.row == 3){//this month
   
            NSDate *today = [NSDate date];
            NSCalendar *cal = [NSCalendar currentCalendar];
 
            NSMutableArray *datesThisMonth = [NSMutableArray array];
            NSRange rangeOfDaysThisMonth = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:today];
            
            
            NSDateComponents *components = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra) fromDate:today];
            
            [components setHour:0];
            [components setMinute:0];
            [components setSecond:0];
            
            
            
            for (NSInteger i = rangeOfDaysThisMonth.location ; i < NSMaxRange(rangeOfDaysThisMonth); ++i) {
                [components setDay:i];
                NSDate *dayInMonth = [cal dateFromComponents:components];

                NSString *dateString = [NSString stringWithFormat:@"%@",dayInMonth];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
                [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
                NSDate *dateHere  = [dateFormatter dateFromString:dateString];

                // Converting Date Format
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                [datesThisMonth addObject:[dateFormatter stringFromDate:dateHere]];

            }
            dayArray = datesThisMonth;
            
        }
 
        NSLog(@"%@",dayArray );
 
        NSError *err;
        
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:dayArray options:NSJSONWritingPrettyPrinted error:&err];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        NSLog(@"jsonData as string:\n%@", jsonString);

        vc.eventDate = jsonString;
        vc.IsCalendar = @"Yes";

        vc.eventCatId = [eventCatIdArray objectAtIndex:indexPath.row];
        vc.eventName  = [eventCatNameArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(NSArray*)daysThisWeek
{
    return  [self daysInWeek:0 fromDate:[NSDate date]];
}


-(NSArray*)daysNextWeek
{
    return  [self daysInWeek:1 fromDate:[NSDate date]];
}

-(NSArray*)daysInWeek:(int)weekOffset fromDate:(NSDate*)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //ask for current week
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps=[calendar components:NSCalendarUnitWeekOfYear|NSCalendarUnitYear fromDate:date];
    
    //create date on week start
    NSDate* weekstart=[calendar dateFromComponents:comps];
    NSDateComponents* moveWeeks=[[NSDateComponents alloc] init];
    moveWeeks.weekOfYear=weekOffset;
    weekstart=[calendar dateByAddingComponents:moveWeeks toDate:weekstart options:0];

    //add 7 days
    NSMutableArray* week=[NSMutableArray arrayWithCapacity:7];
    
    for (int i=1; i<=7; i++) {
        NSDateComponents *compsToAdd = [[NSDateComponents alloc] init];
        compsToAdd.day=i;
        NSDate *nextDate = [calendar dateByAddingComponents:compsToAdd toDate:weekstart options:0];
        NSString *dateString = [NSString stringWithFormat:@"%@",nextDate];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        NSDate *dateHere  = [dateFormatter dateFromString:dateString];

        
        // Converting Date Format
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [week addObject:[dateFormatter stringFromDate:dateHere]];

    }
    return [NSArray arrayWithArray:week];
}

//MARK:- API CALL
- (void)getEventCategories :(myCompletion)compBlock{
    
  if([Utility reachable]){
      
        [ProgressHUD show];
        //NSDictionary *parameters = @{@"user_id": [cartAppDelegate.userProfileDetails objectForKey:@"user_id"]};
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
      AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,getEventsCat] parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
        {
            NSString *text = [responseObject objectForKey:@"text"];
            if ([text isEqualToString: @"Success!"])
            {
                NSLog(@"JSON: %@", responseObject);
                self->eventCatNameArray = [[responseObject objectForKey:@"value"]valueForKey:@"name"];
                self->eventCatIdArray= [[responseObject objectForKey:@"value"]valueForKey:@"event_cat_id"];
                self->eventCatIconArray = [[responseObject objectForKey:@"value"]valueForKey:@"app_icon"];
                self->bannersArray   = [[responseObject objectForKey:@"banners"]valueForKey:@"banner"];
                
                if([[responseObject objectForKey:@"banners"]count]>0)
                {
                    self->bannerDescArray     = [[responseObject objectForKey:@"banners"]valueForKey:@"description"];
                    self->bannerTitleArray    = [[responseObject objectForKey:@"banners"]valueForKey:@"title"];
                    self->bannerLinkTypeArray = [[responseObject valueForKey:@"banners"]valueForKey:@"link_type"];
                    self->bannerPageLinkArray = [[responseObject valueForKey:@"banners"]valueForKey:@"pagelink"];
                    self->bannerClickRedirectIdArray = [[responseObject valueForKey:@"banners"]valueForKey:@"product_id"];
                }
            }
            
             compBlock (YES);
            [self->_categoryCollectionView reloadData];
            [self->_filterCollectionView reloadData];
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

- (IBAction)eventCategoryTap:(id)sender
{
    EventsList *view = [self.storyboard instantiateViewControllerWithIdentifier:@"eventList"];
    NSString *strVal = [NSString stringWithFormat:@"%ld",(long)[sender tag]];
    view.eventCatId = strVal;
    [self.navigationController pushViewController:view animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MARK: TAB BAR DELEGATE METHODS
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
    [[self view] layoutIfNeeded];
    
//    UIButton *searchBtn = [[UIButton alloc]init];
//    searchBtn.frame = CGRectMake([self view].frame.size.width - 50, 20, 25, 25);
//    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
//    [searchBtn addTarget:self action:@selector(gotoSearch:) forControlEvents:UIControlEventTouchUpInside];
//    [[self mainScrollView] addSubview:searchBtn];
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(gotoSearch:)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColor.lightGrayColor;
    
}
- (void) gotoSearch:(UIButton *) sender
{
    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];
    vc.searchType = @"events";
    [self.navigationController pushViewController:vc animated:false];
    
}



@end
