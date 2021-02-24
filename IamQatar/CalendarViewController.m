//
//  CalendarViewController.m
//  IamQatar
//
//  Created by User on 30/05/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import "CalendarViewController.h"
#import "constants.pch"
#import "EventListCell.h"
#import "EventDetalPage.h"
#import "UIImageView+WebCache.h"
#import "SearchViewController.h"
#import "IamQatar-Swift.h"

@interface CalendarViewController () <UISearchBarDelegate>

@end

@implementation CalendarViewController
{
    NSMutableArray *eventTitleArray;
    NSMutableArray *eventStartDateArray;
    NSMutableArray *eventendDateArray;
    NSMutableArray *eventDescArray;
    NSMutableArray *eventIconArray;
    NSMutableArray *eventTicketRateArray;
    NSMutableArray *eventUrlArray;
    NSMutableArray *eventDetails;
    NSMutableArray *eventlocationArray;
    NSMutableArray *eventTimeArray;
    NSMutableArray *eventTagsArray;

    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;
}

//MARK:- VIEW DIDLOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];


    self.lblNoEvents.hidden = YES;
    self.calendarView.calendarDelegate = self;
    
    //    self.calendarView.shouldShowHeaders = YES;
    //    self.calendarView.shouldMarkToday = NO;
    //    _calendarView.shouldMarkSelectedDate = YES;
    
//    int parentScreenWidth = self.view.frame.size.width;
//    int childScreenWidth  = _calendarView.frame.size.width;
    
//    _calendarView = [_calendarView initWithPosition:((parentScreenWidth / 2) - (childScreenWidth / 2)) y:_searchBar.frame.origin.y+_searchBar.frame.size.height+10];
//    self.calendarView.backgroundColor = UIColor.clearColor;
//    [self.view addSubview:_calendarView];

    self.calendarView.backgroundColor = UIColor.clearColor;
    self.calendarView.contentMode = UIViewContentModeCenter;
    
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

    _searchBar.placeholder = @"Search for Events..";
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];

    menuHideTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    [self.view addGestureRecognizer:menuHideTap];
    menuHideTap.enabled = NO;

    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    self.tabBarController.delegate = self;

    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    // To change background color
    searchField.backgroundColor = [UIColor whiteColor];
    _searchBar.barTintColor = [UIColor clearColor];
    [_searchBar setBackgroundImage:[UIImage new]];

    self.searchBar.delegate = self;
    
    
    [self setUI];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{

    self.calendarView.currentDate = [NSDate date];

    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;

    NSDate *today = [NSDate date];
    NSString *todayString = [NSString stringWithFormat:@"%@",today];
    [self getEventOnDate:todayString];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(-290, 0, 275, deviceHieght);
}

-(void)setUI{
    
    _containerView.frame = CGRectMake(0, 44, _containerView.frame.size.width, _containerView.frame.size.height);
    
    
}

//MARK:- SWIPE METHODS
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
- (void)didChangeCalendarDate:(NSDate *)date
{
    NSLog(@"didChangeCalendarDate:%@", date);
    NSString *dateString = [NSString stringWithFormat:@"%@",date];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate *dateHere  = [dateFormatter dateFromString:dateString];

    // Convert to new Date Format
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDate = [dateFormatter stringFromDate:dateHere];

    [self getEventOnDate:newDate];
}


