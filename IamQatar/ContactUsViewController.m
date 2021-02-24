//
//  ContactUsViewController.m
//  IamQatar
//
//  Created by User on 12/07/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import "ContactUsViewController.h"
#import "IamQatar-Swift.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;
}

//MARK:- VIEW DID LOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    
    self.title = @"CONTACT US";

    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tap:)];
    [_mainScrollView addGestureRecognizer: tapRec];

    deviceHieght = [[UIScreen mainScreen] bounds].size.height;
    
    
    [self.mainScrollView setContentSize:CGSizeMake(0,_btnSend.frame.origin.y + _btnSend.frame.size.height + 20)];

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

    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];

    menuHideTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    [self.view addGestureRecognizer:menuHideTap];
    menuHideTap.enabled = NO;

    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];

    //Banner shadow & corner radius
    //_bannerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //_bannerView.layer.shadowRadius = 4.0f;
    //_bannerView.layer.shadowOffset = CGSizeZero;
    //_bannerView.layer.shadowOpacity = 0.8f;
    //_bannerView.clipsToBounds = false;
//
    //_bannerImage.clipsToBounds = true;
    //_bannerImage.layer.cornerRadius = 10;
    //
    _bannerViewHeightConstraint.constant = self.view.frame.size.width / 1.7;
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tap:(UITapGestureRecognizer *)tapRec{
    [[self view] endEditing: YES];
}


-(void)viewWillAppear:(BOOL)animated{

    _txtName.borderStyle = UITextBorderStyleRoundedRect;
    _txtEmail.borderStyle = UITextBorderStyleRoundedRect;
    _TxtPhone.borderStyle = UITextBorderStyleRoundedRect;

    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Contact Us Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    //-----hiding tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;

     AppDelegate *profileAppDelegate;
     profileAppDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    _txtName.text  = [NSString stringWithFormat:@"%@",[profileAppDelegate.userProfileDetails objectForKey:@"username"]];
    _txtEmail.text = [NSString stringWithFormat:@"%@",[profileAppDelegate.userProfileDetails objectForKey:@"email"]];
    _TxtPhone.text = [NSString stringWithFormat:@"%@",[profileAppDelegate.userProfileDetails objectForKey:@"phone"]];
}
-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame = CGRectMake(-290, 0, 275, deviceHieght);
}

//MARK:- MENU SWIPE METHODS
//---------------Menu swipe---------------ß
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


- (IBAction)sendAction:(id)sender {
    if ([Utility reachable]) {

        if(_TxtPhone.text.length ==0)
        {
            [AlertController alertWithMessage:@"Enter Phone number!" presentingViewController:self];
        }else if(_txtName.text.length ==0){
            [AlertController alertWithMessage:@"Enter Name field!" presentingViewController:self];
        }else if(_txtEmail.text.length ==0){
            [AlertController alertWithMessage:@"Enter Email id!" presentingViewController:self];
        }else if(_tvMessage.text.length ==0 || [_tvMessage.text  isEqual: @"Message"]){
            [AlertController alertWithMessage:@"Type your message!" presentingViewController:self];
        }else
        {
            [ProgressHUD show];

            NSDictionary *parameters = @{@"phone": _TxtPhone.text,@"email":_txtEmail.text,@"name":_txtName.text,@"message":_tvMessage.text};
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"%@"parentURL]];

            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];

            [manager POST:[NSString stringWithFormat:@"%@%@",parentURL,ContactUsApi] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 NSLog(@"JSON: %@", responseObject);
                 NSString *text = [responseObject objectForKey:@"code"];


                 if ([text isEqualToString: @"200"])
                 {
                     self->_tvMessage.text= @"";

                     UIAlertController * alert=   [UIAlertController
                                                   alertControllerWithTitle:@"Iam Qatar"
                                                   message:@"Thank you, Your message submitted successfully!"
                                                   preferredStyle:UIAlertControllerStyleAlert];

                     UIAlertAction* ok = [UIAlertAction
                                          actionWithTitle:@"OK"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                                          {
                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                          }];
                     [alert addAction:ok];
                     [self presentViewController:alert animated:YES completion:nil];
                 }
                 [ProgressHUD dismiss];
             }
             failure:^(NSURLSessionTask *task, NSError *error)
             {
                 NSLog(@"Error: %@", error);
                 [ProgressHUD dismiss];
             }];
        }
    }else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}




