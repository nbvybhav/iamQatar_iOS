//
//  AddressViewController.m
//  IamQatar
//
//  Created by alisons on 4/12/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressCell.h"
#import "constants.pch"
#import "AppDelegate.h"
#import "AddAddressViewController.h"
#import "checkOutViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "IamQatar-Swift.h"

NSString *SELECTED_BILLING_ADDRESS = @"SELECTED_BILLING_ADDRESS";

@interface AddressViewController () <UITableViewDelegate,UITableViewDataSource,PopMenuDelegate,UITabBarDelegate,UITabBarControllerDelegate>
{
    NSIndexPath *selectedIndex;
    NSArray *deliveryArray;
    NSArray *full_nameArray;
    NSArray *mobile_numberArray;
    NSArray *buildingNameArray;
    NSArray *house_noArray;
    NSArray *streetArray;
    NSArray *addressTypeArray;
    NSArray *landmarkArray;
    NSArray *townArray;
    NSArray *stateArray;
    NSArray *addressIdArray;
    NSArray *moreInfoArray;
    NSMutableDictionary *editingDic;
    NSMutableDictionary *selectedDic;
    AppDelegate *cartAppDelegate;
    
    

    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;
}

@end

@implementation AddressViewController
@synthesize Datadelegate;
@synthesize isBillingAddress;

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

    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
    editingDic = [[NSMutableDictionary alloc]init];
    selectedIndex=indexPath;
    [self displayApi];

    _addressTableView.allowsMultipleSelectionDuringEditing = NO;
}

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


-(void)setUI{

    _addressTableView.delegate = self;

    /**** set frame size of tableview according to number of cells ****/
    _addressTableView.scrollEnabled = NO;
    [_addressTableView setFrame:CGRectMake(_addressTableView.frame.origin.x, _addressTableView.frame.origin.y, _addressTableView.frame.size.width,(120.0f*([full_nameArray count])))];
    _addAddressBtn.frame = CGRectMake(_addAddressBtn.frame.origin.x,(_addressTableView.frame.origin.y + _addressTableView.frame.size.height), _addAddressBtn.frame.size.width, _addAddressBtn.frame.size.height);

    //Setting scrollview Hieght
    self.mainScrollView.scrollEnabled = YES;
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, _addAddressBtn.frame.origin.y + _addAddressBtn.frame.size.height+60)];

    [self.view layoutIfNeeded];

    //Gradient for button
//    UIColor *gradOneStartColor = [UIColor colorWithRed:244/255.f green:108/255.f blue:122/255.f alpha:1.0];
//    UIColor *gradOneEndColor   = [UIColor colorWithRed:251/255.0 green:145/255.0 blue:86/255.0 alpha:1.0];

    _addAddressBtn.layer.masksToBounds = YES;
    //_addAddressBtn.layer.cornerRadius  = 18.0;
    _saveBtn.layer.masksToBounds = YES;
    //_saveBtn.layer.cornerRadius  = 18.0;

//    CAGradientLayer *gradientlayerOne = [CAGradientLayer layer];
//    gradientlayerOne.frame = _saveBtn.bounds;
//    gradientlayerOne.startPoint = CGPointZero;
//    gradientlayerOne.endPoint = CGPointMake(1, 1);
//    gradientlayerOne.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];
//
//    CAGradientLayer *gradientlayerTwo = [CAGradientLayer layer];
//    gradientlayerTwo.frame = _addAddressBtn.bounds;
//    gradientlayerTwo.startPoint = CGPointZero;
//    gradientlayerTwo.endPoint = CGPointMake(1, 1);
//    gradientlayerTwo.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];
//
//    [_addAddressBtn.layer insertSublayer:gradientlayerTwo atIndex:0];
//    [_saveBtn.layer insertSublayer:gradientlayerOne atIndex:0];
    
    [_addAddressBtn addGradientWithColorOne: nil colorTwo:nil];
    [_saveBtn addGradientWithColorOne: nil colorTwo:nil];
}


