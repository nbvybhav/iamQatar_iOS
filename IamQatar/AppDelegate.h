//
//  AppDelegate.h
//  IamQatar
//
//  Created by alisons on 8/17/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Google/SignIn.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,UITabBarDelegate,GIDSignInDelegate,UNUserNotificationCenterDelegate>
@property (readonly, nonatomic) GIDGoogleUser *currentUser;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) NSMutableDictionary *userProfileDetails;

-(void)versionCheck;
@end

