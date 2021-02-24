//
//  TermsAndConditionsVC.m
//  IamQatar
//
//  Created by User on 12/07/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import "TermsAndConditionsVC.h"
#import "MarketDetailViewController.h"
#import "constants.pch"
#import "UIImageView+WebCache.h"
#import "ProductListViewCell.h"
#import "ProductFilterCollectionViewCell.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SearchViewController.h"
#import "IamQatar-Swift.h"

@interface TermsAndConditionsVC ()

@end

@implementation TermsAndConditionsVC{

    NSArray *titleArray;
    NSArray *desArray;
    UITextView *descriptionLabel1;
    UITextView *descriptionLabel2;
    UITextView *descriptionLabel3;

    UIView *cell1;
    UIView *cell2;
    UIView *cell3;

    UILabel *titleLabel1;
    UILabel *titleLabel2;
    UILabel *titleLabel3;

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
    self.title = @"TERMS OF USE";

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

    //Banner shadow & corner radius
    _bannerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _bannerView.layer.shadowRadius = 4.0f;
    _bannerView.layer.shadowOffset = CGSizeZero;
    _bannerView.layer.shadowOpacity = 0.8f;
    _bannerView.clipsToBounds = false;

    _imgBanner.clipsToBounds = true;
    _imgBanner.layer.cornerRadius = 10;

    [self getTermsAndConditiions];
    
    _bannerViewHeightConstraint.constant = self.view.frame.size.width / 1.7;

}

