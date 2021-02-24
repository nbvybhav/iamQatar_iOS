//
//  AppDelegate.m
//  IamQatar
//
//  Created by alisons on 8/17/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "constants.pch"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "SearchViewController.h"
#import "categoryViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import <Google/SignIn.h>
#import <GoogleSignIn/GoogleSignIn.h>
//#import <GGLCore/GGLCore.h>
#import <GLKit/GLKit.h>
#import "MainCategoryViewController.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <GoogleAnalytics/GAI.h>
#import "EventsList.h"
#import "EventDetalPage.h"

#import "MainCategoryViewController.h"
#import "EventsList.h"
#import "RetailViewController.h"
#import "contestViewController.h"
#import "MarketViewController.h"
#import "BestBuyViewController.h"
#import "ProfileViewController.h"
#import "RetailDetailViewController.h"
#import "EXPhotoViewer.h"
#import "IamQatar-Swift.h"

@import GooglePlaces;
@import GooglePlacePicker;

@interface AppDelegate ()
@end

@implementation AppDelegate

NSArray *advtImageUrlArray;
NSMutableArray *imageFullUrlArray;
NSDictionary *versionDict;
NSMutableArray *bannerArray,*bigImgArray,*idArray,*linkArray,*linkTypeArray,*retailItems,*productIdArray;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //set bar button item color
    self.window.tintColor = UIColor.lightGrayColor;
    [GIDSignIn sharedInstance].presentingViewController = self;
    
    //Google SDK
//    NSError* configureError;
//    [[GGLContext sharedInstance] configureWithError: &configureError];
//    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-11111111-2"];
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GIDSignIn sharedInstance].delegate = self;

    
    
    //FB SDK
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    _userProfileDetails   = [[NSMutableDictionary alloc] init];
    self.tabBarController = [[UITabBarController alloc] init];

    
    
    self.tabBarController.delegate = self;
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    
    FirstViewController *VC1 = [sb instantiateViewControllerWithIdentifier:@"fv"];
    UINavigationController *VC1Navigation = [[UINavigationController alloc]
                                             initWithRootViewController:VC1];
    VC1Navigation.navigationBar.hidden = false;
    
    
    //SecondViewController *VC2 = [sb instantiateViewControllerWithIdentifier:@"sv"];
    //UINavigationController *VC2Navigation = [[UINavigationController alloc] initWithRootViewController:VC2];
    //VC2Navigation.navigationBar.hidden = false;
    
    MainCategoryViewController *VC3 = [sb instantiateViewControllerWithIdentifier:@"MainCat"];
    UINavigationController *VC3Navigation = [[UINavigationController alloc]
                                             initWithRootViewController:VC3];
    VC3Navigation.navigationBar.hidden = false;
    
    ProfileViewController *VC4 = [sb instantiateViewControllerWithIdentifier:@"profileView"];
    UINavigationController *VC4Navigation = [[UINavigationController alloc]
                                             initWithRootViewController:VC4];
    VC4Navigation.navigationBar.hidden = false;
    
    //cartViewController *VC5 = [sb instantiateViewControllerWithIdentifier:@"cartView"];
    CartNewViewController *VC5 = [sb instantiateViewControllerWithIdentifier:@"CartNewViewController"];
    UINavigationController *VC5Navigation = [[UINavigationController alloc]
                                             initWithRootViewController:VC5];
    VC5Navigation.navigationBar.hidden = false;
    
    
    NSArray* controllers = [NSArray arrayWithObjects:VC1Navigation,VC4Navigation,VC3Navigation,VC5Navigation, nil];
    self.tabBarController.viewControllers = controllers;
    self.tabBarController.selectedIndex = 2;

    
    //MARK:- Registering for remote notification
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
//    else
//    {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
//    }
    
    //Login status
    NSString *plistStatus = [Utility getfromplist:@"login" plist:@"iq"];
    
    if ([plistStatus isEqualToString:@"YES"]) {
        self.window.rootViewController = self.tabBarController;
        
        //---------user profile details got from previous login-----------//
        id userProfile = [Utility getfromplist:@"userProfile" plist:@"iq"];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.userProfileDetails = userProfile;
    }
    else
    {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIStoryboard *mainStoryBoard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
        [self.window makeKeyAndVisible];
    }
    
    [Fabric with:@[[Twitter class]]];

    //GooglePlace API
