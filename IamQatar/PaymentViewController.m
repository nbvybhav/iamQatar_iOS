////
////  PaymentViewController.m
////  IamQatar
////
////  Created by alisons on 4/21/17.
////  Copyright © 2017 alisons. All rights reserved.
////
//
//#import "PaymentViewController.h"
//#import "constants.pch"
//#import "MainCategoryViewController.h"
//#import "Utility.h"
//#import <PayFortSDK/PayFortSDK.h>
//#import <CommonCrypto/CommonCrypto.h>
//
//@interface PaymentViewController () <PopMenuDelegate,UITabBarControllerDelegate,UITabBarDelegate>
//{
//    NSMutableData *webDataglobal;
//    NSString *sdk_token;
//    PayFortController *payFort;
//    NSString *paymentType;
//    double totalAmount;
//    NSString *deliveryCharge ;
//    NSString *orderId;
//    id payfortResponse;
//    AppDelegate *cartAppDelegate;
//
//    Menu *menu;
//    UITapGestureRecognizer * menuHideTap;
//    BOOL isSelected;
//    int deviceHieght;
//}
//@end
//
//@implementation PaymentViewController
//
////MARK:- VIEW DIDLOAD
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
//    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
//
//    deviceHieght = [[UIScreen mainScreen] bounds].size.height;
//
//    NSString *hello = @"PaymentViewController";
//    NSLog(@"%@",hello);
//
//    //--------setting menu frame---------//
//    isSelected = NO;
//    menu= [[Menu alloc]init];
//    NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"Menu" owner:self options:nil];
//    menu = [nib1 objectAtIndex:0];
//    menu.frame=CGRectMake(-290, 0, 275,deviceHieght);
//    menu.delegate = self;
//    [self.tabBarController.view addSubview:menu];
//    menuHideTap.enabled = NO;
//        [menu setHidden:YES];
//
//    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
//    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:swipeleft];
//
//    menuHideTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
//    [self.view addGestureRecognizer:menuHideTap];
//    menuHideTap.enabled = NO;
//
//    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
//    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swiperight];
//
//
//    [self setUpLoadItems];
//    // Do any additional setup after loading the view.
//
//    //-----Payfort init------//
//    payFort     = [[PayFortController alloc]initWithEnviroment:KPayFortEnviromentSandBox];
//
//    paymentType = @"COD";
//
//    //-------Code for hiding COD option when cart contains any gift item--------
//    _hidingView.hidden = YES;
//    NSArray *productTypeRecieved = [_paymentDetailsRecieved objectForKey:@"product_type"];
//
//    for (int i=0; i<[productTypeRecieved count]; i++) {
//        if([[productTypeRecieved objectAtIndex:i]isEqualToString:@"gift"])
//        {
//            _hidingView.hidden = NO;
//            break;
//        }
//    }
//
//    //-------hiding coupon code details displaying controles----------//
//    _lblcoupon.hidden      = YES;
//    _lblCouponPrice.hidden = YES;
//    _btnRemove.hidden      = YES;
//
//
//    //Gradient for 'Apply' button
//    UIColor *gradOneStartColor = [UIColor colorWithRed:244/255.f green:108/255.f blue:122/255.f alpha:1.0];
//    UIColor *gradOneEndColor   = [UIColor colorWithRed:251/255.0 green:145/255.0 blue:86/255.0 alpha:1.0];
//
//    _btnApply.layer.masksToBounds = YES;
//    _btnApply.layer.cornerRadius  = 15.0;
//
//    _btnApply.frame = CGRectMake(_btnApply.frame.origin.x, _btnApply.frame.origin.y, _btnApply.frame.size.width, _btnApply.frame.size.height);
//    CAGradientLayer *gradientlayer = [CAGradientLayer layer];
//    gradientlayer.frame = _btnApply.bounds;
//    gradientlayer.startPoint = CGPointZero;
//    gradientlayer.endPoint = CGPointMake(1, 1);
//    gradientlayer.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];
//
//    [_btnApply.layer insertSublayer:gradientlayer atIndex:0];
//
//     //Gradient for 'Place Order' button
//    _btnPlaceOrder.layer.masksToBounds = YES;
//    _btnPlaceOrder.layer.cornerRadius  = 15.0;
//
//    _btnPlaceOrder.frame = CGRectMake(_btnPlaceOrder.frame.origin.x, _btnPlaceOrder.frame.origin.y, _btnPlaceOrder.frame.size.width, _btnPlaceOrder.frame.size.height);
//    CAGradientLayer *gradientlayerTwo = [CAGradientLayer layer];
//    gradientlayerTwo.frame = _btnPlaceOrder.bounds;
//    gradientlayerTwo.startPoint = CGPointZero;
//    gradientlayerTwo.endPoint = CGPointMake(1, 1);
//    gradientlayerTwo.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];
//
//    [_btnPlaceOrder.layer insertSublayer:gradientlayerTwo atIndex:0];
//
//    //Selected payment highlighting
//    //[_btnCod setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];
//    [_btnCod setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
//    [_btnCardPayment setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];
//    [_btnCardPayment setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
//    _btnCardPayment.selected = NO;
//    _btnCod.selected = YES;
//}
//
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//
////    menuHideTap.enabled = NO;
//        [menu setHidden:YES];
////    isSelected = NO;
////    menu.frame=CGRectMake(0, 625, 275, 335);
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    //Google Analytics tracker
//    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//    [tracker set:kGAIScreenName value:@"Payment screen"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//
//    //-----showing tabar item at index 4 (back button)-------//
//    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
//    self.tabBarController.delegate = self;
//
//    cartAppDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    menuHideTap.enabled = NO;
//        [menu setHidden:YES];
//    isSelected = NO;
//    menu.frame = CGRectMake(-290, 0, 275, deviceHieght);
//}
//
////MARK:- MENU SWIPE METHODS
//
////---------------Menu swipe---------------ß
//-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
//{
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self->menu.frame=CGRectMake(-290, 0, 275, self->deviceHieght);
//        self->isSelected = NO;
//    } completion:^(BOOL finished){
//        // if you want to do something once the animation finishes, put it here
//        self->menuHideTap.enabled = NO;
//        [self->menu setHidden:YES];
//    }];
//}
//
//-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
//{
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [self->menu setHidden:NO];
//        self->menuHideTap.enabled = YES;
//        self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
//        self->isSelected = YES;
//    } completion:^(BOOL finished){
//        // if you want to do something once the animation finishes, put it here
//    }];
//}
//
////MARK:- METHODS
//-(void)setUpLoadItems
//{
//    NSLog(@"detailsRecieved %@",_paymentDetailsRecieved);
//
//    if ([[_paymentDetailsRecieved objectForKey:@"buy_now"]isEqualToString:@"yes"])
//    {
//         _qtyTxt.text             = [NSString stringWithFormat:@"Sub Total"];
//    }else{
//         _qtyTxt.text             = [NSString stringWithFormat:@"Sub Total"];
//    }
//
//   NSString *Amount                   = [NSString stringWithFormat:@"%@",[_paymentDetailsRecieved valueForKey:@"total_amount"]];
//   NSString *TotalSaved                   = [NSString stringWithFormat:@"%@",[_paymentDetailsRecieved valueForKey:@"saved_amount"]];
//    float totalSavedFloat = [TotalSaved floatValue];
//
//   float amntFloat                = [Amount floatValue];
//   deliveryCharge = [NSString stringWithFormat:@"%@",[_paymentDetailsRecieved valueForKey:@"delivery_charge"]];
//    totalAmount              =  amntFloat+[deliveryCharge floatValue];
//
//    _priceTxt.text           = [NSString stringWithFormat:@"QAR %0.2f",amntFloat];
//    _lblTotalSaved.text      = [NSString stringWithFormat:@"QAR %0.2f",totalSavedFloat];
//    _deliverChargeTxt.text   = [NSString stringWithFormat:@"QAR %0.2f",[deliveryCharge floatValue]];
//    _amountPayableTxt.text   = [NSString stringWithFormat:@"QAR %0.2f",totalAmount];
//    _grantTotal.text         = [NSString stringWithFormat:@"QAR %0.2f",totalAmount];
//
//    totalSavedFloat              = floor (totalSavedFloat);
//
//    if(totalSavedFloat == 0)
//    {
//        _lblTotalSaved.hidden = YES;
//        _lblTotalSavedHeading.hidden = YES;
//    }else{
//        _lblTotalSaved.hidden = NO;
//        _lblTotalSavedHeading.hidden = NO;
//        _lblTotalSaved.text         = [NSString stringWithFormat:@"QAR %0.2f", totalSavedFloat];
//    }
//}
//
//- (IBAction)placeOrder:(id)sender
//{
// if ([Utility reachable])
//   {
//    //------when product buy now option tapped------------//
//    if ([[_paymentDetailsRecieved objectForKey:@"buy_now"]isEqualToString:@"yes"])
//    {
//        if ([paymentType isEqualToString:@"COD"])
//        {
//            [ProgressHUD show];
//            NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,buyNow];
//            NSDictionary *parameters;
//
//            NSDictionary *selectedBillingAddress = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SELECTED_BILLING_ADDRESS"];
//            NSString *deliveryAddressID  = [NSString stringWithFormat:@"%@",[selectedBillingAddress valueForKey:@"id"]];
//
//            parameters = @{@"user_id": [_paymentDetailsRecieved objectForKey:@"user_id"],
//                           @"shipping_id":[_paymentDetailsRecieved objectForKey:@"shipping_id"],//carrier id
//                           @"billing_id":[_paymentDetailsRecieved objectForKey:@"billing_id"],//shipping address id
//                           @"delivery_address_id":deliveryAddressID,//billing address id
//                           @"comment":@"",
//                           @"coupon_code":_txtCoupon.text,
//                           @"product_id":[_paymentDetailsRecieved objectForKey:@"product_id"],
//                           @"variant_id":[_paymentDetailsRecieved objectForKey:@"variant_id"],
//                           @"payment_type":paymentType};
//
//            NSLog(@"%@", [parameters description]);
//
////            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//            [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
//             {
//                 NSString *text = [responseObject objectForKey:@"code"];
//                 //orderId        = [responseObject objectForKey:@"value"];
//
//                 if ([text isEqualToString: @"200"])
//                 {
//                     [ProgressHUD dismiss];
//                     [Utility addtoplist:@"0" key:@"cartCount" plist:@"iq"];
//
//                     UIAlertController * alert = [UIAlertController
//                                                  alertControllerWithTitle:@"IamQatar"
//                                                  message:@"Order successfully placed!"
//                                                  preferredStyle:UIAlertControllerStyleAlert];
//
//
//
//                     UIAlertAction* OkButton = [UIAlertAction
//                                                 actionWithTitle:@"Ok"
//                                                 style:UIAlertActionStyleDefault
//                                                 handler:^(UIAlertAction * action) {
//                                                       [self pushAfterDismiss];
//                                                 }];
//
//
//                     //save empty dict to selected billing address userdefaults
//                     NSDictionary *emptyDict;
//                     [[NSUserDefaults standardUserDefaults] setObject:emptyDict forKey:@"SELECTED_BILLING_ADDRESS"];
//                     [[NSUserDefaults standardUserDefaults] synchronize];
//
//
//                     [alert addAction:OkButton];
//                     [self presentViewController:alert animated:YES completion:nil];
//                 }
//                 [ProgressHUD dismiss];
//                 NSLog(@"JSON: %@", responseObject);
//
//             } failure:^(NSURLSessionTask *task, NSError *error) {
//                 NSLog(@"Error: %@", error);
//                 [ProgressHUD dismiss];
//             }];
//        }
//        else
//        {
//            [self payFortPay];
//        }
//    }
//     else     //-----buying from cart
//    {
//        if ([paymentType isEqualToString:@"COD"])
//        {
//                [ProgressHUD show];
//                 NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,placeOrderAPI];
//                 NSDictionary *parameters;
//
//                NSDictionary *selectedBillingAddress = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SELECTED_BILLING_ADDRESS"];
//                NSString *deliveryAddressID  = [NSString stringWithFormat:@"%@",[selectedBillingAddress valueForKey:@"id"]];
//
//                parameters = @{@"user_id": [_paymentDetailsRecieved objectForKey:@"user_id"],
//                                @"shipping_id":[_paymentDetailsRecieved objectForKey:@"shipping_id"],//carrier id
//                                @"billing_id":[_paymentDetailsRecieved objectForKey:@"billing_id"],//shipping address id
//                                @"delivery_address_id":deliveryAddressID,//billing address id
//                                @"payment_type":paymentType};
//
//                NSLog(@"%@",deliveryAddressID);
//
//                //NSLog([parameters description]);
//
//
////                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//                [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
//                 {
//                     NSString *text = [responseObject objectForKey:@"code"];
//                     //orderId        = [responseObject objectForKey:@"value"];
//
//                     if ([text isEqualToString: @"200"])
//                     {
//                         [ProgressHUD dismiss];
//
//                         //save empty dict to selected billing address userdefaults
//                         NSDictionary *emptyDict;
//                         [[NSUserDefaults standardUserDefaults] setObject:emptyDict forKey:@"SELECTED_BILLING_ADDRESS"];
//                         [[NSUserDefaults standardUserDefaults] synchronize];
//
//                         [Utility addtoplist:@"0" key:@"cartCount" plist:@"iq"];
//
//                         UIAlertController * alert = [UIAlertController
//                                                      alertControllerWithTitle:@"IamQatar"
//                                                      message:@"Order successfully placed!"
//                                                      preferredStyle:UIAlertControllerStyleAlert];
//
//                         UIAlertAction* OkButton = [UIAlertAction
//                                                    actionWithTitle:@"Ok"
//                                                    style:UIAlertActionStyleDefault
//                                                    handler:^(UIAlertAction * action) {
//                                                        [self pushAfterDismiss];
//                                                    }];
//
//
//
//
//                         [alert addAction:OkButton];
//                         [self presentViewController:alert animated:YES completion:nil];
//                     }
//                      [ProgressHUD dismiss];
//                      NSLog(@"JSON: %@", responseObject);
//
//                  } failure:^(NSURLSessionTask *task, NSError *error) {
//                      NSLog(@"Error: %@", error);
//                      [ProgressHUD dismiss];
//                  }];
//        }
//         else
//        {
//            [self payFortPay];
//        }
//       }
//   }
//   else
//   {
//       [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
//   }
//}
//
//
//-(void)pushAfterDismiss{
//
//    OrderHistoryViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
//    UINavigationController *navController = self.navigationController;
//    // Pop this controller and replace with another
//    [navController popViewControllerAnimated:NO];//not to see pop
//    [navController pushViewController:view animated:NO];
//}
//
//-(void)payFortPay{
//    //-----------Payfort payment token request-------------//
//    NSMutableString *post = [NSMutableString string];
//    [post appendFormat:@"TESTSHAINaccess_code=%@", @"kU4Ma4qFtGDMTF2ykzE7"];
//    [post appendFormat:@"device_id=%@",  [payFort getUDID]];
//    [post appendFormat:@"language=%@", @"en"];
//    [post appendFormat:@"merchant_identifier=%@", @"WtmIeIXk"];
//    [post appendFormat:@"service_command=%@", @"SDK_TOKENTESTSHAIN"];
//
//    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
//                         @"SDK_TOKEN", @"service_command",
//                         @"WtmIeIXk", @"merchant_identifier",
//                         @"kU4Ma4qFtGDMTF2ykzE7", @"access_code",
//                         [self sha1Encode:post],@"signature",
//                         @"en", @"language",
//                         [payFort getUDID], @"device_id",
//                         nil];
//
//    NSError *error;
//    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
//
//
//    NSString *BaseDomain =@"https://sbpaymentservices.payfort.com/FortAPI/paymentApi";
//    NSString *urlString = [NSString stringWithFormat:@"%@",BaseDomain];
//    NSString *postLength = [NSString stringWithFormat:@"%ld",[postdata length]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postdata];
//
////    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
////    if(connection){
////        webDataglobal = [NSMutableData data];
////    }
////    else{
////        NSLog(@"The Connection is null");
////    }
//
////    NSURL *request1 = [NSURLRequest requestWithURL:request];
////    NSURLSession *session = [NSURLSession sharedSession];
////        [[session dataTaskWithURL:request
////                completionHandler:^(NSData *data,
////                                    NSURLResponse *response,
////                                    NSError *error) {
////                    // handle response
////
////                }] resume];
//
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
//            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
//            {
//                // do something with the data
//                [self->webDataglobal setLength: 0];
//                [self->webDataglobal appendData:data];
//                NSLog(@"error %@",error);
//        id collection = [NSJSONSerialization JSONObjectWithData:self->webDataglobal options:0 error:nil];
//        NSLog(@"receive data %@",collection);
//        self->sdk_token = collection[@"sdk_token"];
//
//        //-----Placing Order when successfully token recieved------//
//
//        [ProgressHUD show];
//
//        //------when product buy now option tapped------------//
//        if ([[self->_paymentDetailsRecieved objectForKey:@"buy_now"]isEqualToString:@"yes"])
//        {
//            NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,buyNow];
//            NSDictionary *parameters;
//
//            parameters = @{@"user_id": [self->_paymentDetailsRecieved objectForKey:@"user_id"], @"shipping_id":[self->_paymentDetailsRecieved objectForKey:@"shipping_id"], @"billing_id":[self->_paymentDetailsRecieved objectForKey:@"billing_id"],@"comment":@"",@"coupon_code":self->_txtCoupon.text,@"product_id":[self->_paymentDetailsRecieved objectForKey:@"product_id"],@"variant_id":[self->_paymentDetailsRecieved objectForKey:@"variant_id"],@"payment_type":self->paymentType};
//            NSLog(@"%@",parameters);
//
//    //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//            [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
//             {
//                 NSString *text = [responseObject objectForKey:@"code"];
//                self->orderId        = [responseObject objectForKey:@"value"];
//
//                 if ([text isEqualToString: @"200"])
//                 {
//                     [ProgressHUD dismiss];
//                     [self launch];
//                     [Utility addtoplist:@"0" key:@"cartCount" plist:@"iq"];
//                 }else
//                 {
//                     [AlertController alertWithMessage:@"Order not placed!" presentingViewController:self];
//                 }
//                 [ProgressHUD dismiss];
//                 NSLog(@"JSON: %@", responseObject);
//
//             } failure:^(NSURLSessionTask *task, NSError *error) {
//                 NSLog(@"Error: %@", error);
//                 [ProgressHUD dismiss];
//             }];
//        }
//        else  //----buying from cart option-----//
//        {
//            NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,placeOrderAPI];
//            NSDictionary *parameters;
//
//            parameters = @{@"user_id": [self->_paymentDetailsRecieved objectForKey:@"user_id"], @"shipping_id":[self->_paymentDetailsRecieved objectForKey:@"shipping_id"], @"billing_id":[self->_paymentDetailsRecieved objectForKey:@"billing_id"],@"comment":@"",@"coupon_code":self->_txtCoupon.text,@"payment_type":self->paymentType};
//
//
//    //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//            [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
//             {
//                 NSString *text = [responseObject objectForKey:@"code"];
//                self->orderId        = [responseObject objectForKey:@"value"];
//
//                 if ([text isEqualToString: @"200"])
//                 {
//                     [Utility addtoplist:@"0" key:@"cartCount" plist:@"iq"];
//                     [ProgressHUD dismiss];
//                     [self launch];
//                 }else{
//                     [AlertController alertWithMessage:@"Order not placed!" presentingViewController:self];
//                 }
//                  [ProgressHUD dismiss];
//                  NSLog(@"JSON: %@", responseObject);
//
//              } failure:^(NSURLSessionTask *task, NSError *error) {
//                  NSLog(@"Error: %@", error);
//                  [ProgressHUD dismiss];
//              }];
//        }
//            }];
//    [dataTask resume];
//
//
//}
//
////-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
////    [webDataglobal setLength: 0];
////}
////
////-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
////    [webDataglobal appendData:data];
////}
////
////-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
////    NSLog(@"error %@",error);
////}
////
////-(void)connectionDidFinishLoading:(NSURLConnection *)connection
////{
////    id collection = [NSJSONSerialization JSONObjectWithData:webDataglobal options:0 error:nil];
////    NSLog(@"receive data %@",collection);
////    sdk_token = collection[@"sdk_token"];
////
////    //-----Placing Order when successfully token recieved------//
////
////    [ProgressHUD show];
////
////    //------when product buy now option tapped------------//
////    if ([[_paymentDetailsRecieved objectForKey:@"buy_now"]isEqualToString:@"yes"])
////    {
////        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,buyNow];
////        NSDictionary *parameters;
////
////        parameters = @{@"user_id": [_paymentDetailsRecieved objectForKey:@"user_id"], @"shipping_id":[_paymentDetailsRecieved objectForKey:@"shipping_id"], @"billing_id":[_paymentDetailsRecieved objectForKey:@"billing_id"],@"comment":@"",@"coupon_code":_txtCoupon.text,@"product_id":[_paymentDetailsRecieved objectForKey:@"product_id"],@"variant_id":[_paymentDetailsRecieved objectForKey:@"variant_id"],@"payment_type":paymentType};
////
//////        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
////        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
////        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
////         {
////             NSString *text = [responseObject objectForKey:@"code"];
////            self->orderId        = [responseObject objectForKey:@"value"];
////
////             if ([text isEqualToString: @"200"])
////             {
////                 [ProgressHUD dismiss];
////                 [self launch];
////                 [Utility addtoplist:@"0" key:@"cartCount" plist:@"iq"];
////             }else
////             {
////                 [AlertController alertWithMessage:@"Order not placed!" presentingViewController:self];
////             }
////             [ProgressHUD dismiss];
////             NSLog(@"JSON: %@", responseObject);
////
////         } failure:^(NSURLSessionTask *task, NSError *error) {
////             NSLog(@"Error: %@", error);
////             [ProgressHUD dismiss];
////         }];
////    }
////    else  //----buying from cart option-----//
////    {
////        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,placeOrderAPI];
////        NSDictionary *parameters;
////
////        parameters = @{@"user_id": [_paymentDetailsRecieved objectForKey:@"user_id"], @"shipping_id":[_paymentDetailsRecieved objectForKey:@"shipping_id"], @"billing_id":[_paymentDetailsRecieved objectForKey:@"billing_id"],@"comment":@"",@"coupon_code":_txtCoupon.text,@"payment_type":paymentType};
////
////
//////        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
////        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
////        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
////         {
////             NSString *text = [responseObject objectForKey:@"code"];
////            self->orderId        = [responseObject objectForKey:@"value"];
////
////             if ([text isEqualToString: @"200"])
////             {
////                 [Utility addtoplist:@"0" key:@"cartCount" plist:@"iq"];
////                 [ProgressHUD dismiss];
////                 [self launch];
////             }else{
////                 [AlertController alertWithMessage:@"Order not placed!" presentingViewController:self];
////             }
////              [ProgressHUD dismiss];
////              NSLog(@"JSON: %@", responseObject);
////
////          } failure:^(NSURLSessionTask *task, NSError *error) {
////              NSLog(@"Error: %@", error);
////              [ProgressHUD dismiss];
////          }];
////    }
////}
//
//
////MARK:- PAFORT Payment
////------ for getting signature for payfort payment-------//
//- (NSString*)sha1Encode:(NSString*)input
//{
//    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:input.length];
//    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
//
//    CC_SHA256(data.bytes, (int)data.length, digest);
//    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
//
//    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02x", digest[i]];
//
//    return output;
//}
//
////----------Payfort final payment---------//
//-(void) launch
//{
//    payFort.delegate = self;
//    NSMutableDictionary *request = [[NSMutableDictionary alloc]init];
//    totalAmount = totalAmount*100;
//
//    NSString *str = [NSString stringWithFormat:@"%.0f",totalAmount];
//
//    [request setValue:str forKey:@"amount"];
//    [request setValue:@"PURCHASE" forKey:@"command"];
//    [request setValue:@"QAR" forKey:@"currency"];
//    [request setValue:@"customer@domain.com" forKey:@"customer_email"];
//    [request setValue:@"en" forKey:@"language"];
//    [request setValue:[NSString stringWithFormat:@"%lld", [@(floor([[NSDate date] timeIntervalSince1970] * 1000)) longLongValue]] forKey:@"merchant_reference"];
//    [request setValue:sdk_token forKey:@"sdk_token"];
//
//    [request setValue:@"" forKey:@"payment_option"];
//    [request setValue:sdk_token forKey:@"token_name"];
//    [payFort setPayFortRequest:request]; // Must Send [payFort callPayFort:self]
//    [payFort callPayFort:self];
//}
//
// -(void)sdkResult:(id)response{
//
//    NSLog(@"payfort data— %@",response);
//     payfortResponse = response;
//
//     if ([[response valueForKey:@"response_message"]isEqualToString:@"Success"])
//     {
//         [self savePaymentMethod];
//     }
//}
//
//-(void)savePaymentMethod
//{
//    if ([Utility reachable])
//    {
//        [ProgressHUD show];
//        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,savePayment];
//        NSDictionary *parameters;
//
//        NSError *error;
//        NSData *postdata = [NSJSONSerialization dataWithJSONObject:payfortResponse options:kNilOptions error:&error];
//
//       NSString *jsonString = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
//
//
//        parameters = @{@"order_id": orderId, @"parameters":jsonString};
//
//
////        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
//         {
//             NSString *text = [responseObject objectForKey:@"code"];
//             if ([text isEqualToString: @"200"])
//             {
//                 [ProgressHUD dismiss];
//
//                 UIAlertController * alert = [UIAlertController
//                                              alertControllerWithTitle:@"IamQatar"
//                                              message:@"Order successfully placed!"
//                                              preferredStyle:UIAlertControllerStyleAlert];
//
//
//
//                 UIAlertAction* OkButton = [UIAlertAction
//                                            actionWithTitle:@"Ok"
//                                            style:UIAlertActionStyleDefault
//                                            handler:^(UIAlertAction * action) {
//                                                    [self pushAfterDismiss];
//                                            }];
//
//
//                 [alert addAction:OkButton];
//                 [self presentViewController:alert animated:YES completion:nil];
//
//            [self dismissViewControllerAnimated:YES completion:nil];
//             }
//             [ProgressHUD dismiss];
//             NSLog(@"JSON: %@", responseObject);
//
//         } failure:^(NSURLSessionTask *task, NSError *error) {
//             NSLog(@"Error: %@", error);
//             [ProgressHUD dismiss];
//         }];
//    }
//    else
//    {
//        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
//    }
//}
//
//
////- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
////{
////    if (buttonIndex == 0)
////    {
////        [Utility addtoplist:@"yes" key:@"orderStatus" plist:@"iq"];
////        [self dismissViewControllerAnimated:YES completion:nil];
////    }else if (buttonIndex == 123)
////    {
////        [self dismissViewControllerAnimated:YES completion:^{
////           // [self.navigationController popToRootViewControllerAnimated:YES];
////            OrderHistoryViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
////            [self.navigationController popToViewController:view animated:YES];
////        }];
////    }
////}
//
//-(void)UIAlertController:(UIAlertController *)UIAlertController clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        [Utility addtoplist:@"yes" key:@"orderStatus" plist:@"iq"];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }else if (buttonIndex == 123)
//    {
//        [self dismissViewControllerAnimated:YES completion:^{
//           // [self.navigationController popToRootViewControllerAnimated:YES];
//            OrderHistoryViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
//            [self.navigationController popToViewController:view animated:YES];
//        }];
//    }
//}
//
//-(IBAction)applyCouponCode:(id)sender
//{
//    //------when product buy now option tapped------------//
//    if ([[_paymentDetailsRecieved objectForKey:@"buy_now"]isEqualToString:@"yes"])
//    {
//        [ProgressHUD show];
//        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,applyCoupon];
//        NSDictionary *parameters;
//
//        parameters = @{@"user_id": [_paymentDetailsRecieved objectForKey:@"user_id"],@"coupon_code":_txtCoupon.text,@"product_id":[_paymentDetailsRecieved objectForKey:@"product_id"],@"variant_id":[_paymentDetailsRecieved objectForKey:@"variant_id"],@"quantity":[_paymentDetailsRecieved objectForKey:@"item_Qty"]};
//
//
////        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
//         {
//             NSString *text = [responseObject objectForKey:@"code"];
//             if ([text isEqualToString: @"200"])
//             {
//                 [ProgressHUD dismiss];
//
//                 self->_lblcoupon.hidden      = NO;
//                 self->_lblCouponPrice.hidden = NO;
//                 self->_btnRemove.hidden      = NO;
//
//                 NSString *coupon = [[responseObject objectForKey:@"coupon_details"]valueForKey:@"coupon_code"];
//                 NSString *discountAmount = [[responseObject objectForKey:@"price_summary"]valueForKey:@"coupon_appplied_amt"];
//                 NSString *grantTotalNew  = [[responseObject objectForKey:@"price_summary"]valueForKey:@"grandtotal"];
//
//                 self->totalAmount = [grantTotalNew floatValue]+[self->deliveryCharge floatValue];
//
//                 self->_lblcoupon.text        = [NSString stringWithFormat:@"Coupon (%@)",self->_txtCoupon.text];
//                 self->_lblCouponPrice.text   = [NSString stringWithFormat:@"QAR %.2f",[discountAmount floatValue]];
//                 self->_amountPayableTxt.text = [NSString stringWithFormat:@"QAR %.2f",self->totalAmount];
//                 self->_grantTotal.text       = [NSString stringWithFormat:@"QAR %.2f",self->totalAmount];
//
//             }
//             else if([text isEqualToString: @"401"])
//             {
//                 [AlertController alertWithMessage:@"Not a valid coupon!" presentingViewController:self];
//                 self->_txtCoupon.text = @"";
//             }
//             [ProgressHUD dismiss];
//             NSLog(@"JSON: %@", responseObject);
//
//         } failure:^(NSURLSessionTask *task, NSError *error) {
//             NSLog(@"Error: %@", error);
//             [ProgressHUD dismiss];
//         }];
//
//    }else{
//
//        [ProgressHUD show];
//        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,applyCoupon];
//        NSDictionary *parameters;
//
//        parameters = @{@"user_id": [_paymentDetailsRecieved objectForKey:@"user_id"],@"coupon_code":_txtCoupon.text};
//
//
////        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
//         {
//             NSString *text = [responseObject objectForKey:@"code"];
//             if ([text isEqualToString: @"200"])
//             {
//                 [ProgressHUD dismiss];
//
//                 self->_lblcoupon.hidden      = NO;
//                 self->_lblCouponPrice.hidden = NO;
//                 self->_btnRemove.hidden      = NO;
//
//                 NSString *coupon = [[responseObject objectForKey:@"coupon_details"]valueForKey:@"title"];
//                 NSString *discountAmount = [[responseObject objectForKey:@"price_summary"]valueForKey:@"coupon_appplied_amt"];
//                 NSString *grantTotalNew  = [[responseObject objectForKey:@"price_summary"]valueForKey:@"grandtotal"];
//
//                 self->totalAmount = [grantTotalNew floatValue]+[self->deliveryCharge floatValue];
//
//
//                 self->_lblcoupon.text        = [NSString stringWithFormat:@"Coupon (%@)",coupon];
//                 self->_lblCouponPrice.text   = [NSString stringWithFormat:@"QAR %.2f",[discountAmount floatValue]];
//                 self->_amountPayableTxt.text = [NSString stringWithFormat:@"QAR %.2f",self->totalAmount];
//                 self->_grantTotal.text       = [NSString stringWithFormat:@"QAR %.2f",self->totalAmount];;
//
//             }
//             else if([text isEqualToString: @"401"])
//             {
//                  [AlertController alertWithMessage:@"Not a valid coupon!" presentingViewController:self];
//                 self->_txtCoupon.text = @"";
//             }
//             [ProgressHUD dismiss];
//             NSLog(@"JSON: %@", responseObject);
//
//         } failure:^(NSURLSessionTask *task, NSError *error) {
//             NSLog(@"Error: %@", error);
//             [ProgressHUD dismiss];
//         }];
//    }
//}
//
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//- (IBAction)closeAction:(id)sender {
//    [Utility addtoplist:@"YES" key:@"fromCheckOut" plist:@"iq"];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (IBAction)removeCoupon:(id)sender {
//
//    [self setUpLoadItems];
//    _lblcoupon.hidden      = YES;
//    _lblCouponPrice.hidden = YES;
//    _btnRemove.hidden      = YES;
//
//    _txtCoupon.text =@"";
//}
//
//-(BOOL) textFieldShouldReturn: (UITextField *) textField {
//    [textField resignFirstResponder];
//    return YES;
//}
//
//-(IBAction)onRadioBtn:(UIButton*)sender
//{
//    NSInteger value = [sender tag];
//    if (value == 1)
//    {
//        ///Credit/Debit card payment - disabled temporarily as client suggested on 17/10/18
////        [_radioBtnCard setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
////        [_radioBtnCOD setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
////        paymentType = @"Payfort";
////
////        _btnCardPayment.selected = YES;
////        _btnCod.selected = NO;
//
//        UIAlertController * alert = [UIAlertController
//                                     alertControllerWithTitle:@"IamQatar"
//                                     message:@"Credit/Debit card payment is not available now!"
//                                     preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction* OkButton = [UIAlertAction
//                                   actionWithTitle:@"OK"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction * action) {
//
//                                   }];
//        [alert addAction:OkButton];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//    else if(value == 2)
//    {
//        [_radioBtnCard setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
//        [_radioBtnCOD setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
//        paymentType = @"COD";
//
//        _btnCod.selected = YES;
//        _btnCardPayment.selected = NO;
//    }
//
//    NSLog(@"Selected: %ld", (long)sender.tag);
//}
//
////Converting color to image
//- (UIImage *)imageWithColor:(UIColor *)color {
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return image;
//}
//
//
////MARK:- TABBAR DELEGATE METHODS
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//
//    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
//    {
//        if (isSelected) {
//            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                self->isSelected = NO;
//                self->menu.frame=CGRectMake(-290, 0, 275, self->deviceHieght);
//            } completion:^(BOOL finished){
//                // if you want to do something once the animation finishes, put it here
//                self->menuHideTap.enabled = NO;
//                [self->menu setHidden:YES];
//            }];
//        }else{
//            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                [self->menu setHidden:NO];
//                self->menuHideTap.enabled = YES;
//                self->isSelected = YES;
//
//                if ([[UIScreen mainScreen] bounds].size.height == 736.0){
//                    self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
//                }
//                else if([[UIScreen mainScreen] bounds].size.height == 667.0){
//                    self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
//                }
//                else{
//                    self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
//                }
//
//            } completion:^(BOOL finished){
//                // if you want to do something once the animation finishes, put it here
//
//            }];
//        }
//        return NO;
//    }
//    else if (viewController == [self.tabBarController.viewControllers objectAtIndex:3])
//    {
//        //[self.navigationController popViewControllerAnimated:YES];
//        //return NO;
//    }else if(viewController == [self.tabBarController.viewControllers objectAtIndex:1]){
//        //Jump to login screen
//        NSString *plistVal = [[NSString alloc]init];
//        plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];
//
//        if([plistVal isEqualToString:@"YES"]){
//            //[AlertController alertWithMessage:@"Please Login!" presentingViewController:self];
//            [Utility guestUserAlert:self];
//            return NO;
//        }else{
//            return YES;
//        }
//    }
//
//    return YES;
//}
//
//#pragma mark - PopUpMenu delegates
//-(void)todaysDeal:(Menu *)sender{
//    RetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
//    view.pushedFrom = @"todaysDeal";
//    [self.navigationController pushViewController:view animated:YES];
//}
//-(void)whatsNew:(Menu *)sender{
//    RetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
//    view.pushedFrom = @"whatsNew";
//    [self.navigationController pushViewController:view animated:YES];
//}
//-(void)emergencyContact:(Menu *)sender{
//    emergencyContactViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"contactView"];
//    [self.navigationController pushViewController:view animated:YES];
//}
//-(void)contest:(Menu *)sender{
//
//    NSString *plistVal = [[NSString alloc]init];
//    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];
//
//    if([plistVal isEqualToString:@"YES"]){
//        LoginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
//
//        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        appDelegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
//        [self.navigationController presentViewController:view animated:NO completion:nil];
//    }else{
//        contestViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"contestView"];
//        [self.navigationController pushViewController:view animated:YES];
//    }
//}
//-(void)GoProfilePage:(Menu *)sender{
//    // navigation not needed for this page
//}
//-(void)GoAboutUsPage:(Menu *)sender{
//    AboutUsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutUsView"];
//    [self.navigationController pushViewController:view animated:YES];
//}
//-(void)History:(Menu *)sender{
//    OrderHistoryViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
//    [self.navigationController pushViewController:view animated:YES];
//}
//-(void)ContactUs:(Menu *)sender{
//    ContactUsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
//    [self.navigationController pushViewController:view animated:YES];
//}
//-(void)goTermsOfUse:(Menu *)sender{
//    TermsAndConditionsVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsAndConditionsVC"];
//    [self.navigationController pushViewController:view animated:YES];
//}
//-(void)LogOut:(Menu *)sender{
//    LoginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
//    [self.navigationController popToRootViewControllerAnimated:NO];
//
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
//
//    //G+ signout
//    GIDSignIn *signin = [GIDSignIn sharedInstance];
//    [signin signOut];
//
//    //Logout plist clear
//    [Utility addtoplist:@"" key:@"login" plist:@"iq"];
//
//    //Resetting 'skipped user' value
//    [Utility addtoplist:@"NO"key:@"skippedUser" plist:@"iq"];
//
//    [self.navigationController presentViewController:view animated:NO completion:nil];
//}
//
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
