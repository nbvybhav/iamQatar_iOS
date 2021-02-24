
//
//  bestBuyDetailViewController.m
//  IamQatar
//
//  Created by alisons on 1/5/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import "bestBuyDetailViewController.h"
#import "bestBuyDetailViewCell.h"
#import "constants.pch"
#import "UIImageView+WebCache.h"
#import "IamQatar-Swift.h"

@interface bestBuyDetailViewController ()

@end

@implementation bestBuyDetailViewController
{
    NSMutableArray *priceArray;
    NSMutableArray *newPriceArray;
    NSMutableArray *discountArray;
    NSMutableArray *productNameArray;
    NSMutableArray *stockLeftArray;
    NSMutableArray *variantIdArray;
    NSMutableArray *descArray;
    NSString       *bannerImage;
    NSString       *desc;
    NSString       *newPrice;
    NSString       *price;
    NSString       *productName;
    NSString       *qty;
    NSString       *vid;
    NSDate         *startDate;
    NSDate         *endDate;
    NSTimer        *timer;
    NSTimeInterval secs;
    
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    
     priceArray       = [[NSMutableArray alloc]init];
     newPriceArray    = [[NSMutableArray alloc]init];
     discountArray    = [[NSMutableArray alloc]init];
     productNameArray = [[NSMutableArray alloc]init];
     stockLeftArray   = [[NSMutableArray alloc]init];
     variantIdArray   = [[NSMutableArray alloc]init];
     startDate        = [[NSDate alloc]init];
     endDate          = [[NSDate alloc]init];

    // Do any additional setup after loading the view.
    
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
    
    _lblNoDesc.hidden = YES;
    _lblStockAvailability.hidden = YES;
    _bestBuyTableView.delegate   = self;
    _bestBuyTableView.dataSource = self;
    //_bestBuyTableView.userInteractionEnabled = NO;
   // _mainScrollView.frame.size.height = CGSizeMake(220, _bestBuyTableView.frame.origin.y+_bestBuyTableView.frame.size.height);
}

-(void)CheckTimer{
    
    NSDateComponents *components;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    
    NSDate *today = [[NSDate alloc]init];
    NSDateFormatter *df;
    df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setLocale:[NSLocale currentLocale]];
    df.dateFormat = @"yyyy-MM-DD HH:mm:ss";
    NSString *str = [df stringFromDate:[NSDate date]];
    today = [df dateFromString:str];
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate: today toDate: endDate options: 0];
    days = [components day];
    hour = [components hour];
    minutes = [components minute];
    
    secs = [endDate timeIntervalSinceDate:today];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCount) userInfo:nil repeats:YES];
}

-(void)timerCount{
   NSString *timerString = [self timeFormatConvertToSeconds:[NSString stringWithFormat:@"%f",secs]];
    _lblTimeleft.text = timerString;
  NSLog(@"TimerString>%@",timerString);
}


- (NSString *)timeFormatConvertToSeconds:(NSString *)timeSecs
{
    secs= secs-1;
    int totalSeconds=[timeSecs intValue];
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours   = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [tracker set:kGAIScreenName value:@"Bestbuy detail page"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;
    
//    if(![_isFromSearch isEqual:@"Yes"]){
     [self getBestBuyOptions];
//    }else{
//        
//    }
    
    //NSLog(@"height>>%f",_bestBuyTableView.frame.size.height);
    //_mainScrollView.frame.size.height =
}


-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(0, 625, 275, 335);
}

-(void)viewDidAppear:(BOOL)animated{
    _bestBuyTableView.frame = CGRectMake(_bestBuyTableView.frame.origin.x, _bestBuyTableView.frame.origin.y, _bestBuyTableView.frame.size.width, _bestBuyTableView.contentSize.height);
}

-(void)viewDidLayoutSubviews{
    _bestBuyTableView.frame = CGRectMake(_bestBuyTableView.frame.origin.x, _bestBuyTableView.frame.origin.y, _bestBuyTableView.frame.size.width, _bestBuyTableView.contentSize.height);
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [_mainScrollView setContentSize:CGSizeMake(220, _bestBuyTableView.frame.origin.y+[productNameArray count]*100+20)];
    return [productNameArray count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    bestBuyDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bestBuyDetailViewCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"bestBuyDetailViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
   if([productNameArray count]>0){
         
        _lblNewPrice.text        = [NSString stringWithFormat:@"%@ QAR",newPrice];
        _lblOldPrice.text        = price;
        _bestBuyTitle.text       = productName;
        _bestBuyDescription.text = desc;
           
        NSURL *imageUrl     = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,bannerImage]];
       [_bestBuyBanner sd_setImageWithURL:imageUrl];
        cell.lblName.text   = [NSString stringWithFormat:@"%@",[productNameArray objectAtIndex:indexPath.row]];
        cell.lblDesc.text   = [NSString stringWithFormat:@"%@",[descArray objectAtIndex:indexPath.row]];
        cell.lblNumber.text = [NSString stringWithFormat:@"Option %ld:",indexPath.row+1];
        cell.btnAddtoCart.tag = indexPath.row;
       [cell.btnAddtoCart addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
        cell.lblPrice.text  = [NSString stringWithFormat:@"%@ QAR",[newPriceArray objectAtIndex:indexPath.row]];
    }
    
    if([desc isEqualToString:@""])
    {
        _lblNoDesc.hidden = NO;
    }else{
        _lblNoDesc.hidden = YES;
    }
    
    if(qty > 0)
    {
        _lblStockAvailability.hidden = NO;
    }else{
        _lblStockAvailability.hidden = YES;
    }

    return cell;
}


