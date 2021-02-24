//
//  FifthViewController.m
//  IamQatar
//
//  Created by alisons on 8/18/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "cartViewController.h"
#import "cartCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "checkOutViewController.h"
#import "constants.pch"
#import "MarketViewController.h"
#import "ProfileViewController.h"
#import "IamQatar-Swift.h"
#import <SDWebImage/SDWebImage.h>


@interface cartViewController ()
{

    AppDelegate *cartAppDelegate;
    NSMutableArray *qtyVal ;
    UITableViewCell *CustomCell;
    int txtTagVbl;
}
@end

@implementation cartViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int cartBadgeValue;
    NSMutableArray *cartViewDetailsArray;
    float savedAmount;
    int deviceHieght;
    // BOOL editable;
    NSArray *timeForGiftDeliveryArray;//giftDeliveryTimeArray
    NSInteger currentlyEditingCartItemIndex;//will contain the index of cart item whose delivery date(gift) is now being changed
    
    //kolamazz
    BOOL isProceedToCheckOutPossible;// depended in gift delivery date, condition is in cellForRowAtIndexPath
}

//MARK:- VIEW DIDLOAD
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    self.title = @"CART";
    
    for(UITabBarItem * tabBarItem in self.tabBarController.tabBar.items){
        tabBarItem.title = @"";
        //tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    
    cartAppDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    _cartTableView.estimatedRowHeight = 150;
    _cartTableView.rowHeight = UITableViewAutomaticDimension;
    
    [ProgressHUD show];
    [self setUpTotalPriceView];
    [self getCartCoutValue];
    [self setCartValue];

    
    
    //self.tabBarItem.selectedImage = [[UIImage imageNamed:@"cart"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
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
    swipeleft.cancelsTouchesInView = YES;


    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    swiperight.cancelsTouchesInView = YES;

    cartViewDetailsArray=[NSMutableArray new];


    qtyVal = [[NSMutableArray alloc] init];
    for (int i=1; i<=100; i++)
    {
        [qtyVal addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _qtyPicker.delegate = self;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView)];
    [_cartTableView addGestureRecognizer:tap];
    self.cartTableView.tableFooterView = [UIView new]; // to hide empty cells

    //Tab bar tintcolor
    self.tabBarController.tabBar.tintColor = [UIColor lightGrayColor];
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor lightGrayColor];
}


-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame = CGRectMake(-290, 0, 275, deviceHieght);
    //[[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:FALSE] ;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:true];
    //save empty dict to selected billing address userdefaults
    NSDictionary *emptyDict;
    [[NSUserDefaults standardUserDefaults] setObject:emptyDict forKey:@"SELECTED_BILLING_ADDRESS"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    
    
    
    NSString *plistVal = [[NSString alloc]init];
    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];

    if([jumpToHome isEqualToString:@"YES"]){
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
    }

    if([plistVal isEqualToString:@"YES"]||[jumpToHome isEqualToString:@"YES"]){
        [menu.btnLogout setTitle:@"Log In" forState:UIControlStateNormal];
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
    }else{
        [menu.btnLogout setTitle:@"Log Out" forState:UIControlStateNormal];
    }
    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Cart page"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];


    //cartCell *cell = [_cartTableView dequeueReusableCellWithIdentifier:@"cartCell"];
    //[cell.cartQty addTarget:self action:@selector(txtTag:) forControlEvents: UIControlEventEditingDidEnd];
    // editable = NO;

    //----empty view-----
    _emptyView.hidden =YES;
    _qtyPickerView.hidden = YES;

    //-----hiding tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews] lastObject]setHidden:FALSE] ;
    self.tabBarController.delegate = self;
    
   
    isProceedToCheckOutPossible = true;
    //kolamazz : call cart update api after selecting date,time etc from delivery details page
    NSDictionary *selectedGiftData = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedGiftData"];
    //NSLog(@"selected gift data>%lu", selectedGiftData);
    NSLog(@"selected gift data : %@", [selectedGiftData description]);
    if (selectedGiftData != nil){
        
        cartCell *cell = [self.cartTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:currentlyEditingCartItemIndex inSection:0]];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        NSDictionary *parameters = @{@"user_id": [appDelegate.userProfileDetails objectForKey:@"user_id"],
                                     @"quantity": cell.cartQty.text,
                                     @"cart_id": [[cartViewDetailsArray objectAtIndex:currentlyEditingCartItemIndex] objectForKey:@"cart_id"]
                                     };
        
        
        NSMutableDictionary *selectedGiftDataMutable = [selectedGiftData mutableCopy];
        NSLog(@"selected gift data : %@", [selectedGiftData description]);
        [selectedGiftDataMutable addEntriesFromDictionary:parameters];
        NSLog(@"parameters : %@", [selectedGiftData description]);
        
        
        [[NSUserDefaults standardUserDefaults]setValue: nil forKey:@"selectedGiftData"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self addToCartActionIsBtnplus:selectedGiftDataMutable];
        
        
    }else{
        [self getCartDetails];
        [self getCartCoutValue];
    }
    
    
    
}



