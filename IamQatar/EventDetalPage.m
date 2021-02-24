//
//  EventDetalPage.m
//  IamQatar
//
//  Created by alisons on 9/3/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "EventDetalPage.h"
#import "constants.pch"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import <EventKit/EventKit.h>
#import "EXPhotoViewer.h"
#import "SearchViewController.h"
#import "IamQatar-Swift.h"

@interface EventDetalPage () <UIActivityItemSource>
@property (strong, nonatomic) EKEventStore *eventStore;
@property (nonatomic) BOOL isAccessToEventStoreGranted;
@end


@implementation EventDetalPage
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;

    NSString *responseValue;
}


//MARK:- VIEW DID LOAD

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;

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
    swipeleft.cancelsTouchesInView = YES;


    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    swiperight.cancelsTouchesInView = YES;

    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    NSLog(@"selectedEventId>>%@",_selectedEventId);


    //----- Dynamic Imageview height adjustment ----//
    //    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //    CGFloat screenWidth = screenRect.size.width;

    //    double width = _ivEvent.image.size.width;
    //    double height = _ivEvent.image.size.height;
    //    double aspect = width/height;
    //    double nHeight = screenWidth / aspect;
    //   _ivEvent.frame = CGRectMake(0, 0, screenWidth, nHeight);


    //[_ivEvent.layer setCornerRadius:10.0];
    _ivEvent.contentMode = UIViewContentModeScaleToFill;
    _imageContainerView.layer.masksToBounds = NO;
    // set holder shadow
    [_imageContainerView.layer setShadowOffset:CGSizeZero];
    [_imageContainerView.layer setShadowOpacity:0.5];
    _imageContainerView.clipsToBounds = NO;


    [self updateAuthorizationStatusToAccessEventStore];
    [self getEventDetailsApiCall];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:true];
     NSLog(@"Viewcontrollers:%@",[self.navigationController viewControllers]);
    
    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Events detail page"];
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

