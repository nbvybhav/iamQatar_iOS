//
//  AddAddressViewController.m
//  IamQatar
//
//  Created by alisons on 4/12/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import "AddAddressViewController.h"
#import "constants.pch"
#import "AppDelegate.h"

@import GooglePlaces;
@import GooglePlacePicker;

@interface AddAddressViewController () <GMSPlacePickerViewControllerDelegate,PopMenuDelegate,UITabBarControllerDelegate,UITabBarDelegate>

{
    NSString *addressType;
    GMSPlacesClient *_placesClient;
    BOOL moreInfoIsOpen ;
    AppDelegate *cartAppDelegate;

    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;
}
@end

@implementation AddAddressViewController



//MARK:- VIEW DID LOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];

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

    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];

    menuHideTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    [self.view addGestureRecognizer:menuHideTap];
    menuHideTap.enabled = NO;

    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];

    addressType = @"Home";

    [self setUI];

    // For the border and rounded corners
    [[_moreInfoTxt layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[_moreInfoTxt layer] setBorderColor:[[UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:0.40] CGColor]];
    [[_moreInfoTxt layer] setBorderWidth:1];
    [[_moreInfoTxt layer] setCornerRadius:10];
    [_moreInfoTxt setClipsToBounds: YES];

    if ([_dictionaryRecieved count]>0) {
        _fullNameTxt.text   = [_dictionaryRecieved valueForKey:@"full_name"];
        _flatNoTxt.text     = [_dictionaryRecieved valueForKey:@"house_no"];
        _streetTxt.text     = [_dictionaryRecieved valueForKey:@"street"];
        _mobileNumTxt.text  = [_dictionaryRecieved valueForKey:@"mobile_number"];
        _buildingName.text  = [_dictionaryRecieved valueForKey:@"building_name"];
        _moreInfoTxt.text   = [_dictionaryRecieved valueForKey:@"moreinfo"];
    }

    if([[_dictionaryRecieved valueForKey:@"address_type"]isEqualToString:@"home"])
    {
        addressType=@"Home";
        [_radioButtonHome setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        [_radioButtonWork setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_radioButtonOther setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    }else if([[_dictionaryRecieved valueForKey:@"address_type"]isEqualToString:@"office"]){
        addressType=@"Office";
        [_radioButtonHome setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_radioButtonWork setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        [_radioButtonOther setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    }else{
        addressType=@"Other";
        [_radioButtonHome setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_radioButtonWork setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_radioButtonOther setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }

    _fullNameTxt.tag     = 0;
    _mobileNumTxt.tag    = 1;
    _buildingName.tag    = 2;
    _flatNoTxt.tag       = 3;
    _streetTxt.tag       = 4;
    
    _placesClient = [GMSPlacesClient sharedClient];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];

//    menuHideTap.enabled = NO;
        [menu setHidden:YES];
//    isSelected = NO;
//    menu.frame=CGRectMake(0, 625, 275, 335);
}

-(void)viewWillAppear:(BOOL)animated{
    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Add Address screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];


    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;

    cartAppDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
}

-(void)viewWillDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame = CGRectMake(-290, 0, 275, deviceHieght);
}


//MARK:- MENU SWIPE METHODS
//---------------Menu swipe---------------
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

//MARK:- TEXT FIELD DELEGATE
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 3 || textField.tag == 4 || textField.tag == 5 || textField.tag == 6 || textField.tag == 7  ) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationBeginsFromCurrentState:TRUE];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -200., self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
   if (textField.tag == 3 || textField.tag == 4 || textField.tag == 5 || textField.tag == 6 || textField.tag == 7  )  {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationBeginsFromCurrentState:TRUE];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +200., self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:true];
    return true;
}

//MARK:- METHODS

- (void)setUI {

    //self.btnShowMap.frame = self.streetTxt.frame;

    moreInfoIsOpen = false;
    self.moreInfoTxt.frame = CGRectMake(self.btnMoreInfo.frame.origin.x, self.btnMoreInfo.frame.origin.y + self.btnMoreInfo.frame.size.height+10, self.btnMoreInfo.frame.size.width, 0);

    self.mapView.frame = CGRectMake(self.moreInfoTxt.frame.origin.x, self.moreInfoTxt.frame.origin.y + self.moreInfoTxt.frame.size.height, self.btnMoreInfo.frame.size.width, 0);

    self.btnSave.frame = CGRectMake(self.btnSave.frame.origin.x, self.mapView.frame.origin.y + self.mapView.frame.size.height + 15, self.btnSave.frame.size.width, self.btnSave.frame.size.height);

    [self.view layoutIfNeeded];

    //Gradient for 'Send' button
    UIColor *gradOneStartColor = [UIColor colorWithRed:244/255.f green:108/255.f blue:122/255.f alpha:1.0];
    UIColor *gradOneEndColor   = [UIColor colorWithRed:251/255.0 green:145/255.0 blue:86/255.0 alpha:1.0];

    _btnSave.layer.masksToBounds = YES;
    _btnSave.layer.cornerRadius  = 18.0;

    CAGradientLayer *gradientlayerTwo = [CAGradientLayer layer];
    gradientlayerTwo.frame = _btnSave.bounds;
    gradientlayerTwo.startPoint = CGPointZero;
    gradientlayerTwo.endPoint = CGPointMake(1, 1);
    gradientlayerTwo.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];

    [_btnSave.layer insertSublayer:gradientlayerTwo atIndex:0];


}