- (void)getEventOnDate:(NSString*)date{
    
    if ([Utility reachable]) {
        
        [ProgressHUD show];
        NSDictionary *parameters;
        
        parameters = @{@"event_date":date};
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,getEvents] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
            self->eventDetails = nil;
            self->eventTitleArray = nil;
            self->eventStartDateArray  = nil;
            self->eventendDateArray = nil;
            self->eventIconArray  = nil;
            self->eventTicketRateArray = nil;
            self->eventUrlArray   = nil;
            self->eventlocationArray   = nil;
            self->eventTimeArray  = nil;
            self->eventTagsArray  = nil;

             NSString *text = [responseObject objectForKey:@"text"];
             if ([text isEqualToString: @"Success!"])
             {
                 NSLog(@"JSON: %@", responseObject);
                 self->_lblNoEvents.hidden = YES;
                 self->eventDetails    = [responseObject objectForKey:@"value"];
                 self->eventTitleArray = [self->eventDetails valueForKey:@"title"];
                 self->eventStartDateArray  = [self->eventDetails valueForKey:@"event_date"];
                 self->eventendDateArray  = [self->eventDetails valueForKey:@"event_end_date"];
                 self->eventIconArray  = [self->eventDetails valueForKey:@"app_image"];
                 self->eventTicketRateArray  = [self->eventDetails valueForKey:@"ticket_charge"];
                 self->eventUrlArray   = [self->eventDetails valueForKey:@"website_url"];
                 self->eventlocationArray   = [self->eventDetails valueForKey:@"location"];
                 self->eventTimeArray  = [self->eventDetails valueForKey:@"time"];
                 self->eventTagsArray          = [self->eventDetails valueForKey:@"tags"];
                 
             }else{
                
                 self->_lblNoEvents.hidden = NO;
             }
             
             [self.eventsListTableView reloadData];
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

- (IBAction)searchTap:(id)sender {
    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];
    vc.searchType = @"events";
    [self.navigationController pushViewController:vc animated:false];
}


#pragma mark - Table view delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [eventTitleArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventListCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //Getting date from string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:[eventStartDateArray objectAtIndex:indexPath.row]];
    NSDate *endDate = [[NSDate alloc] init];

    NSLog(@"End date>%@",[eventendDateArray objectAtIndex:indexPath.row]);

    endDate = [dateFormatter dateFromString:[eventendDateArray objectAtIndex:indexPath.row]];
    // converting into our required date format
    [dateFormatter setDateFormat:@"EEE, dd MMM"];
    NSString *reqDateString = [dateFormatter stringFromDate:date];
    NSString *reqEndDate    = [dateFormatter stringFromDate:endDate];

    NSLog(@"date is %@", reqDateString);


    NSString *locationString = [eventlocationArray objectAtIndex:indexPath.row];
    NSString *TimeString     = [eventTimeArray objectAtIndex:indexPath.row];
    NSString *DateString     = reqDateString;
    NSString *tagString      = [eventTagsArray objectAtIndex:indexPath.row];

    cell.lblTitle.hidden = NO;
    cell.lblDate.hidden  = NO;
    cell.lblTime.hidden  = NO;
    cell.lblLocation.hidden = NO;

    //---------Hiding icons if no data--------//
    if([locationString length]==0)
    {
        cell.imgLocation.hidden = YES;
    }
    if([TimeString length]==0)
    {
        cell.imgTime.hidden = YES;
    }
    if([DateString length]==0)
    {
        cell.imgDate.hidden = YES;
    }
    if([tagString length]==0)
    {
        cell.imgTag.hidden = YES;
    }

    cell.lblTitle.text      = [eventTitleArray objectAtIndex:indexPath.row];

//    if(reqDateString != nil){
//        cell.lblDate.text       = [NSString stringWithFormat:@"%@ - %@",reqDateString,reqEndDate];//[eventStartDateArray objectAtIndex:indexPath.row];
//    }

    if([reqDateString length]!=0 && [reqDateString length]!=0)
    {
         cell.lblDate.text       = [NSString stringWithFormat:@"%@ - %@",reqDateString,reqEndDate];
    }
    if([reqDateString length]!=0)
    {
          cell.lblDate.text       = [NSString stringWithFormat:@"%@",reqDateString];
    }

    cell.lblLocation.text   = locationString;
    cell.lblTime.text       = [eventTimeArray objectAtIndex:indexPath.row];
    NSURL *imageUrl         = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,[eventIconArray objectAtIndex:indexPath.row]]];
    cell.ivIconImage.contentMode   = UIViewContentModeScaleAspectFill;
    cell.ivIconImage.layer.cornerRadius = 5.0;
    cell.ivIconImage.layer.masksToBounds = YES;
    [cell.ivIconImage sd_setImageWithURL:imageUrl];

    NSArray *tagsArray = [tagString componentsSeparatedByString:@"\n"];
    [self setTags:cell.tagsView array:tagsArray];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventDetalPage *view = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetails"];
    view.fromNotificationTap = NO;
    view.selectedEventId = [[eventDetails objectAtIndex:indexPath.row]valueForKey:@"event_id"];
    
    [self.navigationController pushViewController:view animated:YES];
}