//    [GMSPlacesClient provideAPIKey:@"AIzaSyC8pz77rBd3y3K-CyDm01n2h7cVpLwDwTE"];
//    [GMSServices provideAPIKey:@"AIzaSyC8pz77rBd3y3K-CyDm01n2h7cVpLwDwTE"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyCd5UTU_HNoBSvAtAixKw0Ngsusq9xCxak"];
    [GMSServices provideAPIKey:@"AIzaSyCd5UTU_HNoBSvAtAixKw0Ngsusq9xCxak"];
    //Google analytics
    GAI *gai = [GAI sharedInstance];
    [gai trackerWithTrackingId:@"UA-109260178-1"];

    //Status bar color
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //nav bar title font
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:0.8],
    NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]}];
    
    [[UINavigationBar appearance] setTintColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];


    return YES;
}

-(void)versionCheck{
    int current_version,new_version,force_update_val ;
    UIWindow* topWindow;
    
    current_version = [[versionDict objectForKey:@"appversion"]intValue];
    new_version     = [[versionDict objectForKey:@"newversion"]intValue];
    force_update_val= [[versionDict objectForKey:@"force_update"]intValue];
    
    if (new_version>current_version) {
        //Update available
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                       message:@"PLEASE UPDATE TO THE LATEST APP VERSION FOR GOOD USER EXPERIENCE"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSString *simple = @"http://itunes.com/apps/iamqatar";
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:simple]];
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:simple];
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                if (success) {
                     NSLog(@"Opened url");
                }
            }];
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        topWindow.rootViewController = [UIViewController new];
        topWindow.windowLevel = UIWindowLevelAlert + 1;
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
     if (force_update_val == 1) {
        //do force update alert
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                       message:@"A NEW VERSION OF THE APPLICATION IS AVAILABLE IN APPSTORE. PLEASE UPGRADE YOUR APPLICATION TO PROCEED FURTHER"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSString *simple = @"http://itunes.com/apps/iamqatar";
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:simple]];
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:simple];
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                if (success) {
                     NSLog(@"Opened url");
                }
            }];
        }];
        
        [alert addAction:okAction];
        
        topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        topWindow.rootViewController = [UIViewController new];
        topWindow.windowLevel = UIWindowLevelAlert + 1;
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

