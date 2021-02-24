//
//  historyListViewController.m
//  IamQatar
//
//  Created by alisons on 5/8/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import "historyListViewController.h"
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "historyCell.h"
#import <UIImageView+WebCache.h>
#import "historyDetailViewController.h"

@interface historyListViewController ()
{
    
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    NSMutableDictionary *contentArray;
    NSMutableArray *orderNumArray;
    NSMutableArray *orderIdArray;
    NSMutableArray *orderStatusArray;
    NSMutableArray *productImgArray;
    NSMutableArray *priceArray;
    NSMutableArray *productNameArray;
    NSMutableArray *deliveryDateArray;
    NSMutableArray *paymentTypeArray;
}
@end

@implementation historyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    
    contentArray        = [[NSMutableDictionary alloc]init];
    orderNumArray       = [[NSMutableArray alloc]init];
    orderStatusArray    = [[NSMutableArray alloc]init];
    productImgArray     = [[NSMutableArray alloc]init];
    priceArray          = [[NSMutableArray alloc]init];
    productNameArray    = [[NSMutableArray alloc]init];
    deliveryDateArray   = [[NSMutableArray alloc]init];
    orderIdArray        = [[NSMutableArray alloc]init];
    paymentTypeArray    = [[NSMutableArray alloc]init];
    
    //--------setting menu frame---------//
    isSelected = NO;
    menu= [[Menu alloc]init];
    NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"Menu" owner:self options:nil];
    menu = [nib1 objectAtIndex:0];
    menu.frame=CGRectMake(0, 625, 275, 335);
    menu.delegate = self;
    [self.tabBarController.view addSubview:menu];
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    
    _lblNoOrders.hidden = YES;
    
    [self getHistoryList];
}

-(void)viewWillAppear:(BOOL)animated{
    //-----showing tabar item at index 4 (back button)-------//
    self.tabBarController.delegate = self;
    [[[self.tabBarController.tabBar subviews] lastObject]setHidden:NO] ;
    
    [_historyTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)getHistoryList{
    
    if ([Utility reachable]) {
        
        [ProgressHUD show];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,orderHistoryAPI];
        NSDictionary *parameters;
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        parameters = @{@"user_id":[appDelegate.userProfileDetails objectForKey:@"user_id"]};
        
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"code"];
             if ([text isEqualToString: @"200"])
             {
                 [ProgressHUD dismiss];
                 NSLog(@"JSON: %@", responseObject);
                 
                 self->contentArray       = [responseObject objectForKey:@"value"];
                 self->orderNumArray      = [[self->contentArray objectForKey:@"recent"]valueForKey:@"order_number"];
                 self->orderIdArray       = [[self->contentArray objectForKey:@"recent"]valueForKey:@"order_id"];
                 self->orderStatusArray   = [[self->contentArray objectForKey:@"recent"]valueForKey:@"orderstatus"];
                 self->productImgArray    = [[self->contentArray objectForKey:@"recent"]valueForKey:@"product_image"];
                 self->priceArray         = [[self->contentArray objectForKey:@"recent"]valueForKey:@"price"];
                 self->productNameArray   = [[self->contentArray objectForKey:@"recent"]valueForKey:@"product_name"];
                 self->deliveryDateArray  = [[self->contentArray objectForKey:@"recent"]valueForKey:@"delivery_date"];
                 self->paymentTypeArray   = [[self->contentArray objectForKey:@"recent"]valueForKey:@"payment_type"];
                 
             }else{
                 [ProgressHUD dismiss];
                 self->_lblNoOrders.hidden = NO;
             }
             
             [self.historyTableView reloadData];
             
         } failure:^(NSURLSessionTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             [ProgressHUD dismiss];
         }];
    }else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}



- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
    {
        if (isSelected) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->isSelected = NO;
                self->menu.frame=CGRectMake(0, 625, 275, 335);
            } completion:^(BOOL finished){
                // if you want to do something once the animation finishes, put it here
                self->menuHideTap.enabled = NO;
                [self->menu setHidden:YES];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self->menu setHidden:NO];
                self->menuHideTap.enabled = YES;
                self->isSelected = YES;
                
                if ([[UIScreen mainScreen] bounds].size.height == 736.0){
                    self->menu.frame=CGRectMake(0, 352, 275, 335);
                }
                else if([[UIScreen mainScreen] bounds].size.height == 667.0){
                    self->menu.frame=CGRectMake(0, 283, 275, 335);
                }
                else{
                    self->menu.frame=CGRectMake(0, 185, 275, 335);
                }
                
            } completion:^(BOOL finished){
                // if you want to do something once the animation finishes, put it here
                
            }];
        }
        return NO;
    }else if (viewController == [self.tabBarController.viewControllers objectAtIndex:3])
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

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
    {
        
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [orderNumArray count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    historyCell *cell;
    cell = [self.historyTableView dequeueReusableCellWithIdentifier:@"historyCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"historyCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblOrderNum.font = [UIFont fontWithName:@"Helvetica Neue Medium" size:15.0];
    
    cell.lblOrderNum.text    = [orderNumArray objectAtIndex:indexPath.row];
    cell.lblProductName.text = [productNameArray objectAtIndex:indexPath.row];
    cell.lblAmount.text      = [NSString stringWithFormat:@"QAR %@",[priceArray objectAtIndex:indexPath.row]];
    cell.lblDelivery.text    = [deliveryDateArray objectAtIndex:indexPath.row];
    cell.cancelBtn.tag       = indexPath.row;
    [cell.cancelBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    cell.lblPaymentType.text = [paymentTypeArray objectAtIndex:indexPath.row];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,[productImgArray objectAtIndex:indexPath.row]];
    
    NSURL *imageURL = [NSURL URLWithString:urlString];
    cell.productImg.contentMode = UIViewContentModeScaleAspectFit;
    [cell.productImg sd_setImageWithURL:imageURL];
    
    
    if([[orderStatusArray objectAtIndex:indexPath.row]isEqualToString:@"Cancelled"])
    {
        cell.cancelBtn.hidden = YES;
    }else{
       [cell.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        cell.cancelBtn.backgroundColor = [UIColor orangeColor];
        cell.cancelBtn.userInteractionEnabled = YES;
    }
    
    cell.lblOrderStatus.text = [orderStatusArray objectAtIndex:indexPath.row];
    
    if ([[orderStatusArray objectAtIndex:indexPath.row]isEqualToString:@"Cancelled"]) {
        cell.lblOrderStatus.textColor = [UIColor redColor];
    }else{
        cell.lblOrderStatus.textColor = [UIColor blackColor];
    }
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    historyDetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"historyDV"];
    NSLog(@"passing product details>%@",[[contentArray objectForKey:@"recent"]objectAtIndex:indexPath.row]);
    
    view.productDict = [[contentArray objectForKey:@"recent"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:view animated:YES];

}

-(void)cancelOrder:(id)sender{
   
    if ([Utility reachable])
    {
        [ProgressHUD show];
        
        UIButton *tagBtn = (UIButton *) sender;
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,cancelOrderAPI];
        NSDictionary *parameters = [NSDictionary alloc];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        id userID  = [appDelegate.userProfileDetails objectForKey:@"user_id"];
        parameters = @{@"user_id":userID,@"order_id":[orderIdArray objectAtIndex:tagBtn.tag]};
        
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)

         {
             NSString *text = [responseObject objectForKey:@"code"];
             if ([text isEqualToString: @"200"])
             {
                 [ProgressHUD dismiss];
                 [self getHistoryList];
             }
             NSLog(@"JSON: %@", responseObject);
             [ProgressHUD dismiss];
             
         } failure:^(NSURLSessionTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             [ProgressHUD dismiss];
         }];
    }else
    {
        [ProgressHUD dismiss];
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
    ProfileViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)GoAboutUsPage:(Menu *)sender{
    AboutUsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutUsView"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)History:(Menu *)sender{
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