-(void)viewWillAppear:(BOOL)animated{

    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Terms & Conditions screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    //-----hiding tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;
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


//MARK:- MENU SWIPE METHOD
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
-(void)getTermsAndConditiions {

    if ([Utility reachable]) {

        [ProgressHUD show];

        NSString *urlString;
        //   NSDictionary *param;

        urlString = [NSString stringWithFormat:@"%@%@",parentURL,getTerms];
        //        param = [NSDictionary dictionaryWithObjectsAndKeys:startHere,@"start",countHere,@"count",Id,@"category_id", nil];

        // NSLog(@"%@",param);
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             NSLog(@"JSON: %@", responseObject);

             if ([text isEqualToString: @"Success!"])  {


                 NSString *termsDescription;
                 NSString *faqDescription;
                 NSString *policyDescription;

                 NSString *termsTitle;
                 NSString *faqTitle;
                 NSString *policyTitle;

                 faqDescription = [[[[responseObject valueForKey:@"value"] valueForKey:@"faq"] objectAtIndex:0] valueForKey:@"description"];
                 termsDescription = [[[[responseObject valueForKey:@"value"] valueForKey:@"terms"] objectAtIndex:0] valueForKey:@"description"];
                 policyDescription = [[[[responseObject valueForKey:@"value"] valueForKey:@"privacy_policy"] objectAtIndex:0] valueForKey:@"description"];

                 self->desArray = [NSArray arrayWithObjects:policyDescription,termsDescription,faqDescription, nil];


                 faqTitle = [[[[responseObject valueForKey:@"value"] valueForKey:@"faq"] objectAtIndex:0] valueForKey:@"title"];
                 termsTitle = [[[[responseObject valueForKey:@"value"] valueForKey:@"terms"] objectAtIndex:0] valueForKey:@"title"];
                 policyTitle = [[[[responseObject valueForKey:@"value"] valueForKey:@"privacy_policy"] objectAtIndex:0] valueForKey:@"title"];

                 self->titleArray = [NSArray arrayWithObjects:policyTitle,termsTitle,faqTitle, nil];

                 [self setUI];

             }else{

             }

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

//MARK:- METHODS
- (void)addShadowTo:(UIView*)view{

    UIView *shadowView = [[UIView alloc] initWithFrame:view.frame];
    shadowView.tag = 123;

    [shadowView.layer setShadowOffset:CGSizeZero];
    [shadowView.layer setShadowOpacity:0.9];
    [shadowView.layer setShadowColor:[[UIColor grayColor]CGColor]];

    shadowView.backgroundColor = [UIColor whiteColor];
    [view.superview addSubview:shadowView];
    shadowView.layer.cornerRadius = view.layer.cornerRadius;
    [view.superview bringSubviewToFront:view];

}
-(void)setUI{

    cell1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.cellContainerView.frame.size.width - 0, 45)];



    [self.cellContainerView addSubview:cell1];

    [cell1.layer setShadowOffset:CGSizeZero];
    [cell1.layer setShadowOpacity:0.9];
    [cell1.layer setShadowColor:[[UIColor grayColor]CGColor]];
    cell1.backgroundColor = UIColor.whiteColor;

    cell1.layer.cornerRadius = 7;
    //cell1.clipsToBounds = true;
    //[self addShadowTo:cell1];
    cell1.tag = 10;


    titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell1.frame.size.width - 55, cell1.frame.size.height)];
    titleLabel1.font = [[titleLabel1 font] fontWithSize:16];
    titleLabel1.text = titleArray[0];
    [cell1 addSubview:titleLabel1];


    UIImageView *downArrowImgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel1.frame.size.width + titleLabel1.frame.origin.x, 0, 45 , 45)];
    downArrowImgView1.image = [UIImage imageNamed:@"dropDownSquareType"];
    downArrowImgView1.contentMode = UIViewContentModeScaleAspectFill;
    [cell1 addSubview:downArrowImgView1];

    descriptionLabel1 = [[UITextView alloc] initWithFrame:CGRectMake(cell1.frame.origin.x + 8, cell1.frame.origin.y + cell1.frame.size.height + 8, cell1.frame.size.width - 8, 0)];
    //descriptionLabel1.numberOfLines = 0;
    descriptionLabel1.font = [descriptionLabel1.font fontWithSize:14];
    [self.cellContainerView addSubview:descriptionLabel1];

    cell2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + descriptionLabel1.frame.origin.y + descriptionLabel1.frame.size.height, self.cellContainerView.frame.size.width - 0, 45)];

    [self.cellContainerView addSubview:cell2];
    cell2.layer.cornerRadius = 7;
    //cell2.clipsToBounds = true;
    // [self addShadowTo:cell2];

    [cell2.layer setShadowOffset:CGSizeZero];
    [cell2.layer setShadowOpacity:0.9];
    [cell2.layer setShadowColor:[[UIColor grayColor]CGColor]];
    cell2.backgroundColor = UIColor.whiteColor;
    cell2.tag = 10;

    titleLabel2= [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell2.frame.size.width - 55, cell2.frame.size.height)];
    titleLabel2.font = [[titleLabel2 font] fontWithSize:16];
    titleLabel2.text =  titleArray[1];
    [cell2 addSubview:titleLabel2];
    UIImageView *downArrowImgView2= [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel2.frame.size.width + titleLabel2.frame.origin.x, 0, 45 , 45)];
    downArrowImgView2.image = [UIImage imageNamed:@"dropDownSquareType"];
    downArrowImgView2.contentMode = UIViewContentModeScaleAspectFill;
    [cell2 addSubview:downArrowImgView2];

    descriptionLabel2 = [[UITextView alloc] initWithFrame:CGRectMake(cell2.frame.origin.x + 8, cell2.frame.origin.y + cell2.frame.size.height+8, cell2.frame.size.width - 8 , 0)];
    //descriptionLabel2.numberOfLines = 0;
    descriptionLabel2.font = [descriptionLabel2.font fontWithSize:14];
    [self.cellContainerView addSubview:descriptionLabel2];


    cell3 = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + descriptionLabel2.frame.origin.y + descriptionLabel2.frame.size.height, self.cellContainerView.frame.size.width - 0, 45)];
    [self.cellContainerView addSubview:cell3];
    cell3.layer.cornerRadius = 7;
    //cell3.clipsToBounds = true;
    // [self addShadowTo:cell3];

    [cell3.layer setShadowOffset:CGSizeZero];
    [cell3.layer setShadowOpacity:0.9];
    [cell3.layer setShadowColor:[[UIColor grayColor]CGColor]];
    cell3.backgroundColor = UIColor.whiteColor;
    cell3.tag = 10;

    titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell3.frame.size.width - 55, cell3.frame.size.height)];
    titleLabel3.font = [[titleLabel3 font] fontWithSize:16];
    titleLabel3.text = titleArray[2];
    [cell3 addSubview:titleLabel3];
    UIImageView *downArrowImgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel3.frame.size.width + titleLabel3.frame.origin.x, 0, 45 , 45)];
    downArrowImgView3.image = [UIImage imageNamed:@"dropDownSquareType"];
    downArrowImgView3.contentMode = UIViewContentModeScaleAspectFill;
    [cell3 addSubview:downArrowImgView3];


    descriptionLabel3 = [[UITextView alloc] initWithFrame:CGRectMake(cell3.frame.origin.x + 8 , cell3.frame.origin.y + cell3.frame.size.height+8, cell3.frame.size.width - 8 , 0)];
    //descriptionLabel3.numberOfLines = 0;
    descriptionLabel3.font = [descriptionLabel3.font fontWithSize:14];
    [self.cellContainerView addSubview:descriptionLabel3];


    UITapGestureRecognizer *cellTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(cellTap1:)];
    [cell1 addGestureRecognizer:cellTap1];

    UITapGestureRecognizer *cellTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(cellTap2:)];
    [cell2 addGestureRecognizer:cellTap2];

    UITapGestureRecognizer *cellTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(cellTap3:)];
    [cell3 addGestureRecognizer:cellTap3];



}