//MARK:- API CALL
- (void)removeCartDetails:(NSInteger)senderValue
{
    if ([Utility reachable]) {

        [ProgressHUD show];
        NSDictionary *parameters = @{@"user_id":[cartAppDelegate.userProfileDetails objectForKey:@"user_id"],@"cart_id": [[cartViewDetailsArray objectAtIndex:senderValue] objectForKey:@"cart_id"] };

//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:[NSString stringWithFormat:@"%@api.php?page=removeCartItem",parentURL]parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *text = [responseObject objectForKey:@"text"];
            if ([text isEqualToString: @"Success!"])
            {
                self->cartBadgeValue = [[[responseObject objectForKey:@"count"] objectForKey:@"count"]intValue];

                NSString *badgeStr = [NSString stringWithFormat:@"%d",self->cartBadgeValue];
                [Utility addtoplist:badgeStr key:@"cartCount" plist:@"iq"];

                [self setCartValue];
                [self getCartCoutValue];
                [self getCartDetails];
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


- (void)getCartCoutValue{

    if ([Utility reachable]) {

        [ProgressHUD show];
        NSDictionary *parameters = @{@"user_id": [cartAppDelegate.userProfileDetails objectForKey:@"user_id"]};

//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:[NSString stringWithFormat:@"%@api.php?page=cartCount",parentURL] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *text = [responseObject objectForKey:@"text"];
            if ([text isEqualToString: @"Success!"])
            {
                self->cartBadgeValue = [[[responseObject objectForKey:@"value"] objectForKey:@"count"]intValue];
                if (self->cartBadgeValue > 0) {
                    self->_emptyView.hidden =YES;
                    self->_priceDtailsView.hidden = NO;
                    [self setCartValue];
                }else{
                    self->_emptyView.hidden = NO;
                    self->_priceDtailsView.hidden = YES;
                    [self setCartValue];
                }
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



- (void)getCartDetails{

    if ([Utility reachable]) {

        [ProgressHUD show];
        NSDictionary *parameters = @{@"user_id": [cartAppDelegate.userProfileDetails objectForKey:@"user_id"]};

//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:[NSString stringWithFormat:@"%@api.php?page=getCartItems",parentURL] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *text = [responseObject objectForKey:@"text"];

            if ([text isEqualToString: @"Success!"])
            {
                NSLog(@"JSON: %@", responseObject);

                if(![[responseObject objectForKey:@"value"]  isEqual:@""])
                {
                    NSString *str    = [[responseObject objectForKey:@"cart_total"]objectForKey:@"totalsaved"];
                    self->savedAmount = [str floatValue];

                    self->cartBadgeValue = [[[responseObject objectForKey:@"count"] objectForKey:@"count"]intValue];
                    NSString *badgeStr = [NSString stringWithFormat:@"%d",self->cartBadgeValue];
                    [Utility addtoplist:badgeStr key:@"cartCount" plist:@"iq"];

                    self->_checkOutBtn.userInteractionEnabled = YES;
                    self->_checkOutBtn.alpha = 1.0;
                    self->cartViewDetailsArray=[responseObject objectForKey:@"value"];
                    self->timeForGiftDeliveryArray = [responseObject objectForKey:@"timeslote"];//kolamazz
                    self->_cartTableView.hidden = NO;
                    [self->_cartTableView reloadData];
                    [self setUpTotalPriceView];
                }else{
                    self->_checkOutBtn.userInteractionEnabled = NO;
                    self->_checkOutBtn.alpha = 0.45;
                    self->_cartTableView.hidden = YES;
                    self->cartViewDetailsArray = nil;
                    [self->_cartTableView reloadData];
                    [self setUpTotalPriceView];
                }
            }
            [ProgressHUD dismiss];
            [self setUI];

        } failure:^(NSURLSessionTask *task, NSError *error) {
            NSLog(@"Error: %@", error);
            [ProgressHUD dismiss];
        }];

    }else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}

-(void)addToCartActionIsBtnplus:(NSDictionary*)parameters
{
    if ([Utility reachable]) {

        [ProgressHUD show];

//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager POST:[NSString stringWithFormat:@"%@api.php?page=updateCartItem",parentURL]
           parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject){
               NSString *text = [responseObject objectForKey:@"text"];

               if ([text isEqualToString: @"Success!"])
               {
                   NSLog(@"Success!");
               }
               NSLog(@"JSON: %@", responseObject);
               [self getCartDetails];
               [ProgressHUD dismiss];

           } failure:^(NSURLSessionTask *task, NSError *error) {
               NSLog(@"Error: %@", error);
               [ProgressHUD dismiss];
           }];
    }
    else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}



//MARK:- BTN ACTIONS
- (IBAction)doneAction:(id)sender {
    [_qtyPicker reloadAllComponents];
    [_qtyPicker selectRow:0 inComponent:0 animated:YES];
    _qtyPickerView.hidden = YES;
}

- (IBAction)checkOut:(id)sender
{
    
    if (isProceedToCheckOutPossible){
        
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        checkOutViewController *checkoutVc = (checkOutViewController *)[storyboard instantiateViewControllerWithIdentifier:@"checkout"];
        
        //Checking skipped user or not
        NSString *plistVal = [[NSString alloc]init];
        plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];
        
        if([plistVal isEqualToString:@"YES"]){
            LoginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
            
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
            [self.navigationController presentViewController:view animated:NO completion:nil];
        }else{
            [Utility addtoplist:@"YES" key:@"fromCheckOut" plist:@"iq"];
            checkoutVc.savedAmount = [NSString stringWithFormat:@"%f",savedAmount];
            [self.navigationController pushViewController:checkoutVc animated:YES];
        }
        
    }else{
        //kolamazz
        [AlertController alertWithMessage:[NSString stringWithFormat:@"Please change delivery date of gift"] presentingViewController:self];
        
    }
    
    
}



-(void)btnPlus: (UIButton*)sender{

    //UITextField *txt = (UITextField*)sender;
    NSInteger index = sender.tag;//txt.tag;
    txtTagVbl = (int)sender.tag;//(int)txt.tag;

    NSIndexPath *nowIndex = [NSIndexPath indexPathForRow:index inSection:0];
    cartCell *cell = [self.cartTableView cellForRowAtIndexPath:nowIndex];

    int qty = [cell.cartQty.text intValue];
    int stock_quantity    = [[[[cartViewDetailsArray objectAtIndex:index]valueForKey:@"product_details"]valueForKey:@"stock_quantity"]intValue];

    //Checking with maximum available stock
    if(qty+1>stock_quantity){
//        [AlertController alertWithMessage:[NSString stringWithFormat:@"Maximum available quantity is:%d",qty] presentingViewController:self];
    }else{
        cell.cartQty.text = [NSString stringWithFormat:@"%d",qty+1];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        NSDictionary *parameters = @{@"user_id": [appDelegate.userProfileDetails objectForKey:@"user_id"],
                                     @"quantity": cell.cartQty.text,
                                     @"cart_id": [[cartViewDetailsArray objectAtIndex:index] objectForKey:@"cart_id"]
                                     };
        [self addToCartActionIsBtnplus:parameters];
    }
}

-(void)btnMinus: (UIButton*)sender {

    NSInteger index = sender.tag;//txt.tag;
    txtTagVbl = (int)sender.tag;//(int)txt.tag;

    NSIndexPath *nowIndex = [NSIndexPath indexPathForRow:index inSection:0];
    cartCell *cell = [self.cartTableView cellForRowAtIndexPath:nowIndex];

    int qty = [cell.cartQty.text intValue];

    if ([cell.cartQty.text isEqualToString:@"1"]){


    }else{

        cell.cartQty.text = [NSString stringWithFormat:@"%d",qty-1];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        NSDictionary *parameters = @{@"user_id": [appDelegate.userProfileDetails objectForKey:@"user_id"],
                                     @"quantity": cell.cartQty.text,
                                     @"cart_id": [[cartViewDetailsArray objectAtIndex:index] objectForKey:@"cart_id"]
                                     };
        [self addToCartActionIsBtnplus:parameters];
    }


}

-(void)deleteFromList: (id)sender{

    UIButton *btn = (UIButton*)sender;
    NSInteger index = btn.tag;

    [self removeCartDetails:index];
    [_cartTableView reloadData]; // tell table to refresh now
}

-(void)didTapOnTableView{
    _qtyPickerView.hidden = YES;
}

//MARK:- METHODS

-(void)setUpTotalPriceView
{
    float totalPrice   = 0.00;
    float subTotalPrice= 0.00;

    for (int i=0; i<[cartViewDetailsArray count]; i++)
    {
        NSLog(@"TOTAl %@", [[[cartViewDetailsArray objectAtIndex:i]objectForKey:@"product_details"]objectForKey:@"total"]);
        float  value =[[[[cartViewDetailsArray objectAtIndex:i]objectForKey:@"product_details"]objectForKey:@"total"] floatValue];
        totalPrice += value;
        float subValue=[[[[cartViewDetailsArray objectAtIndex:i]objectForKey:@"product_details"]objectForKey:@"total"] floatValue];

        subTotalPrice +=subValue;
        NSLog(@"%f",totalPrice);
    }
    _cartSubTotal.text            = [NSString stringWithFormat:@"%0.2f QAR",subTotalPrice ];
    [_cartTotal setTitle:[NSString stringWithFormat:@"%0.2f QAR",totalPrice] forState:UIControlStateNormal];

    savedAmount = floor (savedAmount);

    if(savedAmount == 0)
    {
        _savedAmnt.hidden = YES;
        _lblSavedAmount.hidden = YES;
    }else{
        _savedAmnt.hidden = NO;
        _lblSavedAmount.hidden = NO;
        _savedAmnt.text           = [NSString stringWithFormat:@"%0.2f QAR",savedAmount];
    }
}
- (void)setCartValue
{
    if (cartBadgeValue != 0) {
        NSString * value=[NSString stringWithFormat:@"%i",cartBadgeValue];
        [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:value];
    }
    else{
        [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:nil];
    }
}

- (IBAction)continueShoppingAction:(id)sender {

    MarketViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"marketView"];
    [self.navigationController pushViewController:view animated:YES];
}


