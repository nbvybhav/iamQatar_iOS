//
//  contestViewController.m
//  IamQatar
//
//  Created by alisons on 12/11/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "contestViewController.h"
#import "constants.pch"
#import "Utility.h"
#import "UIButton+Property.h"
#import <QuartzCore/QuartzCore.h>
#import "RetailDetailViewController.h"
#import "IamQatar-Swift.h"

@interface contestViewController ()

@end

@implementation contestViewController 
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    NSMutableArray *qArray;
    NSMutableArray *ansArray;
    NSMutableArray *idArray;
    NSMutableDictionary *selectedDict;
    NSString *titleString;

    BOOL attendedAll;
    int deviceHieght;

    NSMutableArray *bannerLinkTypeArray;
    NSMutableArray *bannerPageLinkArray;
    NSMutableArray *bannerClickRedirectIdArray;
    NSArray *bannersArray;
    NSArray *bannerTitleArray;
    NSArray *bnnerDescArray;
}

//MARK: - VIEW DIDLOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CONTEST";
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    
    selectedDict = [[NSMutableDictionary alloc]init];
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

    _btnRules.layer.cornerRadius =6.0;
    _btnRules.clipsToBounds = NO;

    [self getContest:^(BOOL finished) {
        if(finished){
            //sliding imageView
            NSLog(@"print:%@",[NSString stringWithFormat:@"%@",[self->bannerTitleArray objectAtIndex:0]]);
            self->_lblTitle.text = [NSString stringWithFormat:@"%@",[self->bannerTitleArray objectAtIndex:0]];
            self->_lblDesc.text  = [NSString stringWithFormat:@"%@",[self->bnnerDescArray objectAtIndex:0]];
            self->_bannerView.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
            self->_bannerView.pageControl.pageIndicatorTintColor = [UIColor blackColor];
            self->_bannerView.slideshowTimeInterval = 5.5f;
            self->_bannerView.slideshowShouldCallScrollToDelegate = YES;
            self->_bannerView.imageCounterDisabled = YES;
        }
    }];
    
    _bannerViewHeightConstraint.constant = self.view.frame.size.width / 1.7;

}

-(void) viewWillAppear:(BOOL)animated
{
    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Contest"];
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

    //clearing plist
    for(int i=0;i<[qArray count];i++)
    {
        [Utility addtoplist:@"" key:[NSString stringWithFormat:@"Q%d",i+1] plist:@"contestList"];
    }
}


//MARK: - MENU SWIPE METHODS
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

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    NSMutableArray *fullUrlArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[bannersArray count]; i++)
    {
        NSString *url =[NSString stringWithFormat:@"%@%@",parentURL,[bannersArray objectAtIndex:i]];
        [fullUrlArray addObject:url];
    };
    NSArray *returnArray = [fullUrlArray copy];
    return returnArray;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleToFill;
}

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
    _lblTitle.text = [NSString stringWithFormat:@"%@",[bannerTitleArray objectAtIndex:index]];
    _lblDesc.text  = [NSString stringWithFormat:@"%@",[bnnerDescArray objectAtIndex:index]];
    [_bannerView bringSubviewToFront:_lblTitle];
    [_bannerView bringSubviewToFront:_lblDesc];
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
    if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"external"]){

        NSString *link = [NSString stringWithFormat:@"%@",[bannerPageLinkArray objectAtIndex:index]];

        if ([link rangeOfString:@"http://"].location == NSNotFound) {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",link]] options:@{} completionHandler:nil];
        } else {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",link]] options:@{} completionHandler:nil];
        }
    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"contest"]){
        contestViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"contestView"];
        [self.navigationController pushViewController:view animated:YES];

    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"product"]){
        MarketDetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"marketDetailView"];
        view.selectedProductId  = [bannerClickRedirectIdArray objectAtIndex:index];
        [self.navigationController pushViewController:view animated:YES];

    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"promo"]){
        RetailViewController *view= [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
        view.pushedFrom = @"categoryItem";
        view.type  = @"";
        view.catId = [bannerClickRedirectIdArray objectAtIndex:index];
        [self.navigationController pushViewController:view animated:YES];

    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"retails"]){
        MarketViewController *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"marketView"];
        NSString *selectedRetailId= [bannerClickRedirectIdArray objectAtIndex:index];
        vc.selectedRetailId = selectedRetailId;
        [self.navigationController pushViewController:vc animated:YES];

    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"events"]){
        EventsList *view = [self.storyboard instantiateViewControllerWithIdentifier:@"eventList"];
        view.eventCatId = [bannerClickRedirectIdArray objectAtIndex:index];
        view.IsCalendar = @"No";
        [self.navigationController pushViewController:view animated:YES];

    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"malls"]){
        MallDetailsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"MallDetailsViewController"];
        view.mallId = [bannerClickRedirectIdArray objectAtIndex:index];
        [self.navigationController pushViewController:view animated:YES];

    }else if([[bannerLinkTypeArray objectAtIndex:index]isEqualToString:@"flyers"]){
        if ([Utility reachable]) {
            [ProgressHUD show];
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            NSString *pid       = [bannerClickRedirectIdArray objectAtIndex:index];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,getFlyers];
            NSDictionary *param = [[NSDictionary alloc]initWithObjectsAndKeys:pid,@"store_id",[appDelegate.userProfileDetails objectForKey:@"user_id"],@"user_id", nil];

//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//            [manager GET:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
             [manager GET:urlString parameters:param headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 NSMutableArray *bannerFlipsArray;
                 NSString *text = [responseObject objectForKey:@"text"];
                 if ([text isEqualToString: @"Success!"])
                 {
                     bannerFlipsArray        = [[responseObject objectForKey:@"flyers"]valueForKey:@"image"];
                 }

                 NSLog(@"JSON response: %@", responseObject);
                 RetailDetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"retailDetailView"];
                 vc.flipsArray = bannerFlipsArray;
                 [self.navigationController pushViewController:vc animated:YES];
                 [ProgressHUD dismiss];

             } failure:^(NSURLSessionTask *task, NSError *error) {
                 NSLog(@"Error: %@", error);
                 [ProgressHUD dismiss];
             }];
        }
    }
    
    
}

