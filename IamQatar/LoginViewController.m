//
//  LoginViewController.m
//  IamQatar
//
//  Created by alisons on 8/22/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "categoryViewController.h"
#import "constants.pch"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Accounts/Accounts.h>
//#import <Google/SignIn.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <TwitterKit/TwitterKit.h>
#import "instagramViewController.h"
#import "MainCategoryViewController.h"
#import <CoreText/CoreText.h>
#import "SignupViewController.h"
#import "ForgotViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>

typedef void (^accountChooserBlock_t)(ACAccount *account, NSString *errorMessage); // don't bother with NSError for that

@interface LoginViewController ()<ASAuthorizationControllerDelegate>
{
    BOOL imagePicked;
    NSString *UserName;
    NSString *profPic;
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
   
//    TODO(developer) Configure the sign-in button look/feel
//    [GIDSignIn sharedInstance].uiDelegate = self;
    
//    _txtEmailSignIn.text    = @"dk167618@gmail.com";
//    _txtPasswordSignIn.text = @"B4AN0X";
    
//    _txtEmailSignIn.text    = @"anjanagopi94@gmail.com";
//    _txtPasswordSignIn.text = @"12345678";

    [GIDSignIn sharedInstance].presentingViewController = self;
    

    imagePicked = NO;

    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.forgotPasswordView addGestureRecognizer:singleFingerTap];

    // Do any additional setup after loading the view.
    if (@available(iOS 13.0, *)) {
           [self observeAppleSignInState];
       }

}

-(void)viewWillAppear:(BOOL)animated{
    
    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Login-SignupScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    _forgotPasswordView.hidden = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    _forgotPasswordView.hidden = YES;
}



