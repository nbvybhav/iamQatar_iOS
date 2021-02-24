//
//  checkOutViewController.m
//  IamQatar
//
//  Created by alisons on 4/12/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import "checkOutViewController.h"
#import "itemCell.h"
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>
#import "AddAddressViewController.h"
#import "AddressViewController.h"
#import "PaymentViewController.h"
#import "Utility.h"
#import "categoryViewController.h"

@interface checkOutViewController ()
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;

    int       addressCount;
    id        detailsFetched;
    double    ProductTotalAmount;
    BOOL      statusOfdeliverySelection;
    NSArray * ArrayOFCartContents;
    NSArray * CarriersArray;
    NSArray * ProductArray;
    NSArray * producTypeArray;
    NSArray * addressArray;

    NSArray * contact;
    AppDelegate *cartAppDelegate;
    NSMutableDictionary *dictionarySelected;
    NSString *addressID;//delivery address id
    NSString *shippingID;//carrier id
    //NSString *deliveryAddressId;//billing address id
    NSString *deliveryCharge;
    NSIndexPath *selectedIndex;
    IBOutlet UIScrollView *mainScrollView;

}
@end

@implementation checkOutViewController

//MARK:- VIEW DIDLOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];

    self.title = @"CHECKOUT";
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
    
    //Resetting item count (else best buy wont show (1) item text)
     _PriceItemsLabel.text       = [NSString stringWithFormat:@"Sub Total"];

    //For removing last seperator line
    _DeleveryTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _DeleveryTableView.frame.size.width, 1)];
}

-(void)viewWillDisappear:(BOOL)animated{
    [Utility addtoplist:@"NO" key:@"fromCheckOut" plist:@"iq"];
}

- (void)viewWillAppear:(BOOL)animated
{
    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Checkout screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    [super viewWillAppear:YES];

    NSLog(@"paramRecieved:%@",_paramRecieved);

    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;

    cartAppDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;


    // -----_fromCheckOUt is flag for checking if it is coming from checkout viewcontroller or AddressViewController------
    // -----if not from checkout or AddressViewCont it should navigate to home-----

    NSString *status       = [Utility getfromplist:@"orderStatus" plist:@"iq"];
    NSString *fromcheckout = [NSString stringWithFormat:@"%@",[Utility getfromplist:@"fromCheckOut" plist:@"iq"]];

    //    if ([status isEqualToString:@"yes"]) {
    //        [Utility addtoplist:@"no" key:@"orderStatus" plist:@"iq"];
    //        categoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainCat"];
    //        [self.navigationController pushViewController:vc animated:NO];
    //    }
    //    else if(![fromcheckout isEqualToString:@"YES"]){
    //        categoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainCat"];
    //        [self.navigationController pushViewController:vc animated:NO];
    //    }
    //    else{
    
    
    
    deliveryCharge = @"";
//    [self getDetails];
    // }
}

-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame = CGRectMake(-290, 0, 275, deviceHieght);
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    //deliveryCharge = @"";
    [self getDetails];
    
}