//MARK:- API CALL
- (void)getEventDetailsApiCall{
    
    if ([Utility reachable]) {

        [ProgressHUD show];
        NSDictionary *parameters;

        if(_fromNotificationTap){
            parameters = @{@"event_id":[_selectedEventId objectAtIndex:0]};
        }else{
            parameters = @{@"event_id":_selectedEventId};
        }

//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,getEventDetails] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             
              NSLog(@"%@%@",parentURL,getEventDetails);
              NSLog(@"JSON: %@", responseObject);
             
             NSString *text = [responseObject objectForKey:@"text"];
             if ([text isEqualToString: @"Success!"])
             {
                 self->responseValue = [[responseObject valueForKey:@"value"] objectAtIndex:0];
                 self->_lblTitle.text = [self->responseValue valueForKey:@"title"];
                 self.title = [self->responseValue valueForKey:@"title"];
                 self->_lblTime.text  = [self->responseValue valueForKey:@"time"];
                 self->_lblFare.text  = [self->responseValue valueForKey:@"ticket_charge"];
                 self->_lblUrl.text   = [self->responseValue valueForKey:@"website_url"];
                 self->_lblLocation.text = [self->responseValue valueForKey:@"location"];

                 //HTML String
                 //Converting HTML string with UTF-8 encoding to NSAttributedString
                 NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                         initWithData: [[self->responseValue valueForKey:@"description"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                         options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                         documentAttributes: nil
                                                         error: nil ];
                 self->_tvSynopsis.attributedText = attributedString;

                 //Getting date from string
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                 NSDate *startDate = [[NSDate alloc] init];
                 startDate = [dateFormatter dateFromString:[self->responseValue valueForKey:@"event_date"]];

                 NSDate *endDate = [[NSDate alloc] init];
                 endDate = [dateFormatter dateFromString:[self->responseValue valueForKey:@"event_end_date"]];

                 // converting into our required date format
                 [dateFormatter setDateFormat:@"EEE, dd MMM"];

                 NSString *reqStartDate = [dateFormatter stringFromDate:startDate];
                 NSString *reqEndDate   = [dateFormatter stringFromDate:endDate];

                 if([[self->responseValue valueForKey:@"recurring_period"]isEqualToString:@""])
                 {
                     if(([reqStartDate length]!=0) && ([reqEndDate length]!=0))
                     {
                         self->_lblDate.text  = [NSString stringWithFormat:@"%@ - %@",reqStartDate,reqEndDate];
                     }else if(([reqStartDate length]!=0) && ([reqEndDate length] == 0)){
                         self->_lblDate.text  = [NSString stringWithFormat:@"%@",reqStartDate];
                     }
                 }else{
                     self->_lblDate.text  = [NSString stringWithFormat:@"%@",reqStartDate];
                 }



                 //If start date & end date are same, show start date only
                 if([reqStartDate isEqual:reqEndDate]){
                     self->_lblDate.text       = [NSString stringWithFormat:@"%@",reqStartDate];
                 }

                 NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,[self->responseValue valueForKey:@"app_image"]]];
                 [self->_ivEvent sd_setImageWithURL:imageUrl];

                 NSString *tagsString = [self->responseValue valueForKey:@"tags"];
                 NSArray *tagsArray = [tagsString componentsSeparatedByString:@"\n"];

                 if (tagsArray.count > 0){
                     [self setTags:self->_tagsView array:tagsArray];
                 }
             }else{
                
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


//MARK:- BTN ACTIONS
- (IBAction)urlTapAction:(UIButton *)sender {
    
    NSString *url = [responseValue valueForKey:@"website_url"];
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
}

- (IBAction)shareAction:(id)sender
{
    UIImage *shareImg      = _ivEvent.image;
    NSString *noteStr = [NSString stringWithFormat:@"%@\n%@",_lblTitle.text,_tvSynopsis.text];
    
    NSArray *itemArray;
    if(shareImg == nil){
        itemArray = @[noteStr];
    }else{
        itemArray = @[noteStr,shareImg];
    }

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemArray applicationActivities:nil];
    activityVC.excludedActivityTypes = @[ UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeAirDrop, UIActivityTypeSaveToCameraRoll];//UIActivityTypeCopyToPasteboard
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{

    if ([activityType containsString:@"WhatsApp"])
        // You can also match against the exact id "net.whatsapp.WhatsApp.ShareExtension"
    {
        if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]]){


        }
    }

    return nil;
}


- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    if ([activityType isEqualToString:UIActivityTypeMail]) {
        return @"Your subject goes here";
    }
    return nil;
}

- (IBAction)searchTap:(id)sender {

    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];
    vc.searchType = @"events";
    [self.navigationController pushViewController:vc animated:false];
}

//MARK:- METHODS
- (void)addShadowTo:(UIView*)view{
    
    UIView *shadowView = [[UIView alloc] initWithFrame:view.frame];
    
    
    [shadowView.layer setShadowOffset:CGSizeZero];
    [shadowView.layer setShadowOpacity:0.5];
    [shadowView.layer setShadowColor:[[UIColor grayColor]CGColor]];
    
    shadowView.backgroundColor = [UIColor whiteColor];
    [view.superview addSubview:shadowView];
    shadowView.layer.cornerRadius = view.layer.cornerRadius;
    [view.superview bringSubviewToFront:view];
    
}


