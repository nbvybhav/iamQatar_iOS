//
//  BestBuyViewController.m
//  IamQatar
//
//  Created by alisons on 9/1/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "BestBuyViewController.h"
#import "bestBuyCell.h"
#import "constants.pch"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "bestBuyDetailViewController.h"
#import "IamQatar-Swift.h"


@interface BestBuyViewController ()

@end

@implementation BestBuyViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    NSMutableDictionary *bestBuyItems;
    
    NSArray *nameArray;
    NSArray *stockLeftArray;
    NSArray *timeofExpireArray;
    NSArray *oldPriceArray;
    NSArray *offerPriceArray;
    NSArray *discountPercentArray;
    NSArray *productIdArray;
    NSArray *descArray;
    NSArray *bgImageArray;
    NSTimer *timer;
    int timerCount;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
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
    
    [self getBestBuy];
}

-(void)viewWillAppear:(BOOL)animated{
    
    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Best buy list"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    self.tabBarController.delegate = self;
    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
}

-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(0, 625, 275, 335);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getBestBuy
{
  if ([Utility reachable])
  {
       [ProgressHUD show];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,bestBuyUrl];
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
       AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
            NSString *text = [responseObject objectForKey:@"text"];
            
            if ([text isEqualToString: @"Success!"])
            {
                self->bestBuyItems        = [responseObject objectForKey:@"value"];
                self->nameArray           = [self->bestBuyItems valueForKey:@"product_name"];
                self->stockLeftArray      = [self->bestBuyItems valueForKey:@"quantity"];
                self->timeofExpireArray   = [self->bestBuyItems valueForKey:@"expiry_time"];
                self->oldPriceArray       = [self->bestBuyItems valueForKey:@"price"];
                self->offerPriceArray     = [self->bestBuyItems valueForKey:@"newprice"];
                self->bgImageArray        = [self->bestBuyItems valueForKey:@"banner"];
                self->discountPercentArray= [self->bestBuyItems valueForKey:@"discount"];
                self->productIdArray      = [self->bestBuyItems valueForKey:@"product_id"];
                self->descArray           = [self->bestBuyItems valueForKey:@"description"];
                
                self->timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCount) userInfo:nil repeats:YES];
            }
            
            NSLog(@"JSON: %@", responseObject);
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

-(void)timerCount{
    timerCount = timerCount + 1;
    [self.bestBuyTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Bestbuy list"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [timer invalidate];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"count>>%ld",[nameArray count]);
    return [nameArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"bestBuyCell";
    bestBuyCell *cell = (bestBuyCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"bestBuyCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // ... set up the cell here ...
    cell.productName.text = [[nameArray objectAtIndex:indexPath.row]capitalizedString];
    cell.stockLeft.text   = [stockLeftArray objectAtIndex:indexPath.row];
    cell.oldPrice.text    = [oldPriceArray objectAtIndex:indexPath.row];
    cell.lblDesc.text     = [descArray objectAtIndex:indexPath.row];
    float price           = [[NSString stringWithFormat:@"%@",[offerPriceArray objectAtIndex:indexPath.row]]integerValue];
    cell.offerPrice.text  = [NSString stringWithFormat:@"QAR %.f",price];
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,[bgImageArray objectAtIndex:indexPath.row]]];
    
    cell.bgImage.contentMode = UIViewContentModeScaleAspectFill;
    [cell.bgImage sd_setImageWithURL:imageUrl];
    cell.discountPercent.text = [NSString stringWithFormat:@"%@%%",[discountPercentArray objectAtIndex:indexPath.row]];
    cell.lblTimer.text = [NSString stringWithFormat:@"%d",timerCount];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    bestBuyDetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"bbDetailView"];
    detailView.bbProductId = [productIdArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailView animated:YES];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
    {
        if (isSelected) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->isSelected = NO;
                self-> menu.frame=CGRectMake(0, 625, 275, 335);
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
                self-> menuHideTap.enabled = YES;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(0, 625, 275, 335);
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
    
    //Logout plist clear
    [Utility addtoplist:@"YES" key:@"login" plist:@"iq"];
    
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