//MARK:- PUSH NOTIFICATION DELAGATES
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    NSLog(@"token>%@",devToken);
    [Utility addtoplist:devToken key:@"deviceToken" plist:@"iq"];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Userinfo %@",userInfo);
    
    NSString *notficationType = [[userInfo objectForKey:@"body"]valueForKey:@"itemtype"];
    NSString *catId           = [[userInfo objectForKey:@"body"]valueForKey:@"item_id"];
    NSString *message         = [[userInfo objectForKey:@"body"]valueForKey:@"body"];
    NSString *title           = [[[userInfo objectForKey:@"aps"]valueForKey:@"alert"]valueForKey:@"title"];

    if(application.applicationState == UIApplicationStateActive) {
        
        //app is currently active, can update badges count here
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                       message: message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Show" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            UITabBarController *tbc = (UITabBarController*)self.window.rootViewController;
            //tbc.selectedIndex = 1;
            UINavigationController *myNavigationController = tbc.selectedViewController;
            UIStoryboard *mainStoryBoard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            if([notficationType isEqualToString:@"events"])
            {
                EventsList *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"eventList"];
                vc.eventCatId = catId;
                [myNavigationController pushViewController:vc animated:NO];
            }
            else if([notficationType isEqualToString:@"event_details"]) //
            {
                EventDetalPage *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"eventDetails"];
                vc.fromNotificationTap = YES;
                vc.selectedEventId = [NSArray arrayWithObjects:catId, nil];
                [myNavigationController pushViewController:vc animated:NO];
            }
            else if ([notficationType isEqualToString:@"retails"])
            {
                MarketViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"marketView"];
                vc.selectedRetailId = [[NSString alloc]initWithFormat:@"%@",catId];
                vc.type = @"storeOffer";
                [myNavigationController pushViewController:vc animated:NO];
                
            }else if ([notficationType isEqualToString:@"promo"])
            {
                RetailViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"retailView"];
                vc.pushedFrom     = @"categoryItem";
                vc.type           = @"";
                vc.catId = [[NSString alloc]init];
                vc.catId = catId;
                [myNavigationController pushViewController:vc animated:NO];
                
            }else if ([notficationType isEqualToString:@"deals"])
            {
                RetailViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"retailView"];
                vc.pushedFrom =@"todaysDeal";
                [myNavigationController pushViewController:vc animated:NO];
                
            }else if ([notficationType isEqualToString:@"whatsnew"])
            {
                RetailViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"retailView"];
                vc.pushedFrom =@"whatsNew";
                [myNavigationController pushViewController:vc animated:NO];
                
            }else if ([notficationType isEqualToString:@"contest"])
            {
                contestViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"contestView"];
                [myNavigationController pushViewController:vc animated:NO];
            }
            else if ([notficationType isEqualToString:@"product"])
            {
                MarketDetailViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"marketDetailView"];
                vc.selectedProductId  = catId;
                [myNavigationController pushViewController:vc animated:NO];
            }
            else if ([notficationType isEqualToString:@"malls"])
            {
                MallDetailsViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"MallDetailsViewController"];
                vc.mallId  = catId;
                [myNavigationController pushViewController:vc animated:NO];
            }
            else if ([notficationType isEqualToString:@"iaqfeeds"])
            {
                
                if(catId == nil || [catId  isEqual: @"<null>"] || [catId  isEqual: @""]){
                    IAQFeedsViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"IAQFeedsViewController"];
                    [myNavigationController pushViewController:vc animated:NO];
                }else{
                    
                    FeedDetailsViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"FeedDetailsViewController"];
                    vc.feedSlug = catId;
                    [myNavigationController pushViewController:vc animated:NO];
                    
                }
                
            }
            else if([notficationType isEqualToString:@"flyers"]){
                
                if ([Utility reachable]) {
                    [ProgressHUD show];
                    NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,getFlyers];
                    NSDictionary *param = [NSDictionary dictionaryWithObject:catId forKey:@"store_id"];
                    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    [manager GET:urlString parameters:param headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
                     {
                         NSString *text = [responseObject objectForKey:@"text"];
                         NSLog(@"JSON: %@", responseObject);

                         if ([text isEqualToString: @"Success!"])
                         {
                             NSMutableArray *flyersArray = [[responseObject objectForKey:@"flyers"]valueForKey:@"image"];
                             RetailDetailViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"retailDetailView"];
                             view.flipsArray = flyersArray;
                             [myNavigationController pushViewController:view animated:NO];
                         }
                         [ProgressHUD dismiss];

                     } failure:^(NSURLSessionTask *task, NSError *error) {
                         NSLog(@"Error: %@", error);
                         [ProgressHUD dismiss];
                     }];
                }else
                {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                                   message: @"No network connection available!"
                                                                            preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Show" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    [alert addAction:okAction];
                    UIWindow* topWindow;
                    topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    topWindow.rootViewController = [UIViewController new];
                    topWindow.windowLevel = UIWindowLevelAlert + 1;
                    [topWindow makeKeyAndVisible];
                    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                }
            }