//MARK:- METHODS
- (IBAction)loginAction:(id)sender
{
  if ([Utility reachable])
  {
   [ProgressHUD show];
      
    //appversion, devicetoken, devicemodel, deviceos (IOS or ANDROID), environment (development OR production)
    NSString *version       = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *model         = [NSString stringWithFormat:@"iphone"];
    NSString *deviceos      = [NSString stringWithFormat:@"IOS"];
    NSString *devicetoken   = [NSString stringWithFormat:@"%@",[Utility getfromplist:@"deviceToken" plist:@"iq"]];
    NSString *userId        = [Utility getfromplist:@"skippedUserId" plist:@"iq"];

      devicetoken=[devicetoken stringByReplacingOccurrencesOfString:@"<" withString:@""];
      devicetoken=[devicetoken stringByReplacingOccurrencesOfString:@">" withString:@""];
      devicetoken=[devicetoken stringByReplacingOccurrencesOfString:@" " withString:@""];

      NSDictionary *parameters;
      if(userId != nil && userId != (id)[NSNull null]){  // If guest user_id persist
          parameters = [NSDictionary dictionaryWithObjectsAndKeys:_txtEmailSignIn.text,@"email",_txtPasswordSignIn.text,@"password",version,@"appversion",devicetoken,@"devicetoken",model,@"devicemodel",deviceos,@"deviceos",enviournment,@"environment",userId,@"skip_user_id", nil];
      }else{
          parameters = [NSDictionary dictionaryWithObjectsAndKeys:_txtEmailSignIn.text,@"email",_txtPasswordSignIn.text,@"password",version,@"appversion",devicetoken,@"devicetoken",model,@"devicemodel",deviceos,@"deviceos",enviournment,@"environment", nil];
      }
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
    [manager POST:[NSString stringWithFormat:@"%@%@",parentURL,loginUrl] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSString *text = [responseObject objectForKey:@"text"];
         
         if ([text isEqualToString: @"User Exists!"])
         {
             jumpToHome = [NSString stringWithFormat:@"YES"];

             AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
             self.tabBarController.selectedIndex = 1;
             appDelegate.userProfileDetails = [responseObject objectForKey:@"value"];
            [appDelegate.window setRootViewController:appDelegate.tabBarController];
             
             [Utility addtoplist:[responseObject objectForKey:@"value"]key:@"userProfile" plist:@"iq"];
             NSString *badge = [[responseObject objectForKey:@"count"] valueForKey:@"count"];
             [Utility addtoplist:badge key:@"cartCount" plist:@"iq"];
             [Utility addtoplist:@"YES" key:@"login" plist:@"iq"];
         }else
         {
             [AlertController alertWithMessage:text presentingViewController:self];
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


- (IBAction)resetPasswordAction:(id)sender
{
  if([Utility reachable])
  {
    [ProgressHUD show];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                _txtEmailReset.text,@"email",nil];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
      AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",parentURL,passwordResetUrl] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
         NSString *text = [responseObject objectForKey:@"text"];
         
         if ([text isEqualToString: @"Check your mail to get password!"])
         {
             self->_forgotPasswordView.hidden = YES;
             [AlertController alertWithMessage:text presentingViewController:self];
         }
         else
         {
             [AlertController alertWithMessage:text presentingViewController:self];
         }
         [ProgressHUD dismiss];
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


- (IBAction)facebookBtnAction:(id)sender
{
  if ([Utility reachable])
  {
      FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
      [login logOut];
      [login logInWithPermissions:@[@"email"]
               fromViewController:self
                          handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
          
          if (error == nil && result.isCancelled == false) {
              if ([result.grantedPermissions containsObject:@"email"])
              [self fetchUserInfo];
          }
          
      }];
       
  }
  else
  {
    [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
  }
}

- (IBAction)onTwitterBtnClicked:(id)sender {
    
 if ([Utility reachable])
  {
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error) {
         
         NSLog(@"session>%@",session);
         NSLog(@"username>%@",[session userName]);
         
         if (session) {
             self->UserName = [session userName];
             
             [self SocialLoginRequest:[session userName] :@"twitter" :session.userID];
             [[[Twitter sharedInstance] sessionStore] logOutUserID:session.userID];
         } else {
             NSLog(@"error: %@", [error localizedDescription]);
         }
     }];
  }else
  {
      [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
  }
}

- (IBAction)onInstagramTap:(id)sender {
    
  if ([Utility reachable])
  {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    instagramViewController *add =
    [storyboard instantiateViewControllerWithIdentifier:@"insta"];
    
    [self presentViewController:add
                       animated:YES
                     completion:nil];
  }else
  {
    [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
  }
}

-(void)fetchUserInfo
{
    [ProgressHUD show:@"Authenticating..."];
    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSLog(@"Token is available");
        
       [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, picture.type(large), email, birthday ,location ,friends ,hometown"}]
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
                                              message:@"Login failed!"
                                              preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction
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


- (IBAction)tapOnBackGround:(id)sender {
    _forgotPasswordView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)navigateToSignup:(id)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    SignupViewController *add =
    [storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self presentViewController:add
                       animated:NO
                     completion:nil];
}

- (IBAction)navigateForgotPasword:(id)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    ForgotViewController *add =
    [storyboard instantiateViewControllerWithIdentifier:@"ForgotViewController"];
    [self presentViewController:add
                       animated:NO
                     completion:nil];
}

- (IBAction)skipAction:(id)sender {
    if ([Utility reachable])
    {
        [ProgressHUD show];

//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
        [manager POST:[NSString stringWithFormat:@"%@%@",parentURL,skipUserApi] parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             NSString *text = [responseObject objectForKey:@"code"];

             if ([text isEqualToString: @"200"])
             {
                 NSString *skippedUserId = [[responseObject objectForKey:@"value"]valueForKey:@"user_id"];

                 [Utility addtoplist:@"YES"key:@"skippedUser" plist:@"iq"];
                 [Utility addtoplist:skippedUserId key:@"skippedUserId" plist:@"iq"];
                 //cart count to 'Zero'
                 [Utility addtoplist:@"0" key:@"cartCount" plist:@"iq"];

                 AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                 self.tabBarController.selectedIndex = 1;
                 appDelegate.userProfileDetails = [responseObject objectForKey:@"value"];
                 [appDelegate.window setRootViewController:appDelegate.tabBarController];
             }else
             {
                 [AlertController alertWithMessage:text presentingViewController:self];
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

//MARK:- SOCIAL LOGIN COMMON CALL
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

        NSString *userId        = [Utility getfromplist:@"skippedUserId" plist:@"iq"];

       if (email == nil){
           [ProgressHUD dismiss];
           UIAlertController *alertController = [UIAlertController
                                                 alertControllerWithTitle:@"IamQatar"
                                                 message:@"Could not find any associated email address with this social account! Please use manual signup."
                                                 preferredStyle:UIAlertControllerStyleActionSheet];
           UIAlertAction *OkAction = [UIAlertAction
                                          actionWithTitle:@"OK"
                                          style:UIAlertActionStyleDestructive
                                          handler:^(UIAlertAction * action)
                                          {
                                              //[alertController dismissViewControllerAnimated:YES completion:nil];
                                              UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                              SignupViewController *signup =
                                              [storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
                                              signup.detailsFetched = [[NSMutableDictionary alloc]init];
                                              [self presentViewController:signup
                                                                 animated:NO
                                                               completion:nil];
                                          }];
           [alertController addAction:OkAction];
           [self presentViewController:alertController animated:YES completion:nil];

       }else{

           NSMutableDictionary *parameters;

           NSString *username = @"";
           if (UserName != nil) {
               username = UserName;
           }
           
           NSString *password = @"";
           if (_txtPasswordSignIn.text != nil) {
               password = _txtPasswordSignIn.text;
           }
           
           if(userId != nil || userId != (id)[NSNull null]){
                parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:email,@"email",username,@"username",password,@"password",LoginType,@"login_type",KeyForSocial,@"unique_id",version,@"appversion",devicetoken,@"devicetoken",model,@"devicemodel",deviceos,@"deviceos",enviournment,@"environment",@"0",@"agreed_stat",userId,@"skip_user_id", nil];
           }else{
               parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:email,@"email",username ,@"username",password,@"password",LoginType,@"login_type",KeyForSocial,@"unique_id",version,@"appversion",devicetoken,@"devicetoken",model,@"devicemodel",deviceos,@"deviceos",enviournment,@"environment",@"0",@"agreed_stat", nil];
           }
           
           NSLog(@"%@", parameters);


//           AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
           AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
           [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];

           NSLog(@"%@", [NSString stringWithFormat:@"%@%@",parentURL,loginUrl]);
           [manager POST:[NSString stringWithFormat:@"%@%@",parentURL,loginUrl] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
            {
               
               NSLog(@"%@", task);
               NSLog(@"%@", responseObject);
                NSLog(@"JSON: %@", responseObject);
                NSString *text = [responseObject objectForKey:@"code"];
                NSString *message = [responseObject objectForKey:@"text"];

                if ([text isEqualToString: @"200"])    // existing user
                {
                    NSString *badge = [[responseObject objectForKey:@"count"] valueForKey:@"count"];
                    [Utility addtoplist:badge key:@"cartCount" plist:@"iq"];
                    [Utility addtoplist:@"YES" key:@"login" plist:@"iq"];
                    [Utility addtoplist:[responseObject objectForKey:@"value"]key:@"userProfile" plist:@"iq"];
                    [Utility addtoplist:@"NO"key:@"skippedUser" plist:@"iq"];

                    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    self.tabBarController.selectedIndex = 1;
                    appDelegate.userProfileDetails = [responseObject objectForKey:@"value"];
                    [appDelegate.window setRootViewController:appDelegate.tabBarController];
                }
                else if ([text isEqualToString: @"511"])   // Newly signing fb user
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
       }
   }else
   {
       [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
   }
}


//MARK:- G+ DELEGATE METHOD
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

//MARK:- Apple Sign in


- (void)observeAppleSignInState {
if (@available(iOS 13.0, *)) {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
}
}

- (void)handleSignInWithAppleStateChanged:(id)noti {
NSLog(@"%s", __FUNCTION__);
NSLog(@"%@", noti);
}
- (IBAction)appleSigninBtnAction:(id)sender {
    
    if ([Utility reachable])
    {
        if (@available(iOS 13.0, *)) {
    
            // A mechanism for generating requests to authenticate users based on their Apple ID.
            ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];

            // Creates a new Apple ID authorization request.
            ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
            // The contact information to be requested from the user during authentication.
            request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];

            // A controller that manages authorization requests created by a provider.
            ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];

            // A delegate that the authorization controller informs about the success or failure of an authorization attempt.
            controller.delegate = self;

            // A delegate that provides a display context in which the system can present an authorization interface to the user.
            controller.presentationContextProvider = self;

            // starts the authorization flows named during controller initialization.
            [controller performRequests];
        }else {
            [AlertController alertWithMessage:@"Apple sign is not available in this iOS Version, Please update your iOS Version. Apple sign in requires version iOS 13 or later" presentingViewController:self];
        }
    }else {
      [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
    
    

}

NSString* const setCurrentIdentifier = @"setCurrentIdentifier";
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {

        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user = appleIDCredential.user;
        NSString *familyName = appleIDCredential.fullName.familyName;
        NSString *givenName = appleIDCredential.fullName.givenName;
        NSString *email = appleIDCredential.email;
        [self SocialLoginRequest:email :@"apple" :user];

    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *passwordCredential = authorization.credential;
        NSString *user = passwordCredential.user;
        NSString *password = passwordCredential.password;

    } else {
        
    }
}


- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"ASAuthorizationErrorCanceled";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"ASAuthorizationErrorFailed";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"ASAuthorizationErrorInvalidResponse";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"ASAuthorizationErrorNotHandled";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"ASAuthorizationErrorUnknown";
            break;
    }

    NSMutableString *mStr = [NSMutableString string];
    [mStr appendString:errorMsg];
    [mStr appendString:@"\n"];

    if (errorMsg) {
        return;
    }

    if (error.localizedDescription) {
        NSMutableString *mStr = [NSMutableString string];
        [mStr appendString:error.localizedDescription];
        [mStr appendString:@"\n"];
    }
    NSLog(@"controller requests：%@", controller.authorizationRequests);
     
}

//! Tells the delegate from which window it should present content to the user.
 - (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    NSLog(@"window：%s", __FUNCTION__);
    return self.view.window;
}

- (void)dealloc {
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}


    
    
    

@end