-(void)dismissKeyboard
{
    [self.view endEditing:true];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}

//MARK:- TEXTVIEW LIFTING
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextView: YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:NO];
}
- (void) animateTextView:(BOOL) up
{
    const int movementDistance = 200; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement= movement = (up ? -movementDistance : movementDistance);
    NSLog(@"%d",movement);

    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    _mainScrollView.frame = CGRectOffset(self.mainScrollView.frame, 0, movement);
    [UIView commitAnimations];
}



- (BOOL) validateNumbers: (NSString *) text {
    NSString *Regex = @"[0-9]*";
    NSPredicate *TestResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [TestResult evaluateWithObject:text];
}

//MARK:- BTN ACTIONS
- (IBAction)mapAction:(id)sender
{
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:nil];
    GMSPlacePickerViewController *placePicker =
    [[GMSPlacePickerViewController alloc] initWithConfig:config];
    placePicker.delegate = self;

    [self presentViewController:placePicker animated:YES completion:nil];
}
- (IBAction)moreInfoBtnAction:(id)sender {


    if (moreInfoIsOpen){

        [UIView animateWithDuration:0.4 animations:^{
            self.moreInfoTxt.frame = CGRectMake(self.btnMoreInfo.frame.origin.x, self.btnMoreInfo.frame.origin.y + self.btnMoreInfo.frame.size.height+10, self.btnMoreInfo.frame.size.width, 0);
            [self.view layoutIfNeeded];

            self.mapView.frame = CGRectMake(self.moreInfoTxt.frame.origin.x, self.moreInfoTxt.frame.origin.y + self.moreInfoTxt.frame.size.height, self.btnMoreInfo.frame.size.width, 0);

            self.btnSave.frame = CGRectMake(self.btnSave.frame.origin.x, self.mapView.frame.origin.y + self.mapView.frame.size.height + 15, self.btnSave.frame.size.width, self.btnSave.frame.size.height);

            self->moreInfoIsOpen = false;
        } completion:^(BOOL finished) {

            //[self setUI];

        }];

    }else{

        [UIView animateWithDuration:0.4 animations:^{
            self.moreInfoTxt.frame = CGRectMake(self.btnMoreInfo.frame.origin.x, self.btnMoreInfo.frame.origin.y + self.btnMoreInfo.frame.size.height+10, self.btnMoreInfo.frame.size.width, 100);

            self.mapView.frame = CGRectMake(self.moreInfoTxt.frame.origin.x, self.moreInfoTxt.frame.origin.y + self.moreInfoTxt.frame.size.height, self.btnMoreInfo.frame.size.width, 0);

            self.btnSave.frame = CGRectMake(self.btnSave.frame.origin.x, self.mapView.frame.origin.y + self.mapView.frame.size.height + 15, self.btnSave.frame.size.width, self.btnSave.frame.size.height);

            [self.view layoutIfNeeded];
            self->moreInfoIsOpen = true;
        } completion:^(BOOL finished) {

           // [self setUI];

        }];

    }
}