//            else if ([notficationType isEqualToString:@"bestbuy"])
//            {
//                BestBuyViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"bestBuyView"];
//                [myNavigationController pushViewController:vc animated:NO];
//                
//            }else if ([notficationType isEqualToString:@"gift"])
//            {
//                GiftBoxViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"giftBoxView"];
//                [myNavigationController pushViewController:vc animated:NO];
//            }

        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        UIWindow* topWindow;
        topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        topWindow.rootViewController = [UIViewController new];
        topWindow.windowLevel = UIWindowLevelAlert + 1;
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        
    }else if(application.applicationState == UIApplicationStateBackground){
        //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
        UITabBarController *tbc = (UITabBarController*)self.window.rootViewController;
        //tbc.selectedIndex = 1;
        UINavigationController *myNavigationController = tbc.selectedViewController;
        UIStoryboard *mainStoryBoard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        if([notficationType isEqualToString:@"events"])
        {
            EventsList *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"eventList"];
            vc.eventCatId = catId;
            [myNavigationController pushViewController:vc animated:NO];
        }
        else if([notficationType isEqualToString:@"event_details"]) //
        {
            EventDetalPage *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"eventDetails"];
            vc.fromNotificationTap = YES;
            vc.selectedEventId = [NSArray arrayWithObjects:catId, nil];
            [myNavigationController pushViewController:vc animated:NO];
        }
        else if ([notficationType isEqualToString:@"retails"])
        {
            MarketViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"marketView"];
            vc.selectedRetailId = [[NSString alloc]initWithFormat:@"%@",catId];
            vc.type = @"storeOffer";
            [myNavigationController pushViewController:vc animated:NO];
            
        }else if ([notficationType isEqualToString:@"promo"])
        {
            RetailViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"retailView"];
            vc.pushedFrom =@"categoryItem";
            vc.type      = @"";
            vc.catId = [[NSString alloc]init];
            vc.catId = catId;
            [myNavigationController pushViewController:vc animated:NO];
            
        }else if ([notficationType isEqualToString:@"deals"])
        {
            RetailViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"retailView"];
            vc.pushedFrom =@"todaysDeal";
            [myNavigationController pushViewController:vc animated:NO];
            
        }else if ([notficationType isEqualToString:@"whatsnew"])
        {
            RetailViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"retailView"];
            vc.pushedFrom =@"whatsNew";
            [myNavigationController pushViewController:vc animated:NO];
            
        }else if ([notficationType isEqualToString:@"contest"])
        {
            contestViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"contestView"];
            [myNavigationController pushViewController:vc animated:NO];
            
        }
        else if ([notficationType isEqualToString:@"product"])
        {
            MarketDetailViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"marketDetailView"];
            vc.selectedProductId  = catId;
            [myNavigationController pushViewController:vc animated:NO];

        }
        else if ([notficationType isEqualToString:@"malls"])
        {
            MallDetailsViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"MallDetailsViewController"];
            vc.mallId  = catId;
            [myNavigationController pushViewController:vc animated:NO];
        }
        else if ([notficationType isEqualToString:@"iaqfeeds"])
        {
            
            if(catId == nil || [catId  isEqual: @"<null>"] || [catId  isEqual: @""]){
                IAQFeedsViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"IAQFeedsViewController"];
                [myNavigationController pushViewController:vc animated:NO];
            }else{
                
                FeedDetailsViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"FeedDetailsViewController"];
                vc.feedSlug = catId;
                [myNavigationController pushViewController:vc animated:NO];
                
            }
            
        }
        else if([notficationType isEqualToString:@"flyers"]){

            if ([Utility reachable]) {
                [ProgressHUD show];
                NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,getFlyers];
                NSDictionary *param = [NSDictionary dictionaryWithObject:catId forKey:@"store_id"];
//                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                [manager GET:urlString parameters:param headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
                 {
                     NSString *text = [responseObject objectForKey:@"text"];
                     NSLog(@"JSON: %@", responseObject);

                     if ([text isEqualToString: @"Success!"])
                     {
                         NSMutableArray *flyersArray = [[responseObject objectForKey:@"flyers"]valueForKey:@"image"];
                         RetailDetailViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"retailDetailView"];
                         view.flipsArray = flyersArray;
                         [myNavigationController pushViewController:view animated:NO];
                     }
                     [ProgressHUD dismiss];

                 } failure:^(NSURLSessionTask *task, NSError *error) {
                     NSLog(@"Error: %@", error);
                     [ProgressHUD dismiss];
                 }];
            }else
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                               message: @"No network connection available!"
                                                                        preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Show" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                }];
                [alert addAction:okAction];
                UIWindow* topWindow;
                topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                topWindow.rootViewController = [UIViewController new];
                topWindow.windowLevel = UIWindowLevelAlert + 1;
                [topWindow makeKeyAndVisible];
                [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            }
        }