-(void)setUI{

    [self addShadowTo:self.ivEvent];

//    _imgTicket.frame = CGRectMake(_imgTicket.frame.origin.x, _tagsView.frame.origin.y + _tagsView.frame.size.height, _imgTicket.frame.size.width, _imgTicket.frame.size.height);
//
//    _lblFare.frame = CGRectMake(_lblFare.frame.origin.x, _tagsView.frame.origin.y + _tagsView.frame.size.height, _lblFare.frame.size.width, _lblFare.frame.size.height);
//
//    _imgUrl.frame = CGRectMake(_imgUrl.frame.origin.x, _lblFare.frame.origin.y + _lblFare.frame.size.height, _imgUrl.frame.size.width, _imgUrl.frame.size.height);
//
//    _lblUrl.frame = CGRectMake(_lblUrl.frame.origin.x, _imgUrl.frame.origin.y, _lblUrl.frame.size.width, _lblUrl.frame.size.height);


    _lblTitleTwo.frame = CGRectMake(_lblTitleTwo.frame.origin.x, _lblUrl.frame.origin.y + _lblUrl.frame.size.height + 20, _lblTitleTwo.frame.size.width, _lblTitleTwo.frame.size.height);

    //Description textview
    _tvSynopsis.frame = CGRectMake(_tvSynopsis.frame.origin.x, _lblTitleTwo.frame.origin.y + _lblTitleTwo.frame.size.height  , _tvSynopsis.frame.size.width, _tvSynopsis.frame.size.height);

    [_tvSynopsis sizeToFit];
    CGRect frame = _tvSynopsis.frame;
    frame.size.height = _tvSynopsis.contentSize.height;
    _tvSynopsis.frame = frame;

    
    _bannerViewHeightConstraint.constant = self.view.frame.size.width / 1.7;
    
    //Setting scrollview total Hieght
    self.mainScrollView.scrollEnabled = YES;
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.tvSynopsis.frame.origin.y + self.tvSynopsis.frame.size.height+20)];
    
    
}



- (void)setTags : (UIView *)view array:(NSArray *)array {
    
    view.backgroundColor = UIColor.clearColor;
    NSLog(@"array elements %@",array);

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

        bgView.layer.cornerRadius = 2;
        bgView.clipsToBounds = true;

        label.text = [NSString stringWithFormat:@"%@",array[i]];
        label.font = [label.font fontWithSize:12];
        label.textColor = UIColor.whiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 2;
        label.clipsToBounds = true;

        float width = 7 * label.text.length;
        label.frame = CGRectMake(xPos, yPos, width + 20, height);
        xPos = xPos + width + 25;

//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.startPoint = CGPointMake(0, 0.5);
//        gradient.endPoint = CGPointMake(1, 0.5);
//
//
//        if(i%2 == 0){
//            gradient.colors = @[(id)gradTwoStartColor.CGColor, (id)gradTwoEndColor.CGColor];
//
//        }else{
//            gradient.colors = @[(id)gradOneStartColor.CGColor, (id)gradOneEndColor.CGColor];
//        }


        if (xPos < view.frame.size.width){

            bgView.frame = label.frame;
            [bgView addGradientWithColorOne:nil colorTwo:nil];
            //gradient.frame = bgView.bounds;
            //[bgView.layer insertSublayer:gradient atIndex:0];

            [view addSubview:bgView];
            [view addSubview:label];

        }else{

            xPos = 0;
            yPos = yPos + height + 5;
            label.frame = CGRectMake(xPos, yPos, width + 20, height);
            xPos = xPos + width + 25;

            bgView.frame = label.frame;
            [bgView addGradientWithColorOne:nil colorTwo:nil];
            //gradient.frame = bgView.bounds;
            //[bgView.layer insertSublayer:gradient atIndex:0];

            [view addSubview:bgView];
            [view addSubview:label];
            [view layoutIfNeeded];

        }
    }

    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,view.frame.size.width, yPos + height + 5);
    self.tagsViewHeightConstraint.constant = view.frame.size.height;
    
    [self setUI];

}

- (void)updateAuthorizationStatusToAccessEventStore {
    // 2
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];

    switch (authorizationStatus) {
            // 3
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
//                                                                message:@"This app doesn't have access to your Reminders." delegate:nil
//                                                      cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
//            [alertView show];
            UIAlertController * alert = [UIAlertController
                            alertControllerWithTitle:@"Access Denied"
                                             message:@"This app doesn't have access to your Reminders."
                                      preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                actionWithTitle:@"Dismiss"
                                          style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }

            // 4
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            break;

            // 5
        case EKAuthorizationStatusNotDetermined: {
             __weak EventDetalPage *weakSelf = self;
            [self.eventStore requestAccessToEntityType:EKEntityTypeReminder
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    weakSelf.isAccessToEventStoreGranted = granted;
                                                });
                                            }];
            break;
        }
    }
}