-(void)displayApi
{
    if([Utility reachable])
    {
        [ProgressHUD show];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,getAddresses];
        NSDictionary *parameters = @{@"user_id": [appDelegate.userProfileDetails objectForKey:@"user_id"] };
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             
             if ([text isEqualToString: @"Success!"])
             {
                 self->deliveryArray      = [[[responseObject objectForKey:@"value"] valueForKey:@"address"]valueForKey:@"delivery_address"];
                 self->full_nameArray     = [self->deliveryArray valueForKey:@"full_name"];
                 self->mobile_numberArray = [self->deliveryArray valueForKey:@"mobile_number"];
                 self->buildingNameArray  = [self->deliveryArray valueForKey:@"building_name"];
                 self->house_noArray      = [self->deliveryArray valueForKey:@"house_no"];
                 self->addressIdArray     = [self->deliveryArray valueForKey:@"id"];
                 self->moreInfoArray      = [self->deliveryArray valueForKey:@"landmark"];
                 self->streetArray        = [self->deliveryArray valueForKey:@"street"];
                 self->addressTypeArray   = [self->deliveryArray valueForKey:@"address_type"];
             }
             
             NSLog(@"JSON: %@", responseObject);
            [self->_addressTableView reloadData];
             [self setUI];
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
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:true];
    NSString *plistVal = [[NSString alloc]init];
    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];

    if([plistVal isEqualToString:@"YES"]){
        [menu.btnLogout setTitle:@"Log In" forState:UIControlStateNormal];
    }else{
        [menu.btnLogout setTitle:@"Log Out" forState:UIControlStateNormal];
    }
    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Address"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;

    cartAppDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    [self displayApi];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];

    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(0, 625, 275, 335);
}

-(void)viewWillDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame = CGRectMake(-290, 0, 275, deviceHieght);