//MARK:- METHODS

-(void)setQandA
{
    //sliding imageView
    _bannerView.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _bannerView.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _bannerView.slideshowTimeInterval = 5.5f;
    _bannerView.slideshowShouldCallScrollToDelegate = YES;
    _bannerView.imageCounterDisabled = YES;
    
    //Setting shadow and corner radius for imageview
    _shadowView.backgroundColor = [UIColor clearColor];
    [_shadowView  addSubview:_bannerView];
    [_shadowView addSubview:_bannerView];
    
    _bannerView.layer.masksToBounds = YES;
    _shadowView.layer.masksToBounds = NO;
    
    // set imageview corner
    //_bannerView.layer.cornerRadius = 10.0;
    
    // set avatar imageview border
    [_bannerView.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [_bannerView.layer setBorderWidth: 2.0];
    
    // set holder shadow
    [_shadowView.layer setShadowOffset:CGSizeZero];
    [_shadowView.layer setShadowOpacity:0.5];
    _shadowView.clipsToBounds = NO;
    
    
    UIView *viewForQ;
    CGRect  screenRect  = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight= screenRect.size.height;

    //Title label
    UILabel *lblTitle  = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, screenWidth, 20)];
    lblTitle.textColor = [UIColor darkGrayColor];
    lblTitle.font      = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];
    lblTitle.numberOfLines = 0;
    lblTitle.text = [NSString stringWithFormat:@"%@",titleString];
    [lblTitle sizeToFit];
    [_contestScroll addSubview:lblTitle];

    for (int i=0; i<[qArray count]; i++) {

    viewForQ = [[UIView alloc]initWithFrame:CGRectMake(0,lblTitle.frame.size.height+10+(i*140), screenWidth, 140)];
    //Option labels
    UILabel *Qlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, viewForQ.frame.size.width, 20)];
    Qlabel.text  = [NSString stringWithFormat:@"%d. %@",i+1,[qArray objectAtIndex:i]];
    Qlabel.numberOfLines = 0;
    Qlabel.font  = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    [Qlabel sizeToFit];
    [viewForQ addSubview:Qlabel];



    UILabel *option1 = [[UILabel alloc]initWithFrame:CGRectMake(40, Qlabel.frame.origin.y+Qlabel.frame.size.height, viewForQ.frame.size.width, 30)];
    option1.text = [[ansArray objectAtIndex:i]objectAtIndex:0];
    option1.numberOfLines = 2.0;
    option1.textColor = [UIColor lightGrayColor];
    option1.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    [viewForQ addSubview:option1];

    UILabel *option2 = [[UILabel alloc]initWithFrame:CGRectMake(40, option1.frame.origin.y+option1.frame.size.height, viewForQ.frame.size.width, 30)];
    option2.text = [[ansArray objectAtIndex:i]objectAtIndex:1];
    option2.numberOfLines = 2.0;
    option2.textColor = [UIColor lightGrayColor];
    option2.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    [viewForQ addSubview:option2];

    UILabel *option3;
        NSArray *optionArray1 = [[NSArray alloc]init];
        optionArray1 = [optionArray1 arrayByAddingObjectsFromArray:[ansArray objectAtIndex:i]];

    if([optionArray1 count]>2){
         option3 = [[UILabel alloc]initWithFrame:CGRectMake(40, option2.frame.origin.y+option2.frame.size.height, viewForQ.frame.size.width, 30)];
         option3.text = [NSString stringWithFormat:@"%@",[optionArray1 objectAtIndex:2]];
         option3.numberOfLines = 2.0;
         option3.textColor = [UIColor lightGrayColor];
         option3.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
         [viewForQ addSubview:option3];
    }

    if([optionArray1 count]>3){
         UILabel *option4 = [[UILabel alloc]initWithFrame:CGRectMake(40, option3.frame.origin.y+option3.frame.size.height,viewForQ.frame.size.width, 30)];
         option4.text = [optionArray1 objectAtIndex:3];
         option4.numberOfLines = 2.0;
         option4.textColor = [UIColor lightGrayColor];
         option4.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        [viewForQ addSubview:option4];
    }
    //Selection buttons
    UIButton *selectBtn1;
     selectBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, Qlabel.frame.origin.y+Qlabel.frame.size.height+5, 15, 15)];
    //selectBtn1.backgroundColor = [UIColor lightGrayColor];
    selectBtn1.userInteractionEnabled = YES;
    selectBtn1.tag  = [[[idArray objectAtIndex:i]objectAtIndex:0]integerValue];
    selectBtn1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    selectBtn1.property = [NSString stringWithFormat:@"Q%d",i+1];
    [selectBtn1 setBackgroundImage:[UIImage imageNamed:@"radiooff.png"] forState:UIControlStateNormal];
    [selectBtn1 setBackgroundImage:[UIImage imageNamed:@"radioon.png"] forState:UIControlStateSelected];
    [selectBtn1 addTarget:self action:@selector(optionSelection:) forControlEvents:UIControlEventTouchUpInside];
    // selectBtn1.layer.cornerRadius = 8;
     selectBtn1.clipsToBounds = YES;
     [viewForQ addSubview:selectBtn1];

    UIButton *selectBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(20, option1.frame.origin.y+option1.frame.size.height+5,  15, 15)];
    //selectBtn2.backgroundColor = [UIColor lightGrayColor];
    selectBtn2.userInteractionEnabled = YES;
    selectBtn2.tag  = [[[idArray objectAtIndex:i]objectAtIndex:1]integerValue];
    selectBtn2.property = [NSString stringWithFormat:@"Q%d",i+1];
    [selectBtn2 setBackgroundImage:[UIImage imageNamed:@"radiooff.png"] forState:UIControlStateNormal];
    [selectBtn2 setBackgroundImage:[UIImage imageNamed:@"radioon.png"] forState:UIControlStateSelected];
    [selectBtn2 addTarget:self action:@selector(optionSelection:) forControlEvents:UIControlEventTouchUpInside];
    //selectBtn2.layer.cornerRadius = 8;
    selectBtn2.clipsToBounds = YES;
    [viewForQ addSubview:selectBtn2];

    NSArray *selectedIdArray1 = [[NSArray alloc]init];
    selectedIdArray1 = [selectedIdArray1 arrayByAddingObjectsFromArray:[idArray objectAtIndex:i]];

    if([selectedIdArray1 count]>2)
    {
        UIButton *selectBtn3 = [[UIButton alloc]initWithFrame:CGRectMake(20, option2.frame.origin.y+option2.frame.size.height+5, 15, 15)];
        //selectBtn3.backgroundColor = [UIColor lightGrayColor];
        selectBtn3.userInteractionEnabled = YES;
        selectBtn3.tag  = [[[idArray objectAtIndex:i]objectAtIndex:2]integerValue];
        selectBtn3.property = [NSString stringWithFormat:@"Q%d",i+1];
        [selectBtn3 setBackgroundImage:[UIImage imageNamed:@"radiooff.png"] forState:UIControlStateNormal];
        [selectBtn3 setBackgroundImage:[UIImage imageNamed:@"radioon.png"] forState:UIControlStateSelected];
        [selectBtn3 addTarget:self action:@selector(optionSelection:) forControlEvents:UIControlEventTouchUpInside];
        //selectBtn3.layer.cornerRadius = 8;
        selectBtn3.clipsToBounds = YES;
        [viewForQ addSubview:selectBtn3];
    }

    if([selectedIdArray1 count]> 3)
    {
        UIButton *selectBtn4 = [[UIButton alloc]initWithFrame:CGRectMake(20, option3.frame.origin.y+option3.frame.size.height+5, 15, 15)];
        //selectBtn4.backgroundColor = [UIColor lightGrayColor];
        selectBtn4.userInteractionEnabled = YES;
        selectBtn4.tag  = [[[idArray objectAtIndex:i]objectAtIndex:3]integerValue];
        selectBtn4.property = [NSString stringWithFormat:@"Q%d",i+1];
        [selectBtn4 setBackgroundImage:[UIImage imageNamed:@"radiooff.png"] forState:UIControlStateNormal];
        [selectBtn4 setBackgroundImage:[UIImage imageNamed:@"radioon.png"] forState:UIControlStateSelected];
        [selectBtn4 addTarget:self action:@selector(optionSelection:) forControlEvents:UIControlEventTouchUpInside];
        //selectBtn4.layer.cornerRadius = 8;
        selectBtn4.clipsToBounds = YES;
        [viewForQ addSubview:selectBtn4];
    //    viewForQ.frame =CGRectMake(viewForQ.frame.origin.x, viewForQ.frame.origin.y, viewForQ.frame.size.width, selectBtn4.frame.origin.y+selectBtn4.frame.size.height+40);
    }


    [_contestScroll addSubview:viewForQ];
    [self.view addSubview:_contestScroll];
    [self.tabBarController.view addSubview:menu];
    [self.view layoutIfNeeded];
 }

    //Submit button
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake((screenWidth/2)-75, (viewForQ.frame.origin.y+viewForQ.frame.size.height)+20, 150, 30)];
    
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"new grad.png"] forState:UIControlStateNormal];
    [submitBtn setTitle: @"Submit" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 3;
    submitBtn.clipsToBounds = true;
    [submitBtn setTitleColor: [UIColor blackColor] forState: UIControlStateHighlighted];
    
    submitBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];
    [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.userInteractionEnabled = YES;
    [_contestScroll addSubview:submitBtn];

    //Gradient for 'Submit' button
//    UIColor *gradOneStartColor = [UIColor colorWithRed:244/255.f green:108/255.f blue:122/255.f alpha:1.0];
//    UIColor *gradOneEndColor   = [UIColor colorWithRed:251/255.0 green:145/255.0 blue:86/255.0 alpha:1.0];

//    submitBtn.layer.masksToBounds = YES;
//    submitBtn.layer.cornerRadius  = 15.0;

//    CAGradientLayer *gradientlayerTwo = [CAGradientLayer layer];
//    gradientlayerTwo.frame = submitBtn.bounds;
//    gradientlayerTwo.startPoint = CGPointZero;
//    gradientlayerTwo.endPoint = CGPointMake(1, 1);
//    gradientlayerTwo.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];
//
//    [submitBtn.layer insertSublayer:gradientlayerTwo atIndex:0];

    float sizeOfContent = 0;
    UIView *lLast = [_contestScroll.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    
    sizeOfContent = wd+ht;
    
    _contestScroll.contentSize = CGSizeMake(_contestScroll.frame.size.width, sizeOfContent + 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    //    isSelected = NO;
    //    menu.frame=CGRectMake(0, 625, 275, 335);
}

-(void)optionSelection:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    
    NSString *btnTag = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    NSString *btnProp= [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",btn.property]];
    
    // Unselect all the buttons in the parent view (radio button effect)
    for (UIView *button in btn.superview.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [(UIButton *)button setSelected:NO];
        }
    }
    
    if(btn.selected)
    {
        btn.selected = NO;
        [Utility addtoplist:@"" key:btnProp plist:@"contestList"];
    }else{
        btn.selected = YES;
        [Utility addtoplist:btnTag key:btnProp plist:@"contestList"];
    }
}

-(IBAction)submitAction:(id)sender
{
    if ([Utility reachable]) {
        
        [ProgressHUD show];
         attendedAll = YES;
        
        for(int i=0;i<[qArray count];i++)
        {
            NSString *ans = [Utility getfromplist:[NSString stringWithFormat:@"Q%d",i+1] plist:@"contestList"];

            
            if([ans isEqual:@""]|| !ans)
            {
                attendedAll = NO;
                break;
            }else
            {
                [selectedDict setObject:ans forKey:[NSString stringWithFormat:@"q_%d",i+1]];
            }
        }
        
        if (!attendedAll)
        {
            [AlertController alertWithMessage:@"You must attend all questions to submit!" presentingViewController:self];
             [ProgressHUD dismiss];
        }
        else
        {
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [selectedDict setObject:[appDelegate.userProfileDetails objectForKey:@"user_id"] forKey:@"user_id"];
            NSLog(@"selectedDic:%@",selectedDict);
            
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
            
//            [manager POST:[NSString stringWithFormat:@"%@%@",parentURL,postQuizResultAPI] parameters:selectedDict success:^(AFHTTPRequestOperation *operation, id responseObject)
             [manager POST:[NSString stringWithFormat:@"%@%@",parentURL,postQuizResultAPI] parameters:selectedDict headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 NSLog(@"JSON: %@", responseObject);
                 NSString *text = [responseObject objectForKey:@"text"];
                 
                 if ([text isEqualToString: @"Success!"])
                 {
                     UIAlertController * alert=   [UIAlertController
                                                   alertControllerWithTitle:@"Iam Qatar"
                                                   message:@"Contest submitted successfully!"
                                                   preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction* ok = [UIAlertAction
                                          actionWithTitle:@"OK"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                                          {
                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                              [self.navigationController popViewControllerAnimated:YES];
                                          }];
                     [alert addAction:ok];
                     [self presentViewController:alert animated:YES completion:nil];
                     
                     //cleraing plist after successful submission
                     for(int i=0;i<[self->qArray count];i++)
                     {
                          [Utility addtoplist:@"" key:[NSString stringWithFormat:@"Q%d",i+1] plist:@"contestList"];
                     }
                     //[self setQandA];
                 }
                 [ProgressHUD dismiss];
             }
              failure:^(NSURLSessionTask *task, NSError *error)
             {
                 NSLog(@"Error: %@", error);
                 [ProgressHUD dismiss];
             }];
        }
    }else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}


-(void)getContest:(myCompletion)compBlock{
    
    if ([Utility reachable]) {
    
        [ProgressHUD show];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,getContestAPI] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,getContestAPI] parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             if ([text isEqualToString: @"Success!"])
             {
                 self->titleString  = [[responseObject objectForKey:@"page_data"]valueForKey:@"description"];
                 self->ansArray     = [[[responseObject objectForKey:@"value"] valueForKey:@"answers"]valueForKey:@"answers"];
                 self->qArray       = [[responseObject objectForKey:@"value"]valueForKey:@"question"];
                 self->idArray      = [[[responseObject objectForKey:@"value"] valueForKey:@"answers"]valueForKey:@"ans_id"];
                 self->bannersArray = [[responseObject valueForKey:@"banners"]valueForKey:@"banner"];
                 self->bannerTitleArray = [[responseObject valueForKey:@"banners"]valueForKey:@"title"];
                 self->bnnerDescArray = [[responseObject valueForKey:@"banners"]valueForKey:@"description"];
                 self->bannerLinkTypeArray = [[responseObject valueForKey:@"banners"]valueForKey:@"link_type"];
                 self->bannerPageLinkArray = [[responseObject valueForKey:@"banners"]valueForKey:@"pagelink"];
                 self->bannerClickRedirectIdArray = [[responseObject valueForKey:@"banners"]valueForKey:@"product_id"];
                 
                  compBlock (YES);
                 [self setQandA];
             }else{
                 [AlertController alertWithMessage:@"No records found!" presentingViewController:self];
             }
             NSLog(@"JSON: %@", responseObject);
             
             
             
         } failure:^(NSURLSessionTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
        [ProgressHUD dismiss];
    }else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
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

- (IBAction)rulesAction:(id)sender {
    [self.view addSubview:_popUpView];
    _popUpView.hidden = NO;
}

- (IBAction)dismiss:(id)sender {
     [_popUpView removeFromSuperview];
    _popUpView.hidden = YES;
}


@end