//MARK:- METHODS
- (void)getDetails
{
    if ([Utility reachable]) {
       
        //--------------when reached by tapping buy now button--------------//
        if ([[_paramRecieved objectForKey:@"buy_now"]isEqualToString:@"yes"])
        {
            [ProgressHUD show];
            NSDictionary *parameters = @{@"user_id": [cartAppDelegate.userProfileDetails objectForKey:@"user_id"],
                                         @"product_id":[_paramRecieved objectForKey:@"product_id"],
                                         @"variant_id":[_paramRecieved objectForKey:@"variant_id"],
                                         @"quantity":[_paramRecieved objectForKey:@"quantity"],
                                         @"delivery_date":@""};
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,buyNowTotal] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
             [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,buyNowTotal] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 NSString *text = [responseObject objectForKey:@"text"];
                 self->detailsFetched = responseObject;
                 [self loadAddress];
                 
                 if ([text isEqualToString: @"Success!"])
                 {
                     NSLog(@"JSON: %@", responseObject);
                     self->ArrayOFCartContents = [responseObject objectForKey:@"count"];
                     self->CarriersArray       = [responseObject objectForKey:@"carriers"];
                     self->ProductArray        = [responseObject objectForKey:@"value"];
                     self->producTypeArray     = [[[responseObject objectForKey:@"value"]valueForKey:@"product_details"]valueForKey:@"type"];
                     
                     [self->_DeleveryTableView reloadData];
                     
                     self->_DeleveryTableView.frame = CGRectMake(self.DeleveryTableView.frame.origin.x, self.DeleveryTableView.frame.origin.y, self.view.frame.size.width, 67*[self->CarriersArray count]);

                     self->_viewForShipping.frame = CGRectMake(self->_viewForShipping.frame.origin.x, self->_viewForShipping.frame.origin.y, self->_viewForShipping.frame.size.width, self.DeleveryTableView.frame.origin.y + self->_DeleveryTableView.frame.size.height);
                     
                     [self.view layoutIfNeeded];
                     self->_viewForPrize.frame = CGRectMake(self.viewForPrize.frame.origin.x, self->_viewForShipping.frame.origin.y + self->_viewForShipping.frame.size.height, self.viewForPrize.frame.size.width, self.viewForPrize.frame.size.height);


                     self->_continueBtn.frame = CGRectMake(self->_continueBtn.frame.origin.x, self->_viewForPrize.frame.origin.y+self->_viewForPrize.frame.size.height-30, self->_continueBtn.frame.size.width, 40);
                     self->_TotalAmountMainOutlet.frame = CGRectMake(self->_TotalAmountMainOutlet.frame.origin.x, self->_viewForPrize.frame.origin.y+self->_viewForPrize.frame.size.height-30, self->_TotalAmountMainOutlet.frame.size.width, 45);
                     
                     
                     //------Fit scrollview based on the content-------//
                     self->mainScrollView.contentSize = CGSizeMake(320, self->_viewForPrize.frame.origin.y+self->_viewForPrize.frame.size.height+100);
                     
                     [self DisplayDetailsOfCartValue];
                 }
                 [ProgressHUD dismiss];
                 
             } failure:^(NSURLSessionTask *task, NSError *error) {
                 NSLog(@"Error: %@", error);
                 [ProgressHUD dismiss];
             }];
        }
         else
        {
            [ProgressHUD show];
            NSDictionary *parameters = @{@"user_id": [cartAppDelegate.userProfileDetails objectForKey:@"user_id"]};
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,getCartItems] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
             [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,getCartItems] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
            {
                NSString *text = [responseObject objectForKey:@"text"];
                 self->detailsFetched = responseObject;
                //[self loadAddress];
                
                if ([text isEqualToString: @"Success!"])
                {
                    NSLog(@"JSON: %@", responseObject);
                    self->ArrayOFCartContents = [responseObject objectForKey:@"count"];
                    self->CarriersArray       = [responseObject objectForKey:@"carriers"];
                    self->ProductArray        = [responseObject objectForKey:@"value"];
                    self->producTypeArray     = [[[responseObject  objectForKey:@"value"]valueForKey:@"product_details"]valueForKey:@"type"];
                    
                    [self->_DeleveryTableView reloadData];

                    //'Delivery address' tableview inside Shipping view
//                    _DeleveryTableView.frame = CGRectMake(self.DeleveryTableView.frame.origin.x, self.DeleveryTableView.frame.origin.y,_DeleveryTableView.frame.size.width, 67*[CarriersArray count]+20);
                    
//                    //KOLAMAZZ
//                    //billing address view
//                     _viewForBillingAddress.frame = CGRectMake(_viewForBillingAddress.frame.origin.x, _viewForDeliveryAddress.frame.origin.y + _viewForDeliveryAddress.frame.size.height + 12, _viewForShipping.frame.size.width, _viewForBillingAddress.frame.size.height);
//
                    
                    //Shipping view
                    //_viewForShipping.frame = CGRectMake(_viewForShipping.frame.origin.x, _viewForDeliveryAddress.frame.origin.y + _viewForDeliveryAddress.frame.size.height, _viewForShipping.frame.size.width, _DeleveryTableView.frame.origin.y + _DeleveryTableView.frame.size.height);
//                    _viewForShipping.frame = CGRectMake(_viewForShipping.frame.origin.x, _viewForBillingAddress.frame.origin.y + _viewForBillingAddress.frame.size.height, _viewForShipping.frame.size.width, _DeleveryTableView.frame.origin.y + _DeleveryTableView.frame.size.height);
//
//                    _viewForShipping.layer.masksToBounds = NO;
//                    _viewForShipping.layer.cornerRadius  = 8.0;
//                    _viewForShipping.backgroundColor = [UIColor whiteColor];
//                    [self.view layoutIfNeeded];
//
//                    _viewForShipping.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
//                    _viewForShipping.layer.masksToBounds = NO;
//                    _viewForShipping.clipsToBounds= NO;
//                    [_viewForShipping.layer setShadowOffset:CGSizeZero];
//                    [_viewForShipping.layer setShadowOpacity:6.0];
//
//                    [self.view layoutIfNeeded];

//                    if((int)[[UIScreen mainScreen] bounds].size.height ==  736.0){  //iPhone 6P
//                        //Label
//                        _lblShoppingSpeeds.frame = CGRectMake(_lblShoppingSpeeds.frame.origin.x, _viewForShipping.frame.origin.y + _viewForShipping.frame.size.height-20, _lblShoppingSpeeds.frame.size.width, _lblShoppingSpeeds.frame.size.height);
//                    }else{
//                        //Label
//                        _lblShoppingSpeeds.frame = CGRectMake(_lblShoppingSpeeds.frame.origin.x, _viewForShipping.frame.origin.y + _viewForShipping.frame.size.height-20, _lblShoppingSpeeds.frame.size.width, _lblShoppingSpeeds.frame.size.height);
//                    }
//                    //[_viewForShipping addSubview:_lblShoppingSpeeds];
//
//
//                    //Price view
//                    _viewForPrize.frame = CGRectMake(self.viewForPrize.frame.origin.x, _viewForShipping.frame.origin.y + _viewForShipping.frame.size.height, self.viewForPrize.frame.size.width, self.viewForPrize.frame.size.height);
//

//                    //Gradient for 'Continue' button
//                    UIColor *gradOneStartColor = [UIColor colorWithRed:244/255.f green:108/255.f blue:122/255.f alpha:1.0];
//                    UIColor *gradOneEndColor   = [UIColor colorWithRed:251/255.0 green:145/255.0 blue:86/255.0 alpha:1.0];
//
//                    _continueBtn.layer.masksToBounds = YES;
//                    _continueBtn.layer.cornerRadius  = 20;
//
//                    _continueBtn.frame = CGRectMake(_continueBtn.frame.origin.x, _viewForPrize.frame.origin.y+_viewForPrize.frame.size.height-30, _continueBtn.frame.size.width, 40);
//
//                    CAGradientLayer *gradientlayerTwo = [CAGradientLayer layer];
//                    gradientlayerTwo.frame = _continueBtn.bounds;
//                    gradientlayerTwo.startPoint = CGPointZero;
//                    gradientlayerTwo.endPoint = CGPointMake(1, 1);
//                    gradientlayerTwo.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];
//
//                    [_continueBtn.layer insertSublayer:gradientlayerTwo atIndex:0];
//
//
//                    //------Fit scrollview based on the content-------//
//                    mainScrollView.contentSize = CGSizeMake(320, _viewForPrize.frame.origin.y+_viewForPrize.frame.size.height+100);
                    
//                    [self DisplayDetailsOfCartValue];
                    
                    [self loadAddress];
                }
                [ProgressHUD dismiss];
                
            } failure:^(NSURLSessionTask *task, NSError *error) {
                NSLog(@"Error: %@", error);
                [ProgressHUD dismiss];
            }];
        }
    }
    else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}