//        else if ([notficationType isEqualToString:@"bestbuy"])
//        {
//            BestBuyViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"bestBuyView"];
//            [myNavigationController pushViewController:vc animated:NO];
//            
//        }else if ([notficationType isEqualToString:@"gift"])
//        {
//            GiftBoxViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"giftBoxView"];
//            [myNavigationController pushViewController:vc animated:NO];
//        }

    }else if(application.applicationState == UIApplicationStateInactive){
        //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
        
            UITabBarController *tbc = (UITabBarController*)self.window.rootViewController;
            //tbc.selectedIndex = 1;
            UINavigationController *myNavigationController = tbc.selectedViewController;
            UIStoryboard *mainStoryBoard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            if([notficationType isEqualToString:@"events"])
            {
                EventsList *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"eventList"];
                vc.eventCatId = catId;
                [myNavigationController pushViewController:vc animated:NO];
            }
            else if([notficationType isEqualToString:@"event_details"]) //
            {
                EventDetalPage *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"eventDetails"];
                vc.fromNotificationTap = YES;
                vc.selectedEventId = [NSArray arrayWithObjects:catId, nil];
                [myNavigationController pushViewController:vc animated:NO];
            }
            else if ([notficationType isEqualToString:@"retails"])
            {
                MarketViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"marketView"];
                vc.selectedRetailId = [[NSString alloc]initWithFormat:@"%@",catId];
                vc.type = @"storeOffer";
                [myNavigationController pushViewController:vc animated:NO];
                
            }else if ([notficationType isEqualToString:@"promo"])
            {
                RetailViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"retailView"];
                vc.pushedFrom =@"categoryItem";
                vc.type      = @"";
                vc.catId = [[NSString alloc]init];
                vc.catId = catId;
                [myNavigationController pushViewController:vc animated:NO];
                
            }
            else if ([notficationType isEqualToString:@"promo_item"])
            {
                if ([Utility reachable]) {

                    NSString *urlString;
                    urlString = [NSString stringWithFormat:@"%@api.php?page=getSales_Promotions&id=%@",parentURL,catId];

//                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                    [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
                     {
                         NSString *text = [responseObject objectForKey:@"text"];

                         if ([text isEqualToString: @"Success!"])
                         {
                             retailItems      = [responseObject objectForKey:@"value"];
                             bannerArray      = [retailItems valueForKey:@"banner"];
                             bigImgArray      = [retailItems valueForKey:@"image"];
                             idArray          = [retailItems valueForKey:@"promo_id"];
                             linkArray        = [retailItems valueForKey:@"pagelink"];
                             linkTypeArray    = [retailItems valueForKey:@"link_type"];
                             productIdArray   = [retailItems valueForKey:@"product_id"];

                             [self salesAndpromoRedirect];
                         }


                     } failure:^(NSURLSessionTask *task, NSError *error) {
                         NSLog(@"Error: %@", error);
                     }];
                }else
                {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"IamQatar"
                                                                                   message: @"No network connection available!"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Show" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    [alert addAction:okAction];
                    UIWindow* topWindow;
                    topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    topWindow.rootViewController = [UIViewController new];
                    topWindow.windowLevel = UIWindowLevelAlert + 1;
                    [topWindow makeKeyAndVisible];
                    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                }
            }
            else if ([notficationType isEqualToString:@"deals"])
            {
                RetailViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"retailView"];
                vc.pushedFrom =@"todaysDeal";
                [myNavigationController pushViewController:vc animated:NO];
                
            }else if ([notficationType isEqualToString:@"whatsnew"])
            {
                RetailViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"retailView"];
                vc.pushedFrom =@"whatsNew";
                [myNavigationController pushViewController:vc animated:NO];
                
            }else if ([notficationType isEqualToString:@"contest"])
            {
                contestViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"contestView"];
                [myNavigationController pushViewController:vc animated:NO];
                
            }
            else if ([notficationType isEqualToString:@"product"])
            {
                MarketDetailViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"marketDetailView"];
                vc.selectedProductId  = catId;
                [myNavigationController pushViewController:vc animated:NO];

            }
            else if ([notficationType isEqualToString:@"malls"])
            {
                MallDetailsViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"MallDetailsViewController"];
                vc.mallId  = catId;
                [myNavigationController pushViewController:vc animated:NO];
            }
            else if([notficationType isEqualToString:@"flyers"]){

                if ([Utility reachable]) {
                    [ProgressHUD show];
                    NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,getFlyers];
                    NSDictionary *param = [NSDictionary dictionaryWithObject:catId forKey:@"store_id"];
//                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                    [manager GET:urlString parameters:param headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
                     {
                         NSString *text = [responseObject objectForKey:@"text"];
                         NSLog(@"JSON: %@", responseObject);

                         if ([text isEqualToString: @"Success!"])
                         {
                             NSMutableArray *flyersArray = [[responseObject objectForKey:@"flyers"]valueForKey:@"image"];
                             RetailDetailViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"retailDetailView"];
                             view.flipsArray = flyersArray;
                             [myNavigationController pushViewController:view animated:NO];
                         }
                         [ProgressHUD dismiss];

                     } failure:^(NSURLSessionTask *task, NSError *error) {
                         NSLog(@"Error: %@", error);
                         [ProgressHUD dismiss];
                     }];
                }else
                {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                                   message: @"No network connection available!"
                                                                            preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Show" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    [alert addAction:okAction];
                    UIWindow* topWindow;
                    topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    topWindow.rootViewController = [UIViewController new];
                    topWindow.windowLevel = UIWindowLevelAlert + 1;
                    [topWindow makeKeyAndVisible];
                    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                }
            }