- (IBAction)addToCalendar:(id)sender {

    UIAlertController * alert = [UIAlertController  alertControllerWithTitle:@"Event" message:@"Do you want to remind this event?" preferredStyle:UIAlertControllerStyleAlert];
    //Add Buttons

    NSString *dateString = [responseValue valueForKey:@"event_date"];
    NSDate *eventDate = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    eventDate = [formatter dateFromString:dateString];

    NSString *endDateString = [responseValue valueForKey:@"event_end_date"];
    NSDate *eventEndDate = [[NSDate alloc]init];
    eventEndDate = [formatter dateFromString:endDateString];

    NSDateComponents *yearComponent = [[NSDateComponents alloc] init];
    yearComponent.year = 1;

    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextYear = [theCalendar dateByAddingComponents:yearComponent toDate:[NSDate date] options:0];

    _eventStore = [[EKEventStore alloc] init];
    EKEvent *event = [EKEvent eventWithEventStore:_eventStore];

    UIAlertAction* yesButton = [UIAlertAction  actionWithTitle:@"Yes" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action) {
        [self->_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                    if (granted)
                    {
                        NSLog(@"val:>%@",self->responseValue);
                        EKRecurrenceRule *recurrence;
                        
                        if([[self->responseValue valueForKey:@"recurring_period"]isEqualToString:@"monthly"])
                        {
                            EKRecurrenceEnd *endRecurrence = [EKRecurrenceEnd recurrenceEndWithEndDate:nextYear];
                            recurrence = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:1 end:endRecurrence];
                            event.title     = [self->responseValue valueForKey:@"title"];;
                            event.startDate = eventDate;
                            event.endDate = eventDate;
                            event.calendar = self->_eventStore.defaultCalendarForNewEvents;
                          [event addRecurrenceRule: recurrence];
                        }
                        else if([[self->responseValue valueForKey:@"recurring_period"]isEqualToString:@"weekly"])
                        {
                         EKRecurrenceEnd *endRecurrence = [EKRecurrenceEnd recurrenceEndWithEndDate:nextYear];
                          recurrence = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:endRecurrence];
                            event.title     = [self->responseValue valueForKey:@"title"];;
                            event.startDate = eventDate;
                            event.endDate = eventDate;
                            event.calendar = self->_eventStore.defaultCalendarForNewEvents;
                            [event addRecurrenceRule: recurrence];
                        }
                        else{
                            event.endDate = eventEndDate;
                            event.startDate = eventDate;
                            event.title     = [self->responseValue valueForKey:@"title"];;
                            event.calendar = self->_eventStore.defaultCalendarForNewEvents;
                        }


                        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:[NSDate dateWithTimeInterval:-36000 sinceDate:event.startDate]];
                        [event addAlarm:alarm];
                        NSLog(@"startdate>>%@ endDate>>%@",event.startDate,event.endDate);

                        NSError *error;
                        if ([self->_eventStore saveEvent:event span:EKSpanFutureEvents commit:YES error:&error])
                        {
                            NSLog(@"Event added succesfully >>>");
                            //Success
                            [[NSUserDefaults standardUserDefaults]setValue:event.eventIdentifier forKey:@"EventID"];
                            [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"SavedEvent"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                        }else{
                            // An error occurred, so log the error description.
                            NSLog(@"Error>>> %@", [error localizedDescription]);
                        }
                    }else{
                        // code here for when the user does NOT allow your app to access the calendar
                        NSError *err;
                        [self->_eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    }
                }];
            }];


    UIAlertAction* noButton = [UIAlertAction  actionWithTitle:@"No"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];

    //Add your buttons to alert controller
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    //    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    //    isSelected = NO;
    //    menu.frame=CGRectMake(0, 625, 275, 335);
}




//MARK:- TAB DELEGATES

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
    {

        if (isSelected) {

            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->isSelected = NO;
                self->menu.frame = CGRectMake(-290, 0, 275, self->deviceHieght);
            } completion:^(BOOL finished){

                // if you want to do something once the animation finishes, put it here
                self->menuHideTap.enabled = NO;
                [self->menu setHidden:YES];
            }];
        }else{

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
        self-> menuHideTap.enabled = YES;
        self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
        self->isSelected = YES;

    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
}


//MARK:- POPUP MENU DELEGATES
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
    contestViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"contestView"];
    [self.navigationController pushViewController:view animated:YES];
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
//
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


