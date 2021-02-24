//
//  GiftDetailVC.m
//  IamQatar
//
//  Created by User on 17/09/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import "GiftDetailVC.h"
#import "constants.pch"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "EXPhotoViewer.h"
#import "IamQatar-Swift.h"

@interface GiftDetailVC ()

@end

@implementation GiftDetailVC
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;
    NSArray *productImagesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];

    NSLog(@"selected gift details: %@",_selectedDic);
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

    _btnQty.layer.borderWidth = 1;
    _btnQty.layer.borderColor = [[UIColor lightGrayColor] CGColor];


    //Pickers
    self.qtyPickerView.layer.cornerRadius = 8;
    self.qtyPickerView.layer.masksToBounds=YES;
    self.timePickerView.layer.cornerRadius = 8;
    self.timePickerView.layer.masksToBounds=YES;
    self.datePicker.layer.cornerRadius = 8;
    self.datePicker.layer.masksToBounds=YES;


    //Qty textfield
    _qtyTxt.delegate = self;
    _qtyTxt.layer.borderWidth = 1.0f;
    _qtyTxt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_qtyTxt.layer setCornerRadius:14.0f];
    _qtyTxt.textAlignment = NSTextAlignmentCenter;
    _qtyTxt.placeholder = @"Quantity";

    _qtyTxt.layer.masksToBounds = false;
    _qtyTxt.layer.shadowRadius = 2.0;
    _qtyTxt.layer.shadowColor = [[UIColor blackColor] CGColor];
    _qtyTxt.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    _qtyTxt.layer.shadowOpacity = 0.3;

    //Delivery date textfield
    _deliverDateTxt.delegate = self;
    _deliverDateTxt.layer.borderWidth = 1.0f;
    _deliverDateTxt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_deliverDateTxt.layer setCornerRadius:14.0f];
    _deliverDateTxt.textAlignment = NSTextAlignmentCenter;
    _deliverDateTxt.placeholder = @"Delivery Date";

    _deliverDateTxt.layer.masksToBounds = false;
    _deliverDateTxt.layer.shadowRadius = 2.0;
    _deliverDateTxt.layer.shadowColor = [[UIColor blackColor] CGColor];
    _deliverDateTxt.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    _deliverDateTxt.layer.shadowOpacity = 0.3;

    //Delivery time textfield
    _deliverTimeTxt.delegate = self;
    _deliverTimeTxt.layer.borderWidth = 1.0f;
    _deliverTimeTxt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_deliverTimeTxt.layer setCornerRadius:14.0f];
    _deliverTimeTxt.textAlignment = NSTextAlignmentCenter;
    _deliverTimeTxt.placeholder = @"Delivery Time";

    _deliverTimeTxt.layer.masksToBounds = false;
    _deliverTimeTxt.layer.shadowRadius = 2.0;
    _deliverTimeTxt.layer.shadowColor = [[UIColor blackColor] CGColor];
    _deliverTimeTxt.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    _deliverTimeTxt.layer.shadowOpacity = 0.3;

    //Setting textfields for picker
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.qtyTxt.inputView = self.datePicker;

    //Sliding imageView
    _bannerView.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _bannerView.pageControl.tintColor = [UIColor lightGrayColor];
    _bannerView.imageCounterDisabled = YES;
    _bannerView.pageControl.pageIndicatorTintColor = [UIColor grayColor];

    _lblTitle.text = [_selectedDic valueForKey:@"product_name"];
    NSString *price = [_selectedDic valueForKey:@"price"];
    float priceVal = [price intValue];
    _lblPrice.text = [NSString stringWithFormat:@"%.02f QAR",priceVal];
    _tvDesciption.text = [_selectedDic valueForKey:@"description"];;
    [_tvDesciption sizeToFit];

    CGRect frame = _tvDesciption.frame;
    frame.size.height = _tvDesciption.contentSize.height;
    _tvDesciption.frame = frame;
    [_btnQty setTitle:@"1" forState:UIControlStateNormal];

    //Setting scrollview Hieght
    self.mainScrollView.scrollEnabled = YES;
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.tvDesciption.frame.origin.y + self.tvDesciption.frame.size.height+20)];

    productImagesArray  = [[_selectedDic valueForKey:@"images"]valueForKey:@"imagepath"];
    [self setContentView];
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

    self.pageIndicator.backgroundColor = [UIColor clearColor];

    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Gift detail page"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated
{
    //sliding imageView
    _bannerView.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    _bannerView.pageControl.tintColor = [UIColor lightGrayColor];
    _bannerView.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
}
-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame = CGRectMake(-290, 0, 275, deviceHieght);
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

//MARK:- KIIMAGE PICKER DELEGATE
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    NSMutableArray *fullUrlArray = [[NSMutableArray alloc]init];

    for (int i=0; i<[productImagesArray count]; i++)
    {
        NSString *url =[NSString stringWithFormat:@"%@%@",parentURL,[productImagesArray objectAtIndex:i]];
        [fullUrlArray addObject:url];
    };
    NSArray *returnArray = [fullUrlArray copy];
    return returnArray;
}
- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleToFill;
}

- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
    //     NSString *urlString = [fullUrlArray objectAtIndex:index];
    //    _popUpimage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]]];
}


//MARK:- BTN ACTIONS
- (void)imageTap:(UITapGestureRecognizer *)recognizer
{
    NSString *url =[NSString stringWithFormat:@"%@%@",parentURL,[productImagesArray objectAtIndex:self.pageIndicator.currentPage]];
    UIImageView *image = [[UIImageView alloc] init];
    [image sd_setImageWithURL:[NSURL URLWithString:url]];
    image.contentMode = UIViewContentModeScaleAspectFit;

    [EXPhotoViewer showImageFrom:image];
}
- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = datePicker.date;
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:eventDate];

    self.deliverDateTxt.text = [NSString stringWithFormat:@"%@",dateString];
}

//MARK:- METHODS
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == _qtyTxt){
        _qtyPickerView.hidden = NO;
    }else if(textField == _deliverDateTxt){
        _datePicker.hidden = NO;
    }else{
        _timePickerView.hidden = NO;
    }
    return false;
}

- (void)setContentView {

    [self setBannerImages];

    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(imageTap:)];
    [self.bannerScrollView addGestureRecognizer:imageTap];
}
- (void)setBannerImages {

    self.bannerScrollView.showsHorizontalScrollIndicator = false;
    self.pageIndicator.currentPage = 0;
    [self.mainScrollView bringSubviewToFront:self.pageIndicator];
    self.pageIndicator.numberOfPages = [productImagesArray count];
    self.pageIndicator.userInteractionEnabled = false;
    self.pageIndicator.backgroundColor = [UIColor clearColor];

    self.pageIndicator.frame = CGRectMake(self.bannerScrollView.frame.origin.x, self.bannerScrollView.frame.origin.y + self.bannerScrollView.frame.size.height - 10, self.bannerScrollView.frame.size.width, 50);


    int x=0;
    self.bannerScrollView.pagingEnabled=YES;
    // NSArray *image=[[NSArray alloc]initWithObjects:@"1.png",@"2.png",@"3.png", nil];
    for (int i=0; i<productImagesArray.count; i++)
    {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0,[[UIScreen mainScreen] bounds].size.width, self.bannerScrollView.frame.size.height)];

        NSString *url =[NSString stringWithFormat:@"%@%@",parentURL,[productImagesArray objectAtIndex:i]];
        [img sd_setImageWithURL:[NSURL URLWithString:url]];
        img.contentMode = UIViewContentModeScaleAspectFit;

        x=x+[[UIScreen mainScreen] bounds].size.width;
        [self.bannerScrollView addSubview:img];
    }
    self.bannerScrollView.contentSize=CGSizeMake(x, self.bannerScrollView.frame.size.height);
    self.bannerScrollView.contentOffset=CGPointMake(0, 0);

}

- (void)setTags : (UIView *)view array:(NSArray *)array {

    view.backgroundColor = UIColor.clearColor;
    NSLog(@"array: %@",array);

    CGFloat xPos = 0;
    CGFloat yPos = 0;
    CGFloat height = 17;


    for (int i = 0; i < array.count; i++) {


        UILabel *label = [[UILabel alloc]init];
        UIView *bgView = [[UIView alloc]init];

        bgView.layer.cornerRadius = 10;
        bgView.clipsToBounds = true;

        label.text = [NSString stringWithFormat:@"%@",array[i]];
        label.font = [label.font fontWithSize:12];
        label.textColor = UIColor.whiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 10;
        label.clipsToBounds = true;

        float width = 7 * label.text.length;
        label.frame = CGRectMake(xPos, yPos, width + 20, height);
        xPos = xPos + width + 25;

        if (xPos < view.frame.size.width){

            bgView.frame = label.frame;

            [view addSubview:bgView];
            [view addSubview:label];

        }else{

            xPos = 0;
            yPos = yPos + height + 5;
            label.frame = CGRectMake(xPos, yPos, width + 20, height);
            xPos = xPos + width + 25;

            bgView.frame = label.frame;

            [view addSubview:bgView];
            [view addSubview:label];
            [view layoutIfNeeded];
        }
    }

    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,view.frame.size.width, yPos + height + 5);
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

//MARK:- PICKERVIEW DELEGATES
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component {
    if(thePickerView == self.qtyPickerView){
        return 100;
    }else {
        return 3;
    }
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{

    self.qtyPickerView.hidden = true;
    self.datePicker.hidden = true;
    self.timePickerView.hidden = true;

    if(pickerView == self.qtyPickerView){


    }else{

    }
}

//MARK:- SCROLLVIEW DELEGATES
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _timePickerView.hidden = YES;
    _datePicker.hidden  = YES;
    _qtyPickerView.hidden  = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    CGFloat width = self.bannerScrollView.frame.size.width;
    NSInteger page = (self.bannerScrollView.contentOffset.x + (0.5f * width)) / width;
    self.pageIndicator.currentPage = page;
}


//MARK:- POP UP MENU DELEGATES
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