-(void)setUI
{
    /**** set frame size of tableview according to number of cells ****/
    _cartTableView.scrollEnabled = NO;
    //kolamazz
    //[_cartTableView setFrame:CGRectMake(_cartTableView.frame.origin.x, _cartTableView.frame.origin.y, _cartTableView.frame.size.width,(115*([cartViewDetailsArray count])) + 115.0f)];
    [_cartTableView setFrame:CGRectMake(_cartTableView.frame.origin.x,25, _cartTableView.frame.size.width,(150*([cartViewDetailsArray count])) + 10)];
    [_priceDtailsView setFrame:CGRectMake(_priceDtailsView.frame.origin.x,_cartTableView.frame.origin.y + _cartTableView.frame.size.height, _priceDtailsView.frame.size.width, _priceDtailsView.frame.size.height)];

    //Setting main scrollview Hieght
    self.mainScrollView.scrollEnabled = YES;
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.priceDtailsView.frame.origin.y + self.priceDtailsView.frame.size.height+40)];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    _qtyPickerView.hidden = YES;

    //    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    //    isSelected = NO;
    //    menu.frame=CGRectMake(0, 625, 275, 335);
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}


//MARK:- TABBAR DELEGATES
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
      jumpToHome = [NSString stringWithFormat:@"NO"];

    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
    {

        if (isSelected) {

            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->isSelected = NO;
                self->menu.frame = CGRectMake(-290, 0, 275, self->deviceHieght);
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
    }else if (viewController == [self.tabBarController.viewControllers objectAtIndex:3])
    {
            //[Utility exitAlert:self];
            //[self.tabBarController setSelectedIndex:2];

            //return NO;
        //        [self.navigationController popViewControllerAnimated:YES];
        
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

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
//    {
//    }
//}

//MARK:- TABLE VIEW DELEGATES
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Didselect!");
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        [self removeCartDetails:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [cartViewDetailsArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    cartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell"];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"cartCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

//    cell.cartQty.layer.borderWidth = 1;
//    cell.cartQty.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    cell.btnPlus.tag  = indexPath.row ;
    cell.btnMinus.tag = indexPath.row ;
    cell.cartQty.tag  = indexPath.row + 1;
    cell.btnDelete.tag = indexPath.row;

    [cell.btnDelete addTarget:self action:@selector(deleteFromList:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPlus addTarget:self action:@selector(btnPlus:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMinus addTarget:self action:@selector(btnMinus:) forControlEvents:UIControlEventTouchUpInside];

    float totalForItem  =  [[[[cartViewDetailsArray objectAtIndex:indexPath.row] objectForKey:@"product_details"]objectForKey:@"total"]floatValue];
    //total = ceilf(total);

    cell.cartQty.text = [NSString stringWithFormat:@"%@",[[cartViewDetailsArray objectAtIndex:indexPath.row]objectForKey:@"quantity"]];
    [cell.btnPrice setTitle:[NSString stringWithFormat:@"%0.2f QAR",totalForItem] forState:UIControlStateNormal];
    cell.cartComboGifts.text=[NSString stringWithFormat:@"%@",[[[cartViewDetailsArray objectAtIndex:indexPath.row] objectForKey:@"product_details"] objectForKey:@"product_name"]];
    cell.lblAttribute.text = [NSString stringWithFormat:@"%@",[[cartViewDetailsArray objectAtIndex:indexPath.row] objectForKey:@"product_attributes"]];

    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,[[cartViewDetailsArray objectAtIndex:indexPath.row] objectForKey:@"default"]];
    NSURL *imageURL = [NSURL URLWithString:urlString];
    [cell.cartImage sd_setImageWithURL:imageURL
                   placeholderImage:[UIImage imageNamed:@"No_Image_Available.png"]];
   
    //kolamazz
    //check for gift delivery date (which is selected by user from the product details page) is expired or not
    cell.btnChangeDate.tag = indexPath.row;
    [cell.btnChangeDate addTarget:self action:@selector(changeGiftDate:) forControlEvents:UIControlEventTouchUpInside];
    NSString *productType = [[[cartViewDetailsArray objectAtIndex:indexPath.row] valueForKey:@"product_details"] valueForKey:@"type"];
    if ([productType  isEqual: @"gift"]){
        
        cell.lblGift.hidden = false;

        NSString *alreadySelectedDeliveryDateString = [[[cartViewDetailsArray objectAtIndex:indexPath.row] valueForKey:@"product_details"] valueForKey:@"cart_delivery_date"];
        NSString *curruntDateString = [[[cartViewDetailsArray objectAtIndex:indexPath.row] valueForKey:@"product_details"] valueForKey:@"current_date"];
        NSString *extraDaysNeeded = [NSString stringWithFormat:@"%@",[[[cartViewDetailsArray objectAtIndex:indexPath.row] valueForKey:@"product_details"] valueForKey:@"delivery_date"]];//extra number of days needed for order delivery
        
        NSDate *selectedDate = [self convertStringToDate:alreadySelectedDeliveryDateString];
        NSDate *curruntDate = [self convertStringToDate:curruntDateString];
//        NSDate *selectedDate = [Utilities *uti].
//        NSDate *curruntDate = [self convertStringToDate:curruntDateString];
        
        
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = [extraDaysNeeded integerValue];
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *minAvailableDeliveyDate = [theCalendar dateByAddingComponents:dayComponent toDate:curruntDate options:0];
        
        NSLog(@"minAvailableDeliveyDate: %@ ...", minAvailableDeliveyDate);
        
    
//        NSDate * now = [NSDate date];
//        NSDate * mile = [[NSDate alloc] initWithString:@"2001-03-24 10:45:32 +0600"];

        NSLog(@"alreadySelectedDeliveryDateString %@", alreadySelectedDeliveryDateString);
        NSLog(@"curruntDateString %@", curruntDateString);
        NSLog(@"extraDaysNeeded %@", extraDaysNeeded);
                                    //16.10.19                       //18.10/19
        NSComparisonResult result = [minAvailableDeliveyDate compare:selectedDate];

        _Bool *isTimeExpired;
        switch (result)
        {
            case NSOrderedAscending:
                isTimeExpired = false;
                NSLog(@"%@ is in future from %@", selectedDate, minAvailableDeliveyDate);
                break;
            case NSOrderedDescending:
                isTimeExpired = true;
                NSLog(@"%@ is in past from %@", selectedDate, minAvailableDeliveyDate);
                break;
            case NSOrderedSame:
                isTimeExpired = false;
                NSLog(@"%@ is the same as %@", selectedDate, minAvailableDeliveyDate);
                break;
            default: NSLog(@"erorr dates %@, %@", selectedDate, minAvailableDeliveyDate); break;
        }
        
        if (isTimeExpired){
            isProceedToCheckOutPossible = false;
            [[cell btnChangeDate] setHidden:false];
        }else{
            [[cell btnChangeDate] setHidden:true];
        }
        
        
    }else{
        cell.lblGift.hidden = true;
    }
    
    
    

    return cell;
}

-(void)changeGiftDate: (UIButton*)sender {
    
//    //kolamazz . show gift delivert details page
    GiftDeliveryDetailsViewController *vc = [[GiftDeliveryDetailsViewController alloc]init];

    
    NSDictionary *productData = [[cartViewDetailsArray objectAtIndex:[sender tag]] valueForKey:@"product_details"];
    

    [[NSUserDefaults standardUserDefaults]setValue:timeForGiftDeliveryArray forKey:@"giftTimeArray"];
    [[NSUserDefaults standardUserDefaults]setValue: [productData valueForKey:@"delivery_date"] forKey:@"minimumAvailableDateForGiftDelivery"];//extra number of days needed for order delivery. add this much date with current date to get minimum possible delivery date
    [[NSUserDefaults standardUserDefaults]setValue: [productData valueForKey:@"delivery_time"] forKey:@"minimumAvailableTimeForGiftDelivery"];
    [[NSUserDefaults standardUserDefaults]setValue: [productData valueForKey:@"current_date"] forKey:@"currentDate"];
    //[[NSUserDefaults standardUserDefaults]setValue: _selectedProductId forKey:@"giftId"];

    [[NSUserDefaults standardUserDefaults]synchronize];

    [vc setModalPresentationStyle:UIModalPresentationFormSheet];
    
    currentlyEditingCartItemIndex = [sender tag];
    
    [self presentViewController:vc animated:true completion:nil];
    
    
}

-(NSDate *)convertStringToDate:(NSString *)dateString{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];

    return date;
}

//kolamazz
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
//    _cartTableView.layoutIfNeeded;
//    return UITableViewAutomaticDimension;
}

//MARK:- PICKER DELEGATES
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [qtyVal count];
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [qtyVal objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    int c = (int)[_qtyPicker selectedRowInComponent:0];
    NSString *val = [NSString stringWithFormat:@"%d",c+1];
    NSLog(@"tag>> %@",val);
    [(UITextField *)[self.view viewWithTag:txtTagVbl] setText:val];

    //[self addToCartActionIsBtnplus:YES];
}


//MARK:- MENU SWIPE
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




//MARK- POPUP MENU DELEGATES
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

    //Logout plist clear
    [Utility addtoplist:@"" key:@"login" plist:@"iq"];

    //Resetting 'skipped user' value
    [Utility addtoplist:@"NO"key:@"skippedUser" plist:@"iq"];

    [self.navigationController presentViewController:view animated:NO completion:nil];
}

@end
