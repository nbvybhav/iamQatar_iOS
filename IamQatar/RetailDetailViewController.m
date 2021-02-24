//
//  RetailDetailViewController.m
//  IamQatar
//
//  Created by alisons on 9/5/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "RetailDetailViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "IamQatar-Swift.h"

@interface RetailDetailViewController ()

@end

@implementation RetailDetailViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    NSInteger imageIndex ;
    int deviceHieght;
}

//MARK:- VIEW DIDLOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    //[self.navigationController setNavigationBarHidden:FALSE animated:YES];
    
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

    NSString *urlString = [[NSString alloc]init];
    if([_position length]>0){
        int index = [_position intValue];
       urlString = [NSString stringWithFormat:@"%@%@",parentURL,[_flipsArray objectAtIndex:index]];
    }else{
       urlString = [NSString stringWithFormat:@"%@%@",parentURL,[_flipsArray objectAtIndex:0]];
    }

    NSURL *imageURL = [NSURL URLWithString:urlString];
    self.swipingImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.swipingImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"gallery.png"]];
    //self.swipingImageView.image = [UIImage imageNamed:@"about_us_banner.png"];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:true];
    //[self.navigationController setNavigationBarHidden:true];
    
    NSString *plistVal = [[NSString alloc]init];
    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];

    if([plistVal isEqualToString:@"YES"]){
        [menu.btnLogout setTitle:@"Log In" forState:UIControlStateNormal];
    }else{
        [menu.btnLogout setTitle:@"Log Out" forState:UIControlStateNormal];
    }
    if (![Utility reachable])
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }

    imageIndex = 0;
    if(imageIndex == ([_flipsArray count]-1))
    {
        _rightArrow.hidden = YES;
        _leftArrow.hidden  = YES;
    }else{
        _rightArrow.hidden = NO;
        _leftArrow.hidden  = YES;
    }

    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    //[self.navigationController setNavigationBarHidden:false];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
//    menuHideTap.enabled = NO;
        [menu setHidden:YES];
//    isSelected = NO;
//    menu.frame=CGRectMake(-290, 0, 275, 335);
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MARK:- IMAGE SWIPING & ZOOMING METHODS
- (IBAction)arrowSwipe:(id)sender {
    
    UIButton *btn = (UIButton *) sender;
    NSLog(@"tag>%ld",(long)btn.tag);
    int btnTag = (int)btn.tag ;
    
    switch (btnTag) {
        case 1:
            if(imageIndex != ([_flipsArray count]-1)){
                imageIndex++;
            }
            break;
        case 0:
            if(imageIndex != 0){
                imageIndex--;
            }
            break;
        default:
            break;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,[_flipsArray objectAtIndex:imageIndex]];
    NSURL *imageURL = [NSURL URLWithString:urlString];
    [self.swipingImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"login-page_icon"]];
    self.swipingImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    (imageIndex == ([_flipsArray count]-1)) ? ( _rightArrow.hidden = YES):( _rightArrow.hidden = NO);
    (imageIndex == 0) ? (_leftArrow.hidden = YES):(_leftArrow.hidden = NO);
}

-(IBAction)swipeHandler:(UIGestureRecognizer *)sender
{
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *) sender direction];
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            if(imageIndex != ([_flipsArray count]-1)){
                imageIndex++;
            }
            break;
        case UISwipeGestureRecognizerDirectionRight:
            if(imageIndex != 0){
                imageIndex--;
            }
            break;
        default:
            break;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,[_flipsArray objectAtIndex:imageIndex]];
    NSURL *imageURL = [NSURL URLWithString:urlString];
    [self.swipingImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"gallery.png"]];
    
    
    (imageIndex == ([_flipsArray count]-1)) ? ( _rightArrow.hidden = YES):( _rightArrow.hidden = NO);
    (imageIndex == 0) ? (_leftArrow.hidden = YES):(_leftArrow.hidden = NO);
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.swipingImageView;
}

//MARK:- TAB BAR DELEGATES

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
-(void)ContactUs:(Menu *)sender{
    ContactUsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)goTermsOfUse:(Menu *)sender{
    TermsAndConditionsVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsAndConditionsVC"];
    [self.navigationController pushViewController:view animated:YES];
}
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
-(void)GoProfilePage:(Menu *)sender{
    ProfileViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)GoAboutUsPage:(Menu *)sender{
    AboutUsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutUsView"];
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
