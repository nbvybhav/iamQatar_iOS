//
//  GiftListViewController.m
//  IamQatar
//
//  Created by User on 11/09/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import "GiftListViewController.h"
#import "constants.pch"
#import "UIImageView+WebCache.h"
#import "ProductListViewCell.h"
#import "ProductFilterCollectionViewCell.h"
#import "GiftDetailVC.h"
#import "IamQatar-Swift.h"

@interface GiftListViewController ()

@end

@implementation GiftListViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;

    NSArray *listDefaultImageArray;
    NSArray *listDescriptionArray;
    NSArray *listImagesArray;
    NSArray *listTitleArray;
    NSArray *responseListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    // Do any additional setup after loading the view.
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

    //Collectionview cell Nib registration
    [self.productListCollectionView registerNib:[UINib nibWithNibName:@"ProductListViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductListViewCell"];
    [self.filterCollectionView registerNib:[UINib nibWithNibName:@"ProductFilterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductFilterCollectionViewCell"];

    [self getgiftDetails];
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
    [tracker set:kGAIScreenName value:@"Gift screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(-290, 0, 275, deviceHieght);
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

//MARK:- API CALL
- (void)getgiftDetails{
    if([Utility reachable]){

        [ProgressHUD show];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        NSDictionary *param = [[NSDictionary alloc]initWithObjectsAndKeys:_giftCatId,@"category_id",[appDelegate.userProfileDetails objectForKey:@"user_id"],@"user_id", nil];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,giftItemsUrl] parameters:param headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
            self->responseListArray = [responseObject objectForKey:@"value"];

             if ([text isEqualToString: @"Success!"])
             {
                 self->_emptyView.hidden = YES;
                 NSLog(@"JSON: %@", responseObject);

                 self->listDefaultImageArray = [[responseObject objectForKey:@"value"]valueForKey:@"default"];
                 self->listDescriptionArray  = [[responseObject objectForKey:@"value"]valueForKey:@"description"];
                 self->listImagesArray       = [[[responseObject objectForKey:@"value"]valueForKey:@"images"]valueForKey:@"imagepath"];
                 self->listTitleArray        = [[responseObject objectForKey:@"value"]valueForKey:@"product_name"];
             }else if([text isEqualToString:@"No records found"]){
                 self->_emptyView.hidden = NO;
             }

             [self.productListCollectionView reloadData];
             //[self setUI];
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

//MARK:- COLLECTION VIEW DELEGTES
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1)
    {
        // Products collectionView
        if ((int)[[UIScreen mainScreen] bounds].size.height <= 568)         //iPhone 5 or less
        {
            return CGSizeMake(150 , 210);
        }else if((int)[[UIScreen mainScreen] bounds].size.height ==  736.0) //iPhone 6p
        {
            return CGSizeMake(190 , 230);
        }else {                                                             //iPhone 6
            return CGSizeMake(170 , 230);
        }

    }else{
        //Filter collectionView
        return CGSizeMake(105 , 45);
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag == 1)
    {
        // Products collectionView
        return [listTitleArray count];
    }else{
        //Filter collectionView
        //return [cat_id_array count];
        return 0;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1) // Products collectionView
    {
        ProductListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductListViewCell" forIndexPath:indexPath];

        cell.bgImage.layer.cornerRadius = 10.0;
        cell.bgImage.layer.masksToBounds = YES;

        cell.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.contentView.layer.shadowRadius = 5.0f;
        cell.contentView.layer.shadowOffset = CGSizeZero;
        cell.contentView.layer.shadowOpacity = 0.8f;
        cell.layer.masksToBounds = NO;
        _productListCollectionView.layer.masksToBounds = NO;

        NSString *subUrl = [listDefaultImageArray objectAtIndex:indexPath.row];
        NSURL *imageUrl    = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,subUrl]];
        cell.productImage.contentMode   = UIViewContentModeScaleAspectFit;
        [cell.productImage sd_setImageWithURL:imageUrl];

        cell.lblItemName.text = [NSString stringWithFormat:@"%@",[listTitleArray objectAtIndex:indexPath.row]];
        cell.lblPrice.text    = [NSString stringWithFormat:@"%@",[listDescriptionArray objectAtIndex:indexPath.row]];


        return cell;
    }else{
        //Filter collectionView
        ProductFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductFilterCollectionViewCell" forIndexPath:indexPath];
        NSString *bgImage;
        NSInteger index = indexPath.row+1;

        //Logic for reeating bg gradient
        if (index>3) {
            index = index%3;
            if(index==0){
                index=1;
            }
            bgImage =[NSString stringWithFormat:@"productFilter%ld.png",(long)index];
        }else{
            bgImage =[NSString stringWithFormat:@"productFilter%ld.png",(long)index];
        }
        [cell.filterBtn setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
        //[cell.filterBtn setTitle:[cat_name_array objectAtIndex:indexPath.row] forState:UIControlStateNormal];

        return  cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if(collectionView.tag == 1)
    {
        //Main collectionview
            GiftDetailVC *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"GiftDetailVC"];
            vc.selectedDic = [responseListArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
    }else{
        //Filter collectionview
//        [self getMarketItems:@"0" :@"0" :[NSString stringWithFormat:@"%@",[cat_id_array objectAtIndex:indexPath.row]]];
    }
}


//MARK:- TAB BAR DELEGATES
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
    {
        if (isSelected)
        {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->isSelected = NO;
                self->menu.frame=CGRectMake(-290, 0, 275,self-> deviceHieght);
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(0, 625, 275, 335);
}

- (IBAction)searchTap:(id)sender {
    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];
    vc.searchType = @"gifts";
    [self.navigationController pushViewController:vc animated:false];
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
    [Utility addtoplist:@"" key:@"login" plist:@"iq"];

    //Resetting 'skipped user' value
    [Utility addtoplist:@"NO"key:@"skippedUser" plist:@"iq"];


    [self.navigationController presentViewController:view animated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