//    if ([self isBillingAddress]) {
//        //[Utility addtoplist:selectedDic key:SELECTED_BILLING_ADDRESS plist:@"iq"];
//    }else{
//        [Datadelegate sendDataToCheckOutView:selectedDic];
//    }
    
    
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)deliverHereAction:(id)sender {
    
    selectedDic = [[NSMutableDictionary alloc]init];
    
    [selectedDic setObject:[full_nameArray objectAtIndex:selectedIndex.row] forKey:@"full_name"];
    [selectedDic setObject:[house_noArray objectAtIndex:selectedIndex.row] forKey:@"house_no"];
    [selectedDic setObject:[streetArray objectAtIndex:selectedIndex.row] forKey:@"street"];
    [selectedDic setObject:[mobile_numberArray objectAtIndex:selectedIndex.row] forKey:@"mobile_number"];
    [selectedDic setObject:[buildingNameArray objectAtIndex:selectedIndex.row] forKey:@"building_name"];
    [selectedDic setObject:[addressIdArray objectAtIndex:selectedIndex.row] forKey:@"id"];
    [selectedDic setObject:[moreInfoArray objectAtIndex:selectedIndex.row] forKey:@"moreinfo"];

    [Utility addtoplist:@"YES" key:@"fromCheckOut" plist:@"iq"];
    
    if ([self isBillingAddress]) {
        
        //[Utility addtoplist:selectedDic key:SELECTED_BILLING_ADDRESS plist:@"iq"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedDic forKey:SELECTED_BILLING_ADDRESS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        selectedDic.removeAllObjects;
        
    }else{
        [Datadelegate sendDataToCheckOutView:selectedDic];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [full_nameArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"AddressCell";
    AddressCell *cell = (AddressCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    tableView.clipsToBounds = NO;


    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell.radioButton addTarget:self action:@selector(radioButton:) forControlEvents:UIControlEventTouchUpInside];
     cell.radioButton.tag=indexPath.row;
    
    [cell.radioButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [cell.radioButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    
    if ([indexPath isEqual:selectedIndex])
    {
        cell.radioButton.selected = YES;
        cell.editBtn.hidden = NO;
        cell.deleteBtn.hidden = NO;
    } else
    {
        cell.radioButton.selected = NO;
        cell.editBtn.hidden = YES;
        cell.deleteBtn.hidden = YES;
    }
    cell.usernameLbl.text=[full_nameArray objectAtIndex:indexPath.row];
    NSString *multiLineString = [NSString stringWithFormat:@"%@\n%@\n%@",[house_noArray objectAtIndex:indexPath.row],[streetArray objectAtIndex:indexPath.row],[buildingNameArray objectAtIndex:indexPath.row]];
    cell.addressTextView.text = multiLineString;

    cell.editBtn.tag = indexPath.row;
    cell.deleteBtn.tag = indexPath.row;
    [cell.editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

-(void)editAction:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    NSLog(@"tag>%ld",(long)btn.tag);
    
    [editingDic setObject:[full_nameArray objectAtIndex:btn.tag] forKey:@"full_name"];
    [editingDic setObject:[house_noArray objectAtIndex:btn.tag] forKey:@"house_no"];
    [editingDic setObject:[mobile_numberArray objectAtIndex:btn.tag] forKey:@"mobile_number"];
    [editingDic setObject:[buildingNameArray objectAtIndex:btn.tag] forKey:@"building_name"];
    [editingDic setObject:[addressIdArray objectAtIndex:btn.tag] forKey:@"id"];
    [editingDic setObject:[moreInfoArray objectAtIndex:btn.tag] forKey:@"moreinfo"];
    [editingDic setObject:[streetArray objectAtIndex:btn.tag] forKey:@"street"];
    [editingDic setObject:[addressTypeArray objectAtIndex:btn.tag] forKey:@"address_type"];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAddressViewController *myVC = (AddAddressViewController *)[storyboard instantiateViewControllerWithIdentifier:@"addAddressView"];
    myVC.dictionaryRecieved = editingDic;
    [self.navigationController pushViewController:myVC animated:YES] ;
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        if ([Utility reachable])
        {
            [ProgressHUD show];
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            NSString *urlString = [NSString stringWithFormat:@"%@/%@",parentURL,deleteAddressAPI];
            NSDictionary *parameters = @{@"id": [addressIdArray objectAtIndex:indexPath.row],@"user_id": [appDelegate.userProfileDetails objectForKey:@"user_id"]};

//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [manager GET:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 NSString *text = [responseObject objectForKey:@"code"];

                 if ([text isEqualToString: @"200"])
                 {
                     NSLog(@"Deleted!");
                     [self displayApi];
                 }

                 NSLog(@"JSON: %@", responseObject);
                 [ProgressHUD dismiss];

             } failure:^(NSURLSessionTask *task, NSError *error) {
                 NSLog(@"Error: %@", error);
                 [ProgressHUD dismiss];
             }];
        }else{
            [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
        }
    }
}


-(void)deleteAction:(id)sender{

     UIButton *btn = (UIButton *) sender;

    if ([Utility reachable])
    {
        [ProgressHUD show];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        NSString *urlString = [NSString stringWithFormat:@"%@/%@",parentURL,deleteAddressAPI];
        NSDictionary *parameters = @{@"id": [addressIdArray objectAtIndex:btn.tag],@"user_id": [appDelegate.userProfileDetails objectForKey:@"user_id"]};

//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"code"];

             if ([text isEqualToString: @"200"])
             {
                 NSLog(@"Deleted!");
                 [self displayApi];
             }

             NSLog(@"JSON: %@", responseObject);
             [ProgressHUD dismiss];

         } failure:^(NSURLSessionTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             [ProgressHUD dismiss];
         }];
    }else{
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}

- (void)radioButton:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:button.tag inSection:0];
    selectedIndex = indexPath;
    [_addressTableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    bestBuyDetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"bbDetailView"];
//    detailView.bbProductId = [productIdArray objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)AddAddressAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAddressViewController *myVC = (AddAddressViewController *)[storyboard instantiateViewControllerWithIdentifier:@"addAddressView"];
    myVC.dictionaryRecieved = nil;
     [self.navigationController pushViewController:myVC animated:YES] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
