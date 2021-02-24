//
//  SignupViewController.m
//  IamQatar
//
//  Created by Alisons on 5/11/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import "SignupViewController.h"
#import "Utility.h"
#import "constants.pch"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SignupViewController ()
{
    NSString *UserName;
    NSString *profPic;
    int deviceWidth;
    int deviceheght;
    BOOL termsAccepted;
}
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];

     deviceWidth = [[UIScreen mainScreen] bounds].size.width;
     deviceheght = [[UIScreen mainScreen] bounds].size.height;

    _txtPasswordSignup.autocorrectionType = NO;
    _txtPasswordSignup.delegate = self;
     termsAccepted = NO;

    [_btnAccept setBackgroundImage:[UIImage imageNamed:@"checkBox_Unselected"] forState:UIControlStateNormal];
    [_btnAccept setBackgroundImage:[UIImage imageNamed:@"checkBox_selected"]   forState : UIControlStateSelected];

    ///If social media signup
    if ([_detailsFetched count]>0) {
        NSString *username = [_detailsFetched valueForKey:@"username"];
        if ([username length] > 0){
            NSArray *nameArray = [username componentsSeparatedByString:@" "];
            _txtFname.text = [nameArray objectAtIndex:0];
            _txtLname.text = [nameArray objectAtIndex:1];
        }
        _txtEmailSignup.text = [NSString stringWithFormat:@"%@",[_detailsFetched valueForKey:@"email"]];
        _txtConfirmMail.enabled = NO;
        _txtPasswordSignup.enabled = NO;
    }
}



//MARKER:- METHODS
-(IBAction)signUpValidate:(id)sender{

    if([_txtFname.text isEqualToString:@""])
    {
        [AlertController alertWithMessage:@"Enter first name!" presentingViewController:self];
    }
    else if ([_txtLname.text isEqualToString:@""]){
        [AlertController alertWithMessage:@"Enter last name!" presentingViewController:self];
    }
    else if ([_txtEmailSignup.text isEqualToString:@""]){
        [AlertController alertWithMessage:@"Enter email id!" presentingViewController:self];
    }
    else if ([_txtConfirmMail.text isEqualToString:@""] && !([_detailsFetched count] > 0)){
        [AlertController alertWithMessage:@"Enter confirm mail id!" presentingViewController:self];
    }
    else if ([_txtPasswordSignup.text isEqualToString:@""] && !([_detailsFetched count] > 0)){
        [AlertController alertWithMessage:@"Enter password!" presentingViewController:self];
    }
    else if(![_txtEmailSignup.text isEqualToString:_txtConfirmMail.text] && !([_detailsFetched count] > 0)){
        [AlertController alertWithMessage:@"Email id mismatch!" presentingViewController:self];
    }else if(!termsAccepted){
        [AlertController alertWithMessage:@"Accept terms of service!" presentingViewController:self];
    }
    else{
        [self createAccountAction];
    }
}

- (void)createAccountAction
{
    if([Utility reachable])
    {
        [ProgressHUD show];

        NSURL *url = [[NSURL alloc]init];
        NSString *userId = [Utility getfromplist:@"skippedUserId" plist:@"iq"];
        NSDictionary *parameters;


        if([[_detailsFetched valueForKey:@"unique_id"]length]>0){  //If not manual signup (fb or G+)
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,loginUrl]];
            if(userId != nil && userId != (id)[NSNull null]) //If guest_id exist - for maintaining guest user cart
            {
                parameters = [NSDictionary dictionaryWithObjectsAndKeys:_txtEmailSignup.text,@"email",_txtPasswordSignup.text,@"password",_txtFname.text,@"first_name",_txtLname.text,@"last_name",@"1",@"agreed_stat",[_detailsFetched valueForKey:@"login_type"],@"login_type",[_detailsFetched valueForKey:@"unique_id"],@"unique_id",userId,@"skip_user_id", nil];
            }else{
                parameters = [NSDictionary dictionaryWithObjectsAndKeys:_txtEmailSignup.text,@"email",_txtPasswordSignup.text,@"password",_txtFname.text,@"first_name",_txtLname.text,@"last_name",@"1",@"agreed_stat",[_detailsFetched valueForKey:@"login_type"],@"login_type",[_detailsFetched valueForKey:@"unique_id"],@"unique_id",nil];
            }

        }else{//Manual signup
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,signupUrl]];
            if(userId != nil || userId != (id)[NSNull null]) //If guest_id exist - for maintaining guest user cart
            {
                parameters = [NSDictionary dictionaryWithObjectsAndKeys:_txtEmailSignup.text,@"email",_txtPasswordSignup.text,@"password",_txtFname.text,@"first_name",_txtLname.text,@"last_name",@"1",@"agreed_stat",userId,@"skip_user_id", nil];
            }else{
                parameters = [NSDictionary dictionaryWithObjectsAndKeys:_txtEmailSignup.text,@"email",_txtPasswordSignup.text,@"password",_txtFname.text,@"first_name",_txtLname.text,@"last_name",@"1",@"agreed_stat",nil];
            }
        }

        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:[NSString stringWithFormat:@"%@",url] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             NSString *code = [responseObject objectForKey:@"code"];
             NSString *message = [responseObject objectForKey:@"text"];

             if ([code isEqualToString: @"200"])
             {
                 self->_txtFname.text = @"";
                 self->_txtLname.text = @"";
                 self->_txtConfirmMail.text = @"";
                 self->_txtEmailSignup.text = @"";
                 self->_txtPasswordSignup.text = @"";

                 [Utility addtoplist:[responseObject objectForKey:@"value"]key:@"userProfile" plist:@"iq"];
                 NSString *badge = [[responseObject objectForKey:@"count"] valueForKey:@"count"];
                 [Utility addtoplist:badge key:@"cartCount" plist:@"iq"];
                 [Utility addtoplist:@"YES" key:@"login" plist:@"iq"];
                 [Utility addtoplist:@"NO"key:@"skippedUser" plist:@"iq"];

                 // Sign in & navigating to home screen
                 AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                 self.tabBarController.selectedIndex = 1;
                 appDelegate.userProfileDetails = [responseObject objectForKey:@"value"];
                 [appDelegate.window setRootViewController:appDelegate.tabBarController];

                 //[AlertController alertWithMessage:@"Account created successfully! Please login." presentingViewController:self];
             }
             else
             {
                 [AlertController alertWithMessage:message presentingViewController:self];
             }
             
             [ProgressHUD dismiss];
         }
         failure:^(NSURLSessionTask *task, NSError *error)
         {
             NSLog(@"Error: %@", error);
             [ProgressHUD dismiss];
         }];
    }else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}

