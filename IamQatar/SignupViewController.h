//
//  SignupViewController.h
//  IamQatar
//
//  Created by Alisons on 5/11/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Google/SignIn.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "AppDelegate.h"
#import "constants.pch"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Accounts/Accounts.h>

//@interface SignupViewController : UIViewController  <UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate>
@interface SignupViewController : UIViewController  <UITextFieldDelegate,GIDSignInDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtFname;
@property (strong, nonatomic) IBOutlet UITextField *txtLname;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailSignup;
@property (strong, nonatomic) IBOutlet UITextField *txtPasswordSignup;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmMail;
@property (weak, nonatomic) IBOutlet UILabel *lblTermsCondition;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (strong, nonatomic) NSMutableDictionary *detailsFetched;
@property (readonly, nonatomic) GIDGoogleUser *currentUser;

@end
