//
//  OrderHistoryViewController.m
//  IamQatar
//
//  Created by anuroop on 18/07/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "OrderHistoryTableViewCell.h"
#import "constants.pch"
#import "UIImageView+WebCache.h"
#import "IamQatar-Swift.h"

@interface OrderHistoryViewController ()

@end

@implementation OrderHistoryViewController
{
    NSArray *nameArray;
    NSArray *orderIdArray;
    NSArray *deliverDateArray;
    NSArray *updatedDateArray;
    NSArray *priceArray;
    NSArray *imageArray;
    NSArray *statusArray;
    NSArray *productIdArray;

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
    self.title = @"ORDER HISTORY";

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

}

-(void)viewWillAppear:(BOOL)animated{

    //Jump to login screen
    NSString *plistVal = [[NSString alloc]init];
    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];

    if([plistVal isEqualToString:@"YES"]){
        LoginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];

        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
        [self.navigationController presentViewController:view animated:NO completion:nil];
    }
    [menu.btnLogout setTitle:@"Log Out" forState:UIControlStateNormal];

    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"History screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    //Setting cart value
    long cartCount = [[Utility getfromplist:@"cartCount" plist:@"iq"]integerValue];
    if (cartCount != 0) {
        NSString * value=[NSString stringWithFormat:@"%ld",cartCount];
        [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:value];
    }else{
        [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:nil];
    }

    //-----hiding tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;

    [self orderHistoryApi];
}

-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame = CGRectMake(-290, 0, 275, deviceHieght);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    //    isSelected = NO;
    //    menu.frame=CGRectMake(0, 625, 275, 335);
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

//MARK:- TABBAR DELEGATE METHODS
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


//MARK:- TABLE VIEW DELEGATES
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [nameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    OrderHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHistoryTableViewCell"];
    tableView.clipsToBounds = NO;
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderHistoryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    float price = [[priceArray objectAtIndex:indexPath.row]floatValue];

    cell.lblName.text         = [nameArray objectAtIndex:indexPath.row];
    cell.lblOrderID.text      = [orderIdArray objectAtIndex:indexPath.row];
    cell.lblPrice.text        = [NSString stringWithFormat:@"QAR %0.2f",price];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *deliveryDate = [[NSDate alloc] init];
    deliveryDate = [dateFormatter dateFromString:[deliverDateArray objectAtIndex:indexPath.row]];

    NSDate *updatedDate = [[NSDate alloc] init];
    updatedDate = [dateFormatter dateFromString:[updatedDateArray objectAtIndex:indexPath.row]];

    // converting into our required date format
    [dateFormatter setDateFormat:@"dd MMM yyyy, hh:mm a"];
    NSString *reqDateStr = [dateFormatter stringFromDate:deliveryDate];

    [dateFormatter setDateFormat:@"dd MMM yyyy, hh:mm a"];
    NSString *reqUpdatedDateStr = [dateFormatter stringFromDate:updatedDate];

    NSString *status = [NSString stringWithFormat:@"%@",[statusArray objectAtIndex:indexPath.row]];

    if([status isEqualToString:@"1"]){
        cell.lblDeliveryMsg.text  = @"Order Placed";
        cell.lblDeliverDateMsg.text = @"Delivery expected by:";

        NSString *updatedDateStr = [NSString stringWithFormat:@"%@",[updatedDateArray objectAtIndex:indexPath.row]];

        if([updatedDateStr isEqualToString:@"0000-00-00 00:00:00"]){
              cell.lblDeliveryDate.text = [NSString stringWithFormat:@"%@",reqDateStr];
        }else{
              cell.lblDeliveryDate.text = [NSString stringWithFormat:@"%@",reqUpdatedDateStr];
        }

    }else if([status isEqualToString:@"2"]){
        cell.lblDeliveryMsg.text  = @"Approved ";
        cell.lblDeliverDateMsg.text = @"Delivery expected by:";

        if([[updatedDateArray objectAtIndex:indexPath.row] isEqualToString:@"0000-00-00 00:00:00"]){
            cell.lblDeliveryDate.text = [NSString stringWithFormat:@"%@",reqDateStr];
        }else{
            cell.lblDeliveryDate.text = [NSString stringWithFormat:@"%@",reqUpdatedDateStr];
        }
    }else if([status isEqualToString:@"3"]){
         cell.lblDeliveryMsg.text = @"On Hold ";
    }else if([status isEqualToString:@"4"]){
         cell.lblDeliveryMsg.text  = @"Delivered ";
         cell.lblDeliverDateMsg.text = @"Delivered on:";

         NSString *updatedDateStr = [NSString stringWithFormat:@"%@",[updatedDateArray objectAtIndex:indexPath.row]];

        if([updatedDateStr isEqualToString:@"0000-00-00 00:00:00"]){
            cell.lblDeliveryDate.text = [NSString stringWithFormat:@"%@",reqDateStr];
        }else{
            cell.lblDeliveryDate.text = [NSString stringWithFormat:@"%@",reqUpdatedDateStr];
        }
        
    }else if([status isEqualToString:@"5"]){
        cell.lblDeliveryMsg.text  = @"Cancelled ";
    }

    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,[imageArray objectAtIndex:indexPath.row]]];
    cell.imgOrder.contentMode   = UIViewContentModeScaleAspectFit;
    cell.imgOrder.layer.cornerRadius = 5.0;
    cell.imgOrder.layer.masksToBounds = YES;
    [cell.imgOrder sd_setImageWithURL:imageUrl];

    [cell.btnCancel addTarget:self action:@selector(contactUs:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketDetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"marketDetailView"];
    vc.selectedProductId = [productIdArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK:- METHODS
-(void)contactUs:(id) sender{
    ContactUsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
    [self.navigationController pushViewController:vc animated:false];
}

-(void)orderHistoryApi
{
    if([Utility reachable])
    {
        [ProgressHUD show];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,orderHistoryAPI];
        NSDictionary *parameters = @{@"user_id": [appDelegate.userProfileDetails objectForKey:@"user_id"] };

//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"code"];

             if ([text isEqualToString: @"200"])
             {
                 self->nameArray = [[[responseObject objectForKey:@"value"]objectForKey:@"recent"]valueForKey:@"product_name"];
                 self->orderIdArray= [[[responseObject objectForKey:@"value"]objectForKey:@"recent"]valueForKey:@"order_number"];
                 self->deliverDateArray = [[[responseObject objectForKey:@"value"]objectForKey:@"recent"]valueForKey:@"delivery_date"];
                 self->updatedDateArray = [[[responseObject objectForKey:@"value"]objectForKey:@"recent"]valueForKey:@"updated_date"];
                 self->priceArray = [[[responseObject objectForKey:@"value"]objectForKey:@"recent"]valueForKey:@"price"];
                 self->imageArray = [[[responseObject objectForKey:@"value"]objectForKey:@"recent"]valueForKey:@"product_image"];
                 self->statusArray= [[[responseObject objectForKey:@"value"]objectForKey:@"recent"]valueForKey:@"order_status"];
                 self->productIdArray = [[[responseObject objectForKey:@"value"]objectForKey:@"recent"]valueForKey:@"item_id"];

             }

            if([self->nameArray count]==0)
             {
                 self->_lblNoOrders.hidden = NO;
             }else{
                 self->_lblNoOrders.hidden = YES;
             }
             
             NSLog(@"JSON: %@", responseObject);
            [self->_orderHistoryTableView reloadData];
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