-(void)setUI{

    _txtName.layer.masksToBounds = false;
    _txtName.layer.shadowRadius = 3.0;
    _txtName.layer.shadowColor = [[UIColor blackColor] CGColor];
    _txtName.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    _txtName.layer.shadowOpacity = 0.5;
    _txtName.delegate = self;

    _txtEmail.layer.masksToBounds = false;
    _txtEmail.layer.shadowRadius = 3.0;
    _txtEmail.layer.shadowColor = [[UIColor blackColor] CGColor];
    _txtEmail.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    _txtEmail.layer.shadowOpacity = 0.5;
    _txtEmail.delegate = self;

    _TxtPhone.layer.masksToBounds = false;
    _TxtPhone.layer.shadowRadius = 3.0;
    _TxtPhone.layer.shadowColor = [[UIColor blackColor] CGColor];
    _TxtPhone.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    _TxtPhone.layer.shadowOpacity = 0.5;
    _TxtPhone.delegate = self;

    _tvMessage.layer.masksToBounds = false;
    _tvMessage.layer.shadowRadius = 3.0;
    _tvMessage.layer.shadowColor = [[UIColor blackColor] CGColor];
    _tvMessage.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    _tvMessage.layer.shadowOpacity = 0.5;
    _tvMessage.layer.cornerRadius = 7.0;
    _tvMessage.delegate = self;
    _tvMessage.textColor = [UIColor lightGrayColor];
    _tvMessage.text = @"Message";

    //Gradient for 'Send' button
    UIColor *gradOneStartColor = [UIColor colorWithRed:244/255.f green:108/255.f blue:122/255.f alpha:1.0];
    UIColor *gradOneEndColor   = [UIColor colorWithRed:251/255.0 green:145/255.0 blue:86/255.0 alpha:1.0];

//    _btnSend.layer.masksToBounds = YES;
//    _btnSend.layer.cornerRadius  = 18.0;
//
//    CAGradientLayer *gradientlayerTwo = [CAGradientLayer layer];
//    gradientlayerTwo.frame = _btnSend.bounds;
//    gradientlayerTwo.startPoint = CGPointZero;
//    gradientlayerTwo.endPoint = CGPointMake(1, 1);
//    gradientlayerTwo.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];
//
//    [_btnSend.layer insertSublayer:gradientlayerTwo atIndex:0];
    [_btnSend addGradientWithColorOne:nil colorTwo:nil];
}


// MARK:- TextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    if ([textView.text isEqualToString:@"Message"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }

    [self.view setFrame:CGRectMake(0,-160,screenWidth,screenHeight)];
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    NSString *textViewStr = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([textView.text isEqualToString:@""]||[textViewStr length]==0) {
        textView.text = @"Message";
        textView.textColor = [UIColor lightGrayColor];
    }

    [self.view setFrame:CGRectMake(0,0,screenWidth,screenHeight)];
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self.view endEditing:YES];
     [self.mainScrollView endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

//MARK:- TAB BAR DELAGATES
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
        }else{
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self->menu setHidden:NO];
                self->menuHideTap.enabled = YES;
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


//    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
//    NSString *userID = store.session.userID;
//    [store logOutUserID:userID];

   //Logout plist clear
    [Utility addtoplist:@"" key:@"login" plist:@"iq"];

    //Resetting 'skipped user' value
    [Utility addtoplist:@"NO"key:@"skippedUser" plist:@"iq"];

    [self.navigationController presentViewController:view animated:NO completion:nil];
}

@end