-(IBAction)onRadioBtn:(UIButton*)sender
{
    NSInteger value = [sender tag];
    if (value == 0)
    {
        addressType=@"Home";
        [_radioButtonHome setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        [_radioButtonWork setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_radioButtonOther setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    }
    else if (value == 1)
    {
        addressType=@"Office";
        [_radioButtonHome setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_radioButtonWork setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        [_radioButtonOther setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    }else{
        addressType=@"Other";
        [_radioButtonHome setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_radioButtonWork setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_radioButtonOther setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }
    
    NSLog(@"Selected: %ld", (long)sender.tag);
}
- (IBAction)saveAction:(id)sender
{
    if ([_fullNameTxt.text isEqualToString:@""] || [_fullNameTxt.text isEqual:nil] )
    {
        [AlertController alertWithMessage:@"Enter your name!" presentingViewController:self];
        [_fullNameTxt resignFirstResponder];
    }
    else if ([_mobileNumTxt.text isEqualToString:@""] || [_mobileNumTxt.text isEqual:nil] )
    {
        [AlertController alertWithMessage:@"Enter your mobile number" presentingViewController:self];
        [_mobileNumTxt resignFirstResponder];
    }
    else if([self validateNumbers:_mobileNumTxt.text] == false)
    {
        [AlertController alertWithMessage:@"Check your mobile number" presentingViewController:self];
        [_mobileNumTxt resignFirstResponder];
    }
    else if(_mobileNumTxt.text.length != 8)
    {
        [AlertController alertWithMessage:@"Enter valid mobile number" presentingViewController:self];
        [_mobileNumTxt resignFirstResponder];
    }
    else if ([_buildingName.text isEqualToString:@""] || [_buildingName.text isEqual:nil] )
    {
        [AlertController alertWithMessage:@"Enter Building name" presentingViewController:self];
        [_buildingName resignFirstResponder];
    }
    else if ([_flatNoTxt.text isEqualToString:@""] || [_flatNoTxt.text isEqual:nil] )
    {
        [AlertController alertWithMessage:@"Enter your House no." presentingViewController:self];
        [_flatNoTxt resignFirstResponder];
    }
    else if ([_streetTxt.text isEqualToString:@""] || [_streetTxt.text isEqual:nil] )
    {
        [AlertController alertWithMessage:@"Enter your street" presentingViewController:self];
        [_streetTxt resignFirstResponder];
    }
    else
    {
        [self saveApi];
    }
}


- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

//MARK:- API CALL
-(void)saveApi
{
    if ([Utility reachable]) {

        [ProgressHUD show];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,addUserAddress];
        NSDictionary *parameters;
        
        if ([_dictionaryRecieved count]>0)
        {
            parameters = @{@"user_id": [appDelegate.userProfileDetails objectForKey:@"user_id"], @"full_name":_fullNameTxt .text, @"mobile_no": _mobileNumTxt.text, @"building_name": _buildingName.text, @"flat_no": _flatNoTxt.text, @"street": _streetTxt.text,@"address_type": addressType,@"id":[_dictionaryRecieved valueForKey:@"id"],@"latitude":@"",@"longitude":@"",@"moreinfo":_moreInfoTxt.text };
        }
        else
        {
            parameters =  @{@"user_id": [appDelegate.userProfileDetails objectForKey:@"user_id"], @"full_name":_fullNameTxt .text, @"mobile_no": _mobileNumTxt.text, @"building_name": _buildingName.text, @"flat_no": _flatNoTxt.text, @"street": _streetTxt.text,@"address_type": addressType,@"latitude":@"",@"longitude":@"",@"moreinfo":_moreInfoTxt.text };;
        }

//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             
             if ([text isEqualToString: @"Success!"])
             {
                [self.navigationController popViewControllerAnimated:YES];
             }
             
             NSLog(@"JSON: %@", responseObject);
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


//MARK:- PLACE PICKER DELEGATES


// GMSPlacePickerViewControllerDelegate and implement this code.
- (void)placePicker:(GMSPlacePickerViewController *)viewController didPickPlace:(GMSPlace *)place {
    // Dismiss the place picker, as it cannot dismiss itself.
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Place name %@", place.name);

    self.streetTxt.text = place.name;

    [UIView animateWithDuration:0.4 animations:^{


        self.mapView.frame = CGRectMake(self.moreInfoTxt.frame.origin.x, self.moreInfoTxt.frame.origin.y + self.moreInfoTxt.frame.size.height, self.btnMoreInfo.frame.size.width, 100);

        self.btnSave.frame = CGRectMake(self.btnSave.frame.origin.x, self.mapView.frame.origin.y + self.mapView.frame.size.height + 15, self.btnSave.frame.size.width, self.btnSave.frame.size.height);

        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {

        // [self setUI];

    }];


    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
}

- (void)placePickerDidCancel:(GMSPlacePickerViewController *)viewController {
    // Dismiss the place picker, as it cannot dismiss itself.
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"No place selected");
}


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
    // navigation not needed for this page
}
-(void)GoAboutUsPage:(Menu *)sender{
    AboutUsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutUsView"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)History:(Menu *)sender{
    OrderHistoryViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
    [self.navigationController pushViewController:view animated:YES];
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

    //Logout plist clear
    [Utility addtoplist:@"" key:@"login" plist:@"iq"];

    //Resetting 'skipped user' value
    [Utility addtoplist:@"NO"key:@"skippedUser" plist:@"iq"];

    [self.navigationController presentViewController:view animated:NO completion:nil];
}




@end