- (void)cellTap1:(UITapGestureRecognizer *)recognizer
{

    cell2.tag = 10;
    cell3.tag = 10;

    descriptionLabel1.scrollEnabled = NO;
    descriptionLabel1.alpha = 0;
    descriptionLabel1.userInteractionEnabled = YES;
    descriptionLabel1.selectable = YES;
    descriptionLabel1.dataDetectorTypes = UIDataDetectorTypeAll;
    descriptionLabel1.editable = NO;
    descriptionLabel1.tintColor = [UIColor blueColor];

    if(cell1.tag == 10){
        descriptionLabel1.alpha = 0;

        NSString *str = [desArray[0] stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: 'SFUIDisplay-Bold'; font-size:14.0px; color:'gray'}</style>"]];

        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

        descriptionLabel1.attributedText = attrStr;
        [descriptionLabel1 sizeToFit];

        [UIView animateWithDuration:0.5 animations:^{

            self->cell1.frame = CGRectMake(0, 10, self.cellContainerView.frame.size.width , 45);
            self->descriptionLabel1.frame = CGRectMake(self->descriptionLabel1.frame.origin.x, self->cell1.frame.origin.y + self->cell1.frame.size.height+8, self->descriptionLabel1.frame.size.width, self->descriptionLabel1.frame.size.height);

            self->cell2.frame = CGRectMake(0, 10 + self->descriptionLabel1.frame.origin.y + self->descriptionLabel1.frame.size.height, self.cellContainerView.frame.size.width - 0, 45);
            self->descriptionLabel2.frame = CGRectMake(self->descriptionLabel2.frame.origin.x, self->cell2.frame.origin.y + self->cell2.frame.size.height, self->descriptionLabel2.frame.size.width, 0);

            self->cell3.frame = CGRectMake(0, 10 + self->descriptionLabel2.frame.origin.y + self->descriptionLabel2.frame.size.height, self.cellContainerView.frame.size.width - 0, 45);
            self->descriptionLabel3.frame = CGRectMake(self->descriptionLabel3.frame.origin.x, self->cell3.frame.origin.y + self->cell3.frame.size.height, self->descriptionLabel3.frame.size.width, 0);

            self->descriptionLabel1.alpha = 1;

            [self.view layoutIfNeeded];
        }];
        cell1.tag = 20;
    }else{
        descriptionLabel1.alpha = 1;

        [UIView animateWithDuration:0.5 animations:^{
            self->descriptionLabel1.alpha = 0;

            // descriptionLabel1.text = @"";
            // [descriptionLabel1 sizeToFit];

            self->cell1.frame = CGRectMake(0, 10, self.cellContainerView.frame.size.width , 45);
            self->descriptionLabel1.frame = CGRectMake(self->descriptionLabel1.frame.origin.x, self->cell1.frame.origin.y + self->cell1.frame.size.height+8, self->descriptionLabel1.frame.size.width, 0);

            self->cell2.frame = CGRectMake(0, 10 + self->descriptionLabel1.frame.origin.y + self->descriptionLabel1.frame.size.height, self.cellContainerView.frame.size.width - 0, 45);
            self->descriptionLabel2.frame = CGRectMake(self->descriptionLabel3.frame.origin.x, self->cell2.frame.origin.y + self->cell2.frame.size.height+8, self->descriptionLabel3.frame.size.width, 0);

            self->cell3.frame = CGRectMake(0, 10 + self->descriptionLabel2.frame.origin.y + self->descriptionLabel2.frame.size.height, self.cellContainerView.frame.size.width - 0, 45);
            self->descriptionLabel3.frame = CGRectMake(self->descriptionLabel3.frame.origin.x, self->cell3.frame.origin.y + self->cell3.frame.size.height+8, self->descriptionLabel3.frame.size.width, 0);


            [self.view layoutIfNeeded];

        }];

        cell1.tag = 10;
    }

    self.cellContainerView.frame = CGRectMake(self.cellContainerView.frame.origin.x, self.cellContainerView.frame.origin.y, self.cellContainerView.frame.size.width,  descriptionLabel3.frame.origin.y + descriptionLabel3.frame.size.height);
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, descriptionLabel3.frame.origin.y + descriptionLabel3.frame.size.height + 250)];



}
- (void)cellTap2:(UITapGestureRecognizer *)recognizer
{
    cell1.tag = 10;
    cell3.tag = 10;
    //[self.mainScrollView setContentOffset:CGPointZero animated:true];
    descriptionLabel2.scrollEnabled = NO;
    descriptionLabel2.alpha = 0;
    descriptionLabel2.userInteractionEnabled = YES;
    descriptionLabel2.selectable = YES;
    descriptionLabel2.dataDetectorTypes = UIDataDetectorTypeAll;
    descriptionLabel2.editable = NO;
    descriptionLabel2.tintColor = [UIColor blueColor];

    if(cell2.tag == 10){
        descriptionLabel2.alpha = 0;

        NSString *str = [desArray[1] stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: 'SFUIDisplay-Bold'; font-size:14.0px;}</style>"]];

        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

        descriptionLabel2.attributedText =  attrStr;
        [descriptionLabel2 sizeToFit];

        [UIView animateWithDuration:0.5 animations:^{

            self->cell1.frame = CGRectMake(0, 10, self.cellContainerView.frame.size.width , 45);
            self->descriptionLabel1.frame = CGRectMake(self->descriptionLabel1.frame.origin.x, self->cell1.frame.origin.y + self->cell1.frame.size.height+8, self->descriptionLabel1.frame.size.width, 0);

            self->cell2.frame = CGRectMake(0, 10 + self->descriptionLabel1.frame.origin.y + self->descriptionLabel1.frame.size.height, self.cellContainerView.frame.size.width - 0, 45);
            self->descriptionLabel2.frame = CGRectMake(self->descriptionLabel2.frame.origin.x, self->cell2.frame.origin.y + self->cell2.frame.size.height+8, self->descriptionLabel2.frame.size.width, self->descriptionLabel2.frame.size.height);

            self->cell3.frame = CGRectMake(0, 10 + self->descriptionLabel2.frame.origin.y + self->descriptionLabel2.frame.size.height, self.cellContainerView.frame.size.width - 0, 45);
            self->descriptionLabel3.frame = CGRectMake(self->descriptionLabel3.frame.origin.x, self->cell3.frame.origin.y + self->cell3.frame.size.height+8, self->descriptionLabel3.frame.size.width, 0);

            self->descriptionLabel2.alpha = 1;

            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {

            //[self.mainScrollView setContentOffset:CGPointMake(0, cell2.frame.origin.y + cell2.frame.size.height) animated:true];
            [self.mainScrollView setContentOffset:CGPointZero animated:true];
            //[self.mainScrollView setContentOffset: CGPointMake(0, -self.mainScrollView.contentInset.top) animated:YES];
            //[self.mainScrollView setContentOffset:CGPointMake(0, cell2.frame.origin.y + cell2.frame.size.height + (self.mainScrollView.frame.size.height/2)) animated:true];
            //[self.mainScrollView setContentOffset:CGPointMake(0, self.cellContainerView.frame.origin.y) animated:true];
            //[self.mainScrollView setContentOffset:CGPointMake(0, self.imgBanner.frame.origin.y) animated:true];
        }];




        cell2.tag = 20;
    }else{
        descriptionLabel2.alpha = 1;

        [UIView animateWithDuration:0.5 animations:^{
            self->descriptionLabel2.alpha = 0;

            // descriptionLabel1.text = @"";
            // [descriptionLabel1 sizeToFit];

            self->cell1.frame = CGRectMake(0, 10, self.cellContainerView.frame.size.width , 45);
            self->descriptionLabel1.frame = CGRectMake(self->descriptionLabel1.frame.origin.x, self->cell1.frame.origin.y + self->cell1.frame.size.height+8, self->descriptionLabel1.frame.size.width, 0);

            self->cell2.frame = CGRectMake(0, 10 + self->descriptionLabel1.frame.origin.y + self->descriptionLabel1.frame.size.height, self.cellContainerView.frame.size.width - 0, 45);
            self->descriptionLabel2.frame = CGRectMake(self->descriptionLabel3.frame.origin.x, self->cell2.frame.origin.y + self->cell2.frame.size.height+8, self->descriptionLabel3.frame.size.width, 0);

            self->cell3.frame = CGRectMake(0, 10 + self->descriptionLabel2.frame.origin.y + self->descriptionLabel2.frame.size.height, self.cellContainerView.frame.size.width - 0, 45);
            self->descriptionLabel3.frame = CGRectMake(self->descriptionLabel3.frame.origin.x, self->cell3.frame.origin.y + self->cell3.frame.size.height+8, self->descriptionLabel3.frame.size.width, 0);


            [self.view layoutIfNeeded];

        }];

        cell2.tag = 10;
    }

    self.cellContainerView.frame = CGRectMake(self.cellContainerView.frame.origin.x, self.cellContainerView.frame.origin.y, self.cellContainerView.frame.size.width,  descriptionLabel3.frame.origin.y + descriptionLabel3.frame.size.height);
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, descriptionLabel3.frame.origin.y + descriptionLabel3.frame.size.height + 250)];

}
- (void)cellTap3:(UITapGestureRecognizer *)recognizer
{
    cell1.tag = 10;
    cell2.tag = 10;
    //[self.mainScrollView setContentOffset:CGPointZero animated:true];
    descriptionLabel3.scrollEnabled = NO;
    descriptionLabel3.alpha = 0;
    descriptionLabel3.userInteractionEnabled = YES;
    descriptionLabel3.selectable = YES;
    descriptionLabel3.dataDetectorTypes = UIDataDetectorTypeAll;
    descriptionLabel3.editable = NO;
    descriptionLabel3.tintColor = [UIColor blueColor];

    if(cell3.tag == 10){

         NSString *str = [desArray[2] stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: 'SFUIDisplay-Bold'; font-size:14.0px;}</style>"]];

        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        descriptionLabel3.attributedText = attrStr;
        [descriptionLabel3 sizeToFit];

        [UIView animateWithDuration:0.5 animations:^{

            self->cell1.frame = CGRectMake(0, 10, self.cellContainerView.frame.size.width , 45);
            self->descriptionLabel1.frame = CGRectMake(self->descriptionLabel1.frame.origin.x, self->cell1.frame.origin.y + self->cell1.frame.size.height+8, self->descriptionLabel1.frame.size.width, 0);

            self->cell2.frame = CGRectMake(0, 10 + self->descriptionLabel1.frame.origin.y + self->descriptionLabel1.frame.size.height, self.cellContainerView.frame.size.width - 0, 45);
            self->descriptionLabel2.frame = CGRectMake(self->descriptionLabel2.frame.origin.x, self->cell2.frame.origin.y + self->cell2.frame.size.height+8, self->descriptionLabel2.frame.size.width, 0);

            self->cell3.frame = CGRectMake(0, 10 + self->descriptionLabel2.frame.origin.y + self->descriptionLabel2.frame.size.height, self.cellContainerView.frame.size.width - 0, 45);
            self->descriptionLabel3.frame = CGRectMake(self->descriptionLabel3.frame.origin.x, self->cell3.frame.origin.y + self->cell3.frame.size.height+8, self->descriptionLabel3.frame.size.width, self->descriptionLabel3.frame.size.height);

            self->descriptionLabel3.alpha = 1;

            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {

            //[self.mainScrollView setContentOffset:CGPointMake(0, cell2.frame.origin.y + cell2.frame.size.height) animated:true];
            [self.mainScrollView setContentOffset:CGPointZero animated:true];
            //[self.mainScrollView setContentOffset: CGPointMake(0, -self.mainScrollView.contentInset.top) animated:YES];
            //[self.mainScrollView setContentOffset:CGPointMake(0, cell2.frame.origin.y + cell2.frame.size.height + (self.mainScrollView.frame.size.height/2)) animated:true];
            //[self.mainScrollView setContentOffset:CGPointMake(0, self.cellContainerView.frame.origin.y) animated:true];
            //[self.mainScrollView setContentOffset:CGPointMake(0, self.imgBanner.frame.origin.y) animated:true];
        }];




        cell3.tag = 20;
    }else{
        descriptionLabel3.alpha = 1;

        [UIView animateWithDuration:0.5 animations:^{
            self->descriptionLabel2.alpha = 0;

            // descriptionLabel1.text = @"";
            // [descriptionLabel1 sizeToFit];

            self->cell1.frame = CGRectMake(0, 10, self.cellContainerView.frame.size.width , 45);
            self->descriptionLabel1.frame = CGRectMake(self->descriptionLabel1.frame.origin.x, self->cell1.frame.origin.y + self->cell1.frame.size.height+8, self->descriptionLabel1.frame.size.width, 0);

            self->cell2.frame = CGRectMake(0, 10 + self->descriptionLabel1.frame.origin.y + self->descriptionLabel1.frame.size.height, self.cellContainerView.frame.size.width - 0, 45);
            self->descriptionLabel2.frame = CGRectMake(self->descriptionLabel3.frame.origin.x, self->cell2.frame.origin.y + self->cell2.frame.size.height+8, self->descriptionLabel3.frame.size.width, 0);

            self->cell3.frame = CGRectMake(0, 10 + self->descriptionLabel2.frame.origin.y + self->descriptionLabel2.frame.size.height, self.cellContainerView.frame.size.width - 0, 45);
            self->descriptionLabel3.frame = CGRectMake(self->descriptionLabel3.frame.origin.x, self->cell3.frame.origin.y + self->cell3.frame.size.height+8, self->descriptionLabel3.frame.size.width, 0);


            [self.view layoutIfNeeded];

        }];

        cell3.tag = 10;
    }

    self.cellContainerView.frame = CGRectMake(self.cellContainerView.frame.origin.x, self.cellContainerView.frame.origin.y, self.cellContainerView.frame.size.width,  descriptionLabel3.frame.origin.y + descriptionLabel3.frame.size.height);
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, descriptionLabel3.frame.origin.y + descriptionLabel3.frame.size.height + 250)];
}

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
