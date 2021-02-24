//
//  ForgotViewController.h
//  IamQatar
//
//  Created by alisons on 5/22/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Google/SignIn.h>
#import <GoogleSignIn/GoogleSignIn.h>
//@interface ForgotViewController : UIViewController <UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate>
@interface ForgotViewController : UIViewController <UITextFieldDelegate,GIDSignInDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (readonly, nonatomic) GIDGoogleUser *currentUser;

@end