//MARK:- SETTING TAGS DYNAMICALLY
- (void)setTags : (UIView *)view array:(NSArray *)array {

    //view.backgroundColor = UIColor.clearColor;

    NSLog(@"jaba %@",array);

    CGFloat xPos = 0;
    CGFloat yPos = 0;
    CGFloat height = 17;


    UIColor *gradOneStartColor = [UIColor colorWithRed:135/255.f green:245/255.f blue:250/255.f alpha:1.0];
    UIColor *gradOneEndColor   = [UIColor colorWithRed:100/255.0 green:195/255.0 blue:255/255.0 alpha:1.0];
    UIColor *gradTwoStartColor = [UIColor colorWithRed:218/255.0 green:161/255.0 blue:249/255.0 alpha:1.0];
    UIColor *gradTwoEndColor   = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:248/255.0 alpha:1.0];


    for (int i = 0; i < array.count; i++) {


        UILabel *label = [[UILabel alloc]init];
        UIView *bgView = [[UIView alloc]init];

        bgView.layer.cornerRadius = 7;
        bgView.clipsToBounds = true;

        label.text = [NSString stringWithFormat:@"%@",array[i]];
        label.font = [label.font fontWithSize:12];
        label.textColor = UIColor.whiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 10;
        label.clipsToBounds = true;

//        CGSize expectedLabelSize = [[NSString stringWithFormat:@"%@",array[i]] sizeWithFont:label.font constrainedToSize:CGSizeMake(view.frame.size.width, height) lineBreakMode:label.lineBreakMode];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping; //set the line break mode
        NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:label.font, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
        
//        CGSize expectedLabelSize = [[NSString stringWithFormat:@"%@",array[i]] boundingRectWithSize:label.frame.size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil].size;
        
        CGSize expectedLabelSize = [[NSString stringWithFormat:@"%@",array[i]] boundingRectWithSize:CGSizeMake(view.frame.size.width, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil].size;

        float width =  expectedLabelSize.width;
        label.frame = CGRectMake(xPos, yPos, width + 10, height);
        xPos = xPos + width + 15;

        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.startPoint = CGPointMake(0, 0.5);
        gradient.endPoint = CGPointMake(1, 0.5);


        if(i%2 == 0){
            gradient.colors = @[(id)gradOneStartColor.CGColor, (id)gradOneEndColor.CGColor];

        }else{
            gradient.colors = @[(id)gradTwoStartColor.CGColor, (id)gradTwoEndColor.CGColor];
        }


        if (xPos < view.frame.size.width){

            bgView.frame = label.frame;
            gradient.frame = bgView.bounds;
            [bgView.layer insertSublayer:gradient atIndex:0];



            if(![array[i]  isEqual: @""]){
                [view addSubview:bgView];
                [view addSubview:label];
            }
        }
//            else{
//
//            xPos = 0;
//            yPos = yPos + height + 5;
//            label.frame = CGRectMake(xPos, yPos, width + 20, height);
//            xPos = xPos + width + 25;
//
//            bgView.frame = label.frame;
//            gradient.frame = bgView.bounds;
//            [bgView.layer insertSublayer:gradient atIndex:0];
//
//            //  [view addSubview:bgView];
//            //            [view addSubview:label];
//            [view layoutIfNeeded];
//        }
    }

    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,view.frame.size.width, yPos + height + 5);
    //cellHeight = 116 + view.frame.size.height;
}


//MARK:- TABBAR DELGATES
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
                self-> menuHideTap.enabled = YES;
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

@end