-(void)loadAddress
{
    _AddressOutlet.numberOfLines = 0;
    //[_AddressOutlet sizeToFit];

    //Gradient for 'change address' button
    UIColor *gradOneStartColor = [UIColor colorWithRed:244/255.f green:108/255.f blue:122/255.f alpha:1.0];
    UIColor *gradOneEndColor   = [UIColor colorWithRed:251/255.0 green:145/255.0 blue:86/255.0 alpha:1.0];

    _addressBtn.layer.masksToBounds = YES;
    _addressBtn.layer.cornerRadius  = 12.0;

    _addressBtn.frame = CGRectMake(_addressBtn.frame.origin.x, _addressBtn.frame.origin.y, _addressBtn.frame.size.width, _addressBtn.frame.size.height);
    CAGradientLayer *gradientlayer = [CAGradientLayer layer];
    gradientlayer.frame = _addressBtn.bounds;
    gradientlayer.startPoint = CGPointZero;
    gradientlayer.endPoint = CGPointMake(1, 1);
    gradientlayer.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];
    [_addressBtn.layer insertSublayer:gradientlayer atIndex:1];
    _addressBtn.titleLabel.textColor = [UIColor whiteColor];

    
    _btnChangeBillingAddress.layer.masksToBounds = YES;
    _btnChangeBillingAddress.layer.cornerRadius  = 12.0;
    
    _btnChangeBillingAddress.frame = CGRectMake(_btnChangeBillingAddress.frame.origin.x, _btnChangeBillingAddress.frame.origin.y, _btnChangeBillingAddress.frame.size.width, 25);
    CAGradientLayer *gradientlayer2 = [CAGradientLayer layer];
    gradientlayer2.frame = _btnChangeBillingAddress.bounds;
    gradientlayer2.startPoint = CGPointZero;
    gradientlayer2.endPoint = CGPointMake(1, 1);
    gradientlayer2.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];
    [_btnChangeBillingAddress.layer insertSublayer:gradientlayer2 atIndex:0];
    _btnChangeBillingAddress.titleLabel.textColor = [UIColor whiteColor];
    [_btnChangeBillingAddress setTitle:@"Change address" forState:UIControlStateNormal];

    if ([dictionarySelected count] > 0) {
        addressCount = 1;
        _AddressOutlet.textColor     = [UIColor lightGrayColor];
        _AddressOutlet.font          = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
        _AddressOutlet.textAlignment =  NSTextAlignmentLeft;
        //_NameOutlet.text             = [dictionarySelected valueForKey:@"full_name"];
        addressID                    = [NSString stringWithFormat:@"%@",[dictionarySelected valueForKey:@"id"]];

        NSString *multiLineString    = [NSString stringWithFormat:@"%@\n%@\n%@",[dictionarySelected valueForKey:@"building_name"],[dictionarySelected valueForKey:@"house_no"],[dictionarySelected valueForKey:@"street"]];
        _AddressOutlet.text = multiLineString;

        [_addressBtn setTitle:@"Change address" forState:UIControlStateNormal];
        _addressBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
        
//        //KOLAMAZZ
//        //billing address view
//        _viewForBillingAddress.frame = CGRectMake(_viewForBillingAddress.frame.origin.x, _viewForDeliveryAddress.frame.origin.y + _viewForDeliveryAddress.frame.size.height + 12, _viewForShipping.frame.size.width, 100);
//
//        [_viewForBillingAddress setHidden:false];
//        [[self view] layoutIfNeeded];
        
        NSDictionary *selectedBillingAddress = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SELECTED_BILLING_ADDRESS"];
        if ([selectedBillingAddress count] == 0){
           
            NSLog(@"billing address not selected");
            //add shipping address as billing address
            [[NSUserDefaults standardUserDefaults] setObject:dictionarySelected forKey:@"SELECTED_BILLING_ADDRESS"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }

    }
    else if([[[detailsFetched objectForKey:@"address"]objectForKey:@"delivery_address"]count]>0)
    {
         addressCount = 1;
        _AddressOutlet.textColor     = [UIColor lightGrayColor];
        _AddressOutlet.font          = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
        _AddressOutlet.textAlignment =  NSTextAlignmentLeft;
        
        addressArray                 = [[[detailsFetched objectForKey:@"address"]objectForKey:@"delivery_address"]objectAtIndex:0];
        //_NameOutlet.text             = [addressArray valueForKey:@"full_name"];
        addressID                    = [NSString stringWithFormat:@"%@",[addressArray valueForKey:@"id"]];


        NSString *multiLineString    = [NSString stringWithFormat:@"%@\n%@\n%@",[addressArray valueForKey:@"building_name"],[addressArray valueForKey:@"house_no"],[addressArray valueForKey:@"street"]];
        _AddressOutlet.text = multiLineString;
        [_addressBtn setTitle:@"Change address" forState:UIControlStateNormal];
        _addressBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        NSDictionary *selectedBillingAddress = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SELECTED_BILLING_ADDRESS"];
        if ([selectedBillingAddress count] == 0){
            
            [[NSUserDefaults standardUserDefaults] setObject:addressArray forKey:@"SELECTED_BILLING_ADDRESS"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        
    }
    else{
        addressCount = 0;
        _AddressOutlet.textColor     = [UIColor lightGrayColor];
        _AddressOutlet.textAlignment = NSTextAlignmentCenter;
        _AddressOutlet.font          = [UIFont fontWithName:@"Helvetica Neue Bold" size:20.0];
        _AddressOutlet.text          = @"No address added!";
        //_NameOutlet.text             = @"";
         [_addressBtn setTitle:@"Add address" forState:UIControlStateNormal];
        _addressBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        NSDictionary *emptyDict;
        [[NSUserDefaults standardUserDefaults] setObject:emptyDict forKey:@"SELECTED_BILLING_ADDRESS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    
    
    //kolamazz
    
    _DeleveryTableView.frame = CGRectMake(self.DeleveryTableView.frame.origin.x, self.DeleveryTableView.frame.origin.y,_DeleveryTableView.frame.size.width, 67*[CarriersArray count]+20);

    
    NSDictionary *selectedBillingAddress = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SELECTED_BILLING_ADDRESS"];
    if ([selectedBillingAddress count] > 0){
        //NSLog(@"i am kolamazz");
        
        //KOLAMAZZ
        //billing address view
        [[self view] layoutIfNeeded];
   
        NSString *multiLineString    = [NSString stringWithFormat:@"%@\n%@\n%@",[selectedBillingAddress valueForKey:@"building_name"],[selectedBillingAddress valueForKey:@"house_no"],[selectedBillingAddress valueForKey:@"street"]];
        _lblBillingAddress.text = multiLineString;
        
//        [[self view] layoutIfNeeded];
//        _viewForBillingAddress.frame = CGRectMake(_viewForBillingAddress.frame.origin.x, _viewForDeliveryAddress.frame.origin.y + _viewForDeliveryAddress.frame.size.height + 12, _viewForShipping.frame.size.width, 250);//_lblBillingAddress.frame.origin.y + _lblBillingAddress.frame.size.height + 20);
        [_viewForBillingAddress setHidden:false];
        
        
        _viewForShipping.frame = CGRectMake(_viewForShipping.frame.origin.x, _viewForBillingAddress.frame.origin.y + _viewForBillingAddress.frame.size.height, _viewForShipping.frame.size.width, _DeleveryTableView.frame.origin.y + _DeleveryTableView.frame.size.height);
        
        
        [self.view layoutIfNeeded];
        
        
        [[self view] layoutIfNeeded];
        
        _lblBillingAddress.textColor     = [UIColor lightGrayColor];
        _lblBillingAddress.font          = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
        _lblBillingAddress.textAlignment =  NSTextAlignmentLeft;
        
        
        [[self view] layoutIfNeeded];
        
        
        
    }else{
        
        //KOLAMAZZ
        //billing address view
        //_viewForBillingAddress.frame = CGRectMake(_viewForBillingAddress.frame.origin.x, _viewForDeliveryAddress.frame.origin.y + _viewForDeliveryAddress.frame.size.height + 12, _viewForShipping.frame.size.width, 0);
        
        _viewForShipping.frame = CGRectMake(_viewForShipping.frame.origin.x, _viewForDeliveryAddress.frame.origin.y + _viewForDeliveryAddress.frame.size.height, _viewForShipping.frame.size.width, _DeleveryTableView.frame.origin.y + _DeleveryTableView.frame.size.height+35);
        
        [[self view] layoutIfNeeded];
        
        [[self view] layoutIfNeeded];
        
        _lblBillingAddress.textColor     = [UIColor lightGrayColor];
        _lblBillingAddress.font          = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
        _lblBillingAddress.textAlignment =  NSTextAlignmentLeft;
        
        [_viewForBillingAddress setHidden:true];
        
        
    }
    
    //_viewForShipping.frame = CGRectMake(_viewForShipping.frame.origin.x, _viewForDeliveryAddress.frame.origin.y + _viewForDeliveryAddress.frame.size.height, _viewForShipping.frame.size.width, _DeleveryTableView.frame.origin.y + _DeleveryTableView.frame.size.height);
    
    _viewForShipping.layer.masksToBounds = NO;
    _viewForShipping.layer.cornerRadius  = 8.0;
    _viewForShipping.backgroundColor = [UIColor whiteColor];
    [self.view layoutIfNeeded];
    
    _viewForShipping.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    _viewForShipping.layer.masksToBounds = NO;
    _viewForShipping.clipsToBounds= NO;
    [_viewForShipping.layer setShadowOffset:CGSizeZero];
    [_viewForShipping.layer setShadowOpacity:6.0];
    
    
    if((int)[[UIScreen mainScreen] bounds].size.height ==  736.0){  //iPhone 6P
        //Label
        _lblShoppingSpeeds.frame = CGRectMake(_lblShoppingSpeeds.frame.origin.x, _viewForShipping.frame.origin.y + _viewForShipping.frame.size.height-20, _lblShoppingSpeeds.frame.size.width, _lblShoppingSpeeds.frame.size.height);
    }else{
        //Label
        _lblShoppingSpeeds.frame = CGRectMake(_lblShoppingSpeeds.frame.origin.x, _viewForShipping.frame.origin.y + _viewForShipping.frame.size.height-20, _lblShoppingSpeeds.frame.size.width, _lblShoppingSpeeds.frame.size.height);
    }
    //[_viewForShipping addSubview:_lblShoppingSpeeds];
    
    
    //Price view
    _viewForPrize.frame = CGRectMake(self.viewForPrize.frame.origin.x, _viewForShipping.frame.origin.y + _viewForShipping.frame.size.height, self.viewForPrize.frame.size.width, self.viewForPrize.frame.size.height);
    
    //Gradient for 'Continue' button
    UIColor *gradOneStartColor3 = [UIColor colorWithRed:244/255.f green:108/255.f blue:122/255.f alpha:1.0];
    UIColor *gradOneEndColor3   = [UIColor colorWithRed:251/255.0 green:145/255.0 blue:86/255.0 alpha:1.0];
    
    _continueBtn.layer.masksToBounds = YES;
    _continueBtn.layer.cornerRadius  = 20;
    
    _continueBtn.frame = CGRectMake(_continueBtn.frame.origin.x, _viewForPrize.frame.origin.y+_viewForPrize.frame.size.height-30, _continueBtn.frame.size.width, 40);
    
    CAGradientLayer *gradientlayerTwo = [CAGradientLayer layer];
    gradientlayerTwo.frame = _continueBtn.bounds;
    gradientlayerTwo.startPoint = CGPointZero;
    gradientlayerTwo.endPoint = CGPointMake(1, 1);
    gradientlayerTwo.colors = [NSArray arrayWithObjects:(id)gradOneStartColor3.CGColor,(id)gradOneEndColor3.CGColor, nil];
    
    [_continueBtn.layer insertSublayer:gradientlayerTwo atIndex:0];
    
    
    //------Fit scrollview based on the content-------//
    mainScrollView.contentSize = CGSizeMake(320, _viewForPrize.frame.origin.y+_viewForPrize.frame.size.height+100);

    [[self view] layoutIfNeeded];
    [[self view] layoutIfNeeded];
    [self DisplayDetailsOfCartValue];
    
    [[self view] layoutIfNeeded];
    [[self view] layoutIfNeeded];
    [[self view] layoutIfNeeded];
    
    
}


- (IBAction)continueAction:(id)sender
{
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   
    if ([CarriersArray count]>0) {
        
        if ([deliveryCharge isEqual:@""]||!deliveryCharge)
        {
            [AlertController alertWithMessage:@"Select your delivery service!" presentingViewController:self];
        }
        else
        {
            if (addressCount == 0) {
                AddAddressViewController *myVC = (AddAddressViewController *)[storyboard instantiateViewControllerWithIdentifier:@"addAddressView"];
                [self.navigationController pushViewController:myVC animated:YES] ;
            }
            else
            {
                PaymentViewController *myVC = (PaymentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"paymentView"];
                NSDictionary *passingDict = [[NSMutableDictionary alloc]init];
                
                NSDictionary *selectedBillingAddress = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SELECTED_BILLING_ADDRESS"];
                NSString *billingAddressId = [selectedBillingAddress valueForKey:@"id"];
                NSLog(@"%@",billingAddressId);
               
                
                //kolamazz
                
                if ([[_paramRecieved objectForKey:@"buy_now"]isEqualToString:@"yes"])
                {
                    passingDict = @{@"user_id": [cartAppDelegate.userProfileDetails objectForKey:@"user_id"],
                                    @"billing_id":addressID,
                                    @"shipping_id":shippingID,
                                    @"item_Qty":@"",
                                    @"total_amount":[NSString stringWithFormat:@"%0.2f",ProductTotalAmount],
                                    @"delivery_charge":deliveryCharge,
                                    @"product_type":producTypeArray,
                                    @"product_id":[_paramRecieved objectForKey:@"product_id"],
                                    @"variant_id":[_paramRecieved objectForKey:@"variant_id"],
                                    @"buy_now":@"yes",
                                    @"saved_amount":_savedAmount};
                }
                else
                {
                    passingDict = @{@"user_id": [cartAppDelegate.userProfileDetails objectForKey:@"user_id"],
                                    @"billing_id":addressID,
                                    @"shipping_id":shippingID,
                                    @"item_Qty":[ArrayOFCartContents valueForKey:@"totalitems"],
                                    @"total_amount":[NSString stringWithFormat:@"%0.2f",ProductTotalAmount],
                                    @"delivery_charge":deliveryCharge,
                                    @"product_type":producTypeArray,
                                    @"saved_amount":_savedAmount};
                }
                 myVC.paymentDetailsRecieved = passingDict;
                [self.navigationController pushViewController:myVC animated:YES] ;
            }
       }
    }else{
        [AlertController alertWithMessage:@"Sorry, no carriers available right now!" presentingViewController:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];

    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(0, 625, 275, 335);
}

//Delegate method of AddressViewcontroller
-(void)sendDataToCheckOutView:selectedDic
{
    dictionarySelected = selectedDic;
}
- (IBAction)changeBillingAddressAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressViewController *nextVc = (AddressViewController *)[storyboard instantiateViewControllerWithIdentifier:@"addressView"];
    //myVC.Datadelegate = self;
    nextVc.isBillingAddress = true;
    [self.navigationController pushViewController:nextVc animated:YES];
    
}

- (IBAction)changeAddressAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (addressCount == 0) {
        AddAddressViewController *myVC = (AddAddressViewController *)[storyboard instantiateViewControllerWithIdentifier:@"addAddressView"];
        [self.navigationController pushViewController:myVC animated:YES];
    }else{
        AddressViewController *myVC = (AddressViewController *)[storyboard instantiateViewControllerWithIdentifier:@"addressView"];
        myVC.Datadelegate = self;
        myVC.isBillingAddress = false;
        [self.navigationController pushViewController:myVC animated:YES] ;
    }
    
}

- (void)radioButton:(UIButton *)sender
{
    UIButton *button       = (UIButton *)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    selectedIndex          = indexPath;
    [_DeleveryTableView reloadData];

    itemCell * cell = [_DeleveryTableView cellForRowAtIndexPath:indexPath];
    NSString *rate = [[CarriersArray objectAtIndex:indexPath.row]valueForKey:@"delivery_charge"];
    _DeleveryChargeOutlet.text = [NSString stringWithFormat:@"QAR %@",rate];
    double rateAmount = [rate doubleValue];
    double GrandTotal = rateAmount + ProductTotalAmount;

    
    _TotalAmoutOutlet.text      = [NSString stringWithFormat:@"QAR %0.2f", GrandTotal];
    _TotalAmountMainOutlet.text = [NSString stringWithFormat:@"QAR %0.2f", GrandTotal];
    cell.radioBtn.selected      = YES;
    shippingID                  = [[CarriersArray valueForKey:@"ship_id"]objectAtIndex:indexPath.row];
    deliveryCharge              = [[CarriersArray objectAtIndex:selectedIndex.row]valueForKey:@"delivery_charge"];

    statusOfdeliverySelection = 1;
}



#pragma mark - LAYOUT
-(void)viewDidLayoutSubviews
{
    
}

//MARK:- TABLE VIEW DELEGATES
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CarriersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    itemCell *cell;
    cell = [self.DeleveryTableView dequeueReusableCellWithIdentifier:@"itemCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"itemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,[[CarriersArray objectAtIndex:indexPath.row] objectForKey:@"image"]];
    
    NSURL *imageURL = [NSURL URLWithString:urlString];
    [cell.DeleverySupplyierImage sd_setImageWithURL:imageURL];
     cell.radioBtn.selected   = NO;
    [cell.radioBtn addTarget:self action:@selector(radioButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.radioBtn.tag = indexPath.row;

    [cell.radioBtn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [cell.radioBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    
    cell.NameOfCourier.text         = [[CarriersArray objectAtIndex:indexPath.row]valueForKey:@"carrier_name"];
    cell.DeleveryDescription.text   = [[CarriersArray objectAtIndex:indexPath.row]valueForKey:@"carrier_name"];
    NSString *str                   = [[CarriersArray objectAtIndex:indexPath.row]valueForKey:@"delivery_period_str"];
    cell.DeleveryOption.text        = [NSString stringWithFormat: @"%@", str];

//    if([str integerValue]>0){
//         cell.DeleveryOption.text        = [NSString stringWithFormat: @"%@ Buisiness Days", str];
//    }else{
//         cell.DeleveryOption.text        = [NSString stringWithFormat: @"Same Day"];
//    }

    cell.OrderDetails.text          = [NSString stringWithFormat: @"QAR %@", [[CarriersArray objectAtIndex:indexPath.row]valueForKey:@"delivery_charge"]];
    cell.contentView.clipsToBounds = YES;
    return cell;
}

#pragma mark - CartUpdate
-(void)DisplayDetailsOfCartValue
{
    double totalAmount = 0;
    
    for (int i = 0; i<ProductArray.count; i++)
    {
        NSString *rateOFProduct = [[[ProductArray objectAtIndex:i] valueForKey:@"product_details"]valueForKey:@"total"];
        NSLog(@"%@",rateOFProduct);
        double TotalRate = [rateOFProduct floatValue];
        totalAmount      = totalAmount + TotalRate;
        NSLog(@"%f",totalAmount);
    }
    
    NSLog(@"%f",totalAmount);
    ProductTotalAmount = totalAmount;
    
    _ProductTotalCount.text     = [NSString stringWithFormat:@"QAR %0.2f", totalAmount];

    float savedAmntFloat        = [_savedAmount floatValue];
    savedAmntFloat              = floor (savedAmntFloat);

        if(savedAmntFloat == 0)
        {
            _lblTotalSaved.hidden = YES;
            _lblTotalSavedHeading.hidden = YES;
        }else{
            _lblTotalSaved.hidden = NO;
            _lblTotalSavedHeading.hidden = NO;
            _lblTotalSaved.text         = [NSString stringWithFormat:@"QAR %0.2f", savedAmntFloat];
        }



    if (![[_paramRecieved objectForKey:@"buy_now"]isEqualToString:@"yes"])
    {
     _PriceItemsLabel.text       = [NSString stringWithFormat:@"Sub Total"];
    }
    _DeleveryChargeOutlet.text  = @"QAR 0.00";
    _TotalAmoutOutlet.text      = [NSString stringWithFormat:@"QAR %0.2f", totalAmount];
    _TotalAmountMainOutlet.text = [NSString stringWithFormat:@"QAR %0.2f", totalAmount];

}



//MARK:- TABBAR DELEGATES
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
