//
//  ForgotViewController.m
//  IamQatar
//
//  Created by alisons on 5/22/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import "ForgotViewController.h"
#import "constants.pch"
//#import <Google/SignIn.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SignupViewController.h"
#import "IamQatar-Swift.h"

@interface ForgotViewController ()
{
    NSString *UserName;
    NSString *profPic;
}
@end

@implementation ForgotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    
    [GIDSignIn sharedInstance].presentingViewController = self;
    //_txtEmail.text = @"anuroop@alisonsgroup.com";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK:- API CALL
- (IBAction)resetPasswordAction:(id)sender
{
    if([Utility reachable])
    {
        [ProgressHUD show];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    _txtEmail.text,@"email",nil];
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@",parentURL,passwordResetUrl] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             
             NSString *text = [responseObject objectForKey:@"text"];
             
//             if ([text isEqualToString: @"Check your mail to reset password!"])
//             {
//                 _txtEmail.text = @"";
//                 [AlertController alertWithMessage:text presentingViewController:self];
//             }
//             else
//             {
//                 _txtEmail.text = @"";
//                 [AlertController alertWithMessage:text presentingViewController:self];
//             }
             [ProgressHUD dismiss];
            
            //go to reset password vc
            
            ResetPasswordViewController *vc = [[ResetPasswordViewController alloc]init];
             vc.email = self->_txtEmail.text;
             self->_txtEmail.text = @"";
            //[self.navigationController pushViewController:vc animated:YES];
            [self presentViewController:vc animated:true completion:nil];
            
         }
         
              failure:^(NSURLSessionTask *task, NSError *error)
         {
             [ProgressHUD dismiss];
             NSLog(@"Error: %@", error);
             [AlertController alertWithMessage:@"Request failed!" presentingViewController:self];
         }];
    }
    else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}


- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

//MARK:- SOCIAL LOGIN
- (IBAction)facebookBtnAction:(id)sender
{
    if ([Utility reachable])
    {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];   //ESSENTIAL LINE OF CODE
        [login logInWithPermissions:@[@"email"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
            
            if (error == nil && result.isCancelled == false) {
                if ([result.grantedPermissions containsObject:@"email"])
                { NSLog(@"%@",result.token); }
                [self fetchUserInfo];
            }
            
        }];
    }else {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}

-(void)fetchUserInfo
{
    [ProgressHUD show:@"Authenticating..."];
    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSLog(@"Token is available");
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, picture.type(large), email, birthday ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Fetched User Information:%@", result);
                 
                 NSString *uid        = [result valueForKey:@"id"];
                 NSString *mail       = [result valueForKey:@"email"];
                 self->UserName             = [result valueForKey:@"name"];
                 self->profPic              = [[[result valueForKey:@"picture"]valueForKey:@"data"]valueForKey:@"url"];
                 
                 [self SocialLoginRequest:mail :@"fb" :uid];
             }
             else {
                 NSLog(@"Error %@",error);
             }
         }];
        [ProgressHUD dismiss];
        
    } else {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"IamQatar"
                                              message:@"Login filed!"
                                              preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction =[UIAlertAction
                                      actionWithTitle:@"Cancel"
                                      style:UIAlertActionStyleDestructive
                                      handler:^(UIAlertAction * action)
                                      {
                                          [alertController dismissViewControllerAnimated:YES completion:nil];
                                      }];
        NSLog(@"User is not Logged in");
        [ProgressHUD dismiss];
    }
}

//MARK:- SOCIAL LOGIN COMMON METHOD CALL
- (void)SocialLoginRequest:(NSString*)email :(NSString*)LoginType : (NSString*)KeyForSocial
{
    if ([Utility reachable])
    {
        [ProgressHUD show];
        
        //email, password,image, username,unique_id (for social)
        NSString *version       = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *model         = [NSString stringWithFormat:@"iphone"];
        NSString *deviceos      = [NSString stringWithFormat:@"IOS"];
        NSString *devicetoken   = [NSString stringWithFormat:@"%@",[Utility getfromplist:@"deviceToken" plist:@"iq"]];
        
        
        devicetoken=[devicetoken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        devicetoken=[devicetoken stringByReplacingOccurrencesOfString:@">" withString:@""];
        devicetoken=[devicetoken stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:email,@"email",UserName,@"username",@"",@"password",LoginType,@"login_type",KeyForSocial,@"unique_id",version,@"appversion",devicetoken,@"devicetoken",model,@"devicemodel",deviceos,@"deviceos",enviournment,@"environment",@"0",@"agreed_stat", nil];
        
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@",parentURL,loginUrl] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             NSString *text = [responseObject objectForKey:@"code"];
             NSString *message = [responseObject objectForKey:@"text"];
             
             if ([text isEqualToString: @"200"])
             {
                 [Utility addtoplist:@"YES" key:@"login" plist:@"iq"];
                 [Utility addtoplist:[responseObject objectForKey:@"value"]key:@"userProfile" plist:@"iq"];

                 AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                 self.tabBarController.selectedIndex = 1;
                 appDelegate.userProfileDetails = [responseObject objectForKey:@"value"];
                 [appDelegate.window setRootViewController:appDelegate.tabBarController];
             }
              else if ([text isEqualToString: @"511"])
             {
                 UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 SignupViewController *signup =
                 [storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
                 signup.detailsFetched = parameters;
                 [self presentViewController:signup
                                    animated:NO
                                  completion:nil];
             }else{
                 [AlertController alertWithMessage:message presentingViewController:self];
                 NSLog(@"User Doesnot Exist");
             }
             
             [ProgressHUD dismiss];
         }
              failure:^(NSURLSessionTask *task, NSError *error)
         {
             NSLog(@"Error: %@", error);
             [ProgressHUD dismiss];
             [AlertController alertWithMessage:@"Request failed!" presentingViewController:self];
         }];
    }else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}


//MARK:- G+ DELAGTE METHODS
- (IBAction)googlePlusButtonTouchUpInside:(id)sender {
    // TODO(developer) Configure the sign-in button look/feel
    GIDSignIn *signin = [GIDSignIn sharedInstance];
    signin.shouldFetchBasicProfile = true;
    signin.delegate = self;
//    signin.uiDelegate = self;
    signin.clientID = @"445421325997-mdac828gsrfglm4b6k9g63667ll2042h.apps.googleusercontent.com";
    [[GIDSignIn sharedInstance] signIn];
}
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    NSLog(@"%@",error.description);
}
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
    withError:(NSError *)error {
    //user signed in
    //get user data in "user" (GIDGoogleUser object)
    NSLog(@"GoogleUser>%@",user);
    
    if (error == nil) {
        NSString *userId = user.userID;
        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        UserName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        
        [self SocialLoginRequest:email :@"gplus" :idToken];
        
    } else {
        NSLog(@"%@", error.localizedDescription);
    }
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
