//
//  LoginViewController.h
//  IamQatar
//
//  Created by alisons on 8/22/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Google/SignIn.h>
#import <GoogleSignIn/GoogleSignIn.h>
//@interface LoginViewController : UIViewController <UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate>
@interface LoginViewController : UIViewController <UITextFieldDelegate,GIDSignInDelegate>//,GIDSignInDelegate>

@property (readonly, nonatomic) GIDGoogleUser *currentUser;
@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;
@property (strong, nonatomic) IBOutlet UIView   *signInView;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailSignIn;
@property (strong, nonatomic) IBOutlet UITextField *txtPasswordSignIn;
@property (weak, nonatomic) IBOutlet UIButton *ivProfilBtnOutlet;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailReset;
@property (strong, nonatomic) IBOutlet UIView *forgotPasswordView;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

- (IBAction)onProfileSelectionBtnCliCked:(id)sender;
- (IBAction)facebookBtnAction:(id)sender;
- (IBAction)onTwitterBtnClicked:(id)sender;

@end