//            else if ([notficationType isEqualToString:@"bestbuy"])
//            {
//                BestBuyViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"bestBuyView"];
//                [myNavigationController pushViewController:vc animated:NO];
//                
//            }else if ([notficationType isEqualToString:@"gift"])
//            {
//                GiftBoxViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"giftBoxView"];
//                [myNavigationController pushViewController:vc animated:NO];
//            }
      }
}


-(void)salesAndpromoRedirect{

    if ([[linkTypeArray objectAtIndex:0]isEqual:@"product"])
    {
        if ([Utility reachable]) {
            NSString *pid = [productIdArray objectAtIndex:0];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,getProductDetails];
            NSDictionary *param = [[NSDictionary alloc]initWithObjectsAndKeys:pid,@"product_id", nil];

//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [manager GET:urlString parameters:param headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 NSString *text = [responseObject objectForKey:@"text"];
                 if ([text isEqualToString: @"Success!"])
                 {
                     UITabBarController *tbc = (UITabBarController*)self.window.rootViewController;
                     UINavigationController *myNavigationController = tbc.selectedViewController;
                     UIStoryboard *mainStoryBoard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

                     MarketDetailViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"marketDetailView"];
                     view.selectedProductId = pid;
                     [myNavigationController pushViewController:view animated:YES];
                 }

             } failure:^(NSURLSessionTask *task, NSError *error) {
                 NSLog(@"Error: %@", error);
             }];
        }else
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"IamQatar"
                                                                           message: @"No network connection available!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Show" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            }];
            [alert addAction:okAction];
            UIWindow* topWindow;
            topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            topWindow.rootViewController = [UIViewController new];
            topWindow.windowLevel = UIWindowLevelAlert + 1;
            [topWindow makeKeyAndVisible];
            [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }
    else if (![[linkArray objectAtIndex:0] isEqualToString:@""])
    {
        NSURL *url ;

        NSString *myURLString = [linkArray objectAtIndex:0];

        if ([myURLString.lowercaseString hasPrefix:@"http://"]||[myURLString.lowercaseString hasPrefix:@"https://"]) {
            url = [NSURL URLWithString:myURLString];
        } else {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",myURLString]];
        }

//        [[UIApplication sharedApplication] openURL:url];
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                 NSLog(@"Opened url");
            }
        }];
    }else{
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,[bigImgArray objectAtIndex:0]]];
        UIImageView *iv= [[UIImageView alloc]init];
        iv.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        [EXPhotoViewer showImageFrom:iv];
    }
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //Clear badge count
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [FBSDKAppEvents activateApp];

    //Clear badge count
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//MARK:- FB & G+ OPEN URL DELEGATES

//if let openURLContext = URLContexts.first {
//  ApplicationDelegate.shared.application(UIApplication.shared, open:
//  openURLContext.url, sourceApplication:
//  openURLContext.options.sourceApplication, annotation:
//  openURLContext.options.annotation)
//}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    BOOL handled;
    NSString *stringURL = [ url absoluteString];
    
    if([stringURL containsString:@"fb"]) {
        handled = [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }else if([stringURL containsString:@"google"]) {
//         handled = [[GIDSignIn sharedInstance] handleURL:url
//                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        handled = [[GIDSignIn sharedInstance] handleURL:url];
        
    }else{
         handled = [[Twitter sharedInstance] application:app openURL:url options:options];
    }

    return handled;

}

//handled = [[GIDSignIn sharedInstance] handleURL:url];
//- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
//
//    NSMutableDictionary *md = [NSMutableDictionary dictionary];
//    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
//
//    for(NSString *s in queryComponents) {
//        NSArray *pair = [s componentsSeparatedByString:@"="];
//        if([pair count] != 2) continue;
//
//        NSString *key   = pair[0];
//        NSString *value = pair[1];
//
//        md[key] = value;
//    }
//
//    return md;
//}


//
//- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
//
//}

- (void)registerForRemoteNotifications {
//    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
             if(!error){
                 [[UIApplication sharedApplication] registerForRemoteNotifications];
             }
         }];
    
    
}

@end