- (IBAction)facebookBtnAction:(id)sender
{
        if ([Utility reachable])
        {
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logOut];   //ESSENTIAL LINE OF CODE
            [login logInWithPermissions:@[@"email"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
                
                if (error == nil && result.isCancelled == false) { // (NB for multiple permissions, check every one)
                    if ([result.grantedPermissions containsObject:@"email"])
                    { NSLog(@"%@",result.token); }
                    [self fetchUserInfo];
                }
                
            }];
        }
        else
        {
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

//MARK: SOCIAL LOGIN COMMON METHOD
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
        NSString *userId        = [Utility getfromplist:@"skippedUserId" plist:@"iq"];;

        
        devicetoken=[devicetoken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        devicetoken=[devicetoken stringByReplacingOccurrencesOfString:@">" withString:@""];
        devicetoken=[devicetoken stringByReplacingOccurrencesOfString:@" " withString:@""];

        NSMutableDictionary *parameters;
        if(userId != nil && userId != (id)[NSNull null]){  //If guest_id exist - for maintaining guest user cart
            parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:email,@"email",UserName,@"username",@"",@"password",LoginType,@"login_type",KeyForSocial,@"unique_id",version,@"appversion",devicetoken,@"devicetoken",model,@"devicemodel",deviceos,@"deviceos",enviournment,@"environment",userId,@"skip_user_id", nil];
        }else{
            parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:email,@"email",UserName,@"username",@"",@"password",LoginType,@"login_type",KeyForSocial,@"unique_id",version,@"appversion",devicetoken,@"devicetoken",model,@"devicemodel",deviceos,@"deviceos",enviournment,@"environment", nil];
        }

        
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
             else if ([text isEqualToString: @"511"])   // Newly signing fb user will be redirected to signup page
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


//MARK:- G+ DELEGATE METHODS
- (IBAction)googlePlusButtonTouchUpInside:(id)sender {

        // TODO(developer) Configure the sign-in button look/feel
        GIDSignIn *signin = [GIDSignIn sharedInstance];
        signin.shouldFetchBasicProfile = true;
        signin.delegate = self;
//        signin.uiDelegate = self;
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

//MARK:- TEXTFIELD DELEGATE METHODS
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if(textField == _txtPasswordSignup || textField == _txtConfirmMail){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }

    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    if(textField == _txtPasswordSignup || textField == _txtConfirmMail){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    }

    [self.view endEditing:YES];
    return YES;
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,-60,deviceWidth,deviceheght)];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,deviceWidth,deviceheght)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.view setFrame:CGRectMake(0,0,deviceWidth,deviceheght)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)acceptTerms:(id)sender {
    if ([_btnAccept isSelected]) {
        [_btnAccept setSelected: NO];
        termsAccepted = NO;
    } else {
        [_btnAccept setSelected: YES];
         termsAccepted = YES;
    }
}


- (IBAction)goToTermsOfService:(id)sender {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://iamqatar.qa/pages/terms-and-conditions/"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
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