-(IBAction)addToCart:(id)sender
{
  if ([Utility reachable]) {

        [ProgressHUD show];
        
        UIButton *btn = (UIButton*) sender;
        vid = [variantIdArray objectAtIndex:btn.tag];
        
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSDictionary *parameters = @{@"user_id": [appDelegate.userProfileDetails objectForKey:@"user_id"], @"quantity":@"1", @"product_id": _bbProductId,@"variant_id":vid};
      
      
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[NSString stringWithFormat:@"%@api.php?page=addToCart",parentURL]parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject){
            NSString *text = [responseObject objectForKey:@"code"];
            
            
            if ([text isEqualToString: @"200"])
            {
                int badgeValue = [[[[responseObject objectForKey:@"value"] objectForKey:@"count"] objectForKey:@"count"] intValue];
                
                if (badgeValue != 0) {
                    NSString * value=[NSString stringWithFormat:@"%i",badgeValue];
                    [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:value];
                }
                else{
                    [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:nil];
                }
                
                NSString *badgeStr = [NSString stringWithFormat:@"%d",badgeValue];
                [Utility addtoplist:badgeStr key:@"cartCount" plist:@"iq"];
                
                [AlertController alertWithMessage:@"Added to bag!" presentingViewController:self];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // This will create a "invisible" footer
    return 0.01f;
}

-(void)getBestBuyOptions
{
    if ([Utility reachable]) {
        
       [ProgressHUD dismiss];
        NSString *urlString = [NSString stringWithFormat:@"%@api.php?page=getBestBuyDetails&product_id=%@",parentURL,_bbProductId];
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             
             if ([text isEqualToString: @"Success!"])
             {
                 NSMutableArray *value = [responseObject objectForKey:@"value"];
                 self->productNameArray = [[value valueForKey:@"bestbuy_options"]valueForKey:@"product_name"];
                 self->priceArray       = [[value valueForKey:@"bestbuy_options"]valueForKey:@"price"];
                 self->newPriceArray    = [[value valueForKey:@"bestbuy_options"]valueForKey:@"new_price"];
                 self->discountArray    = [[value valueForKey:@"bestbuy_options"]valueForKey:@"discount"];
                 self->stockLeftArray   = [[value valueForKey:@"bestbuy_options"]valueForKey:@"quantity"];
                 self->variantIdArray   = [[value valueForKey:@"bestbuy_options"]valueForKey:@"product_id"];
                 self->descArray        = [[value valueForKey:@"bestbuy_options"]valueForKey:@"description"];
                 
                 NSDateFormatter *df;
                 df = [[NSDateFormatter alloc] init];
    //             [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
    //             [df setTimeZone:[NSTimeZone systemTimeZone]];
    //             [df setLocale:[NSLocale currentLocale]];
                 df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                 
                 self->desc             = [value valueForKey:@"description"];
                 self->newPrice         = [value valueForKey:@"newprice"];
                 self->price            = [value valueForKey:@"price"];
                 self->productName      = [value valueForKey:@"product_name"];
                 self->bannerImage      = [value valueForKey:@"banner"];
                 self->qty              = [value valueForKey:@"quantity"];
                 self->startDate        = [df dateFromString:[NSString stringWithFormat:@"%@",[value valueForKey:@"start_time"]]];
                 self->endDate          = [df dateFromString:[NSString stringWithFormat:@"%@",[value valueForKey:@"expiry_time"]]];
             }
             
             [self CheckTimer];
             NSLog(@"JSON: %@", responseObject);
            [self->_bestBuyTableView reloadData];
             
         } failure:^(NSURLSessionTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
        [ProgressHUD dismiss];
    }else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}

- (IBAction)shareAction:(id)sender
{
    NSString *shareString  =[NSString stringWithFormat:@"%@",_bestBuyDescription.text];
    NSURL *appUrl          =[[NSURL alloc]initWithString:@"http://itunes.com/apps/iamqatar"];
    UIImage *shareImg      = _bestBuyBanner.image;
    
    NSArray *activityItems = [NSArray arrayWithObjects:appUrl,shareString,shareImg, nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(0, 625, 275, 335);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self showLoaderWithTitle:@""];
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    
//    NSDictionary *parameters = @{@"user_id": [appDelegate.userProfileDetails objectForKey:@"user_id"], @"product_id": _bbProductId,@"variant_id":vid,@"quantity": @"1"};
//    
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:@"http://client.alisonsinfomatics.in/qatardeals/api.php?page=addToCart" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
//    {
//        NSString *text = [responseObject objectForKey:@"text"];
//        
//        if ([text isEqualToString: @"Success!"])
//        {
//            int badgeValue = [[[[responseObject objectForKey:@"value"] objectForKey:@"count"] objectForKey:@"count"] intValue];
//            
//            if (badgeValue != 0) {
//                NSString * value=[NSString stringWithFormat:@"%i",badgeValue];
//                [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:value];
//            }
//            else{
//                [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:nil];
//            }
//            //  fullCategoryDetails = [responseObject objectForKey:@"value"];
//            
//            [AlertController alertWithMessage:@"Added to bag!" presentingViewController:self];
//        }
//        NSLog(@"JSON: %@", responseObject);
//        [self hideLoader];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];    
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
