//
//  MarketDetailViewController.m
//  IamQatar
//
//  Created by alisons on 9/5/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "MarketDetailViewController.h"
#import "constants.pch"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "EXPhotoViewer.h"
#import <QuartzCore/QuartzCore.h>
#import "cartViewController.h"
#import "checkOutViewController.h"
#import "IamQatar-Swift.h"

@interface MarketDetailViewController ()

@end

@implementation MarketDetailViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;


    NSArray     *productImagesArray;
    NSString    *productTitle;
    NSString    *stockAvailable;
    int         max_quantity;
    float       productPrice;
    NSString    *productDescription;
    NSArray     *productAttributesArray;
    NSArray     *sizeArray;
    NSArray     *colorArray;
    NSArray     *timeForGiftDeliveryArray;//giftDeliveryTimeArray
    NSMutableArray *fullUrlArray;
    NSDictionary *productDetails;
    NSString *variantID;
    NSString *cartStatus;


    NSString *selectedColor;
    NSString *selectedSize;

    NSString *strOffer;
    NSString *strCuponCode;
}


//MARK:- VIEW DID LOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    
    [self.cartBtn addGradientWithColorOne:nil colorTwo:nil];
    [self.cartBtn addCornerRadius:3];
    
    [self.qtyPickerContView addBorder:1 :UIColor.lightGrayColor];
        
    //[self.view addTarget: self action: @selector(bgTapAction:) forControlEvents: UIControlEventTouchUpInside];

    //kolamazz : erase data in "selectedGiftData" userdefaults
    [[NSUserDefaults standardUserDefaults]setValue: nil forKey:@"selectedGiftData"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    self.offersView.backgroundColor = [UIColor whiteColor];
    self.offersView.hidden = YES;

    selectedColor = [NSString stringWithFormat:@"0"];
    selectedSize  = [NSString stringWithFormat:@"0"];

    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapAction:)];
    singleFingerTap.delegate = self;
    [self.view addGestureRecognizer:singleFingerTap];

    deviceHieght = [[UIScreen mainScreen] bounds].size.height;

    //--------setting menu frame---------//
    isSelected = NO;
    menu = [[Menu alloc]init];
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


    //_btnQty.layer.borderWidth = 1;
    //_btnQty.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _btnSizeDropDown.layer.borderWidth = 1;
    _btnSizeDropDown.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //_btnSizeDropDown.layer.cornerRadius = 10.0;

    _btnColorDropDown.layer.borderWidth = 1;
    _btnColorDropDown.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //_btnColorDropDown.layer.cornerRadius = 10.0;

     NSLog(@"Selected>%@",_selectedProductId);

//    UIColor *gradOneStartColor = [UIColor colorWithRed:245/255.f green:133/255.f blue:169/255.f alpha:1.0];
//    UIColor *gradOneEndColor   = [UIColor colorWithRed:244/255.0 green:177/255.0 blue:153/255.0 alpha:1.0];
//
//    CAGradientLayer *gradLayer = [CAGradientLayer layer];
//    gradLayer.frame = _commonPickerView.bounds;
//    gradLayer.startPoint = CGPointZero;
//    gradLayer.endPoint = CGPointMake(1, 1);
//    gradLayer.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];
//    [_commonPickerView.layer insertSublayer:gradLayer above:_commonPickerView.layer];

    //self.colorPickerView.backgroundColor = [UIColor lightGrayColor];
    self.colorPickerView.layer.cornerRadius = 8;
    self.colorPickerView.layer.masksToBounds=YES;
    

    //self.sizePickerView.backgroundColor = [UIColor lightGrayColor];
    self.sizePickerView.layer.cornerRadius = 8;
    self.sizePickerView.layer.masksToBounds=YES;


    [self getProductDetailsCall:0 :^(BOOL finished) {
        if(finished){

            NSString *variantsStr = [[NSString alloc]init];
            variantsStr = [NSString stringWithFormat:@"%@",[[self->productDetails valueForKey:@"allvariants"]valueForKey:@"terms"]];
            variantsStr = [variantsStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            variantsStr = [variantsStr stringByReplacingOccurrencesOfString:@"()" withString:@""];

            //If variant products are there
            if([variantsStr length]>1)
            {
                self->colorArray = [[[self->productDetails valueForKey:@"allvariants"] objectAtIndex:0] valueForKey:@"terms"];
                

//                if ([[[[productDetails valueForKey:@"allvariants"]valueForKey:@"terms"] objectAtIndex:0]valueForKey:@"newattr"]){
//                    sizeArray = [[[[[[productDetails valueForKey:@"allvariants"]valueForKey:@"terms"] objectAtIndex:0]valueForKey:@"newattr"]valueForKey:@"terms"]objectAtIndex:0];
//
//                }
                
                
                NSArray *sizeStrArray = [[NSArray alloc]init];
                sizeStrArray = [[[[[[self->productDetails valueForKey:@"allvariants"]valueForKey:@"terms"]objectAtIndex:0]valueForKey:@"newattr"]valueForKey:@"terms"]objectAtIndex:0];
                
                NSLog(@"%@",sizeStrArray);
                
                if(![sizeStrArray isEqual:[NSNull null]]){
                    self->sizeArray = [[[[[[self->productDetails valueForKey:@"allvariants"]valueForKey:@"terms"] objectAtIndex:0]valueForKey:@"newattr"]valueForKey:@"terms"]objectAtIndex:0];
                }
                
            }


            [self setContentView];

            //sliding imageView
            self->_bannerView.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
            self->_bannerView.pageControl.tintColor = [UIColor lightGrayColor];
            self->_bannerView.imageCounterDisabled = YES;
            self->_bannerView.pageControl.pageIndicatorTintColor = [UIColor grayColor];

            self->_lblTitle.text = self->productTitle;
            self.title = self->productTitle;
            self->_lblPrice.text = [NSString stringWithFormat:@"%.02f QAR",self->productPrice];

            //HTML String
            //Converting HTML string with UTF-8 encoding to NSAttributedString
            NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                    initWithData: [self->productDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                                    options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                    documentAttributes: nil
                                                    error: nil ];

            self->_tvDesciption.attributedText = attributedString;//productDescription;
            [self->_tvDesciption sizeToFit];

            CGRect frame = self->_tvDesciption.frame;
            frame.size.height = self->_tvDesciption.contentSize.height;
            self->_tvDesciption.frame = frame;

            if(self->max_quantity>0){
                [self->_btnQty setTitle:@"1" forState:UIControlStateNormal];
            }else{
                [self->_btnQty setTitle:@"0" forState:UIControlStateNormal];
            }

            //Setting scrollview Hieght
            self.mainScrollView.scrollEnabled = YES;
            [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.tvDesciption.frame.origin.y + self.tvDesciption.frame.size.height+20)];
            
            
        }

        //OFFER BAR
        if( ![self->strOffer isEqualToString:@""] ){
            self.offersView.hidden = NO;
            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Get an extra %@%% Off",self->strOffer]];
            [str1 addAttribute:NSFontAttributeName  value:[UIFont fontWithName:@"SFCompactDisplay-Bold" size:20]  range:NSMakeRange(12, self->strOffer.length + 6)];
            NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" Use code : %@",self->strCuponCode]];
            [str2 addAttribute:NSFontAttributeName  value:[UIFont fontWithName:@"SFCompactDisplay-Bold" size:20]   range:NSMakeRange(12, self->strCuponCode.length)];
            [str1 appendAttributedString:str2];
            self.lblOffer.attributedText = str1;

            UIColor *gradOneStartColor = [UIColor colorWithRed:245/255.f green:133/255.f blue:169/255.f alpha:1.0];
            UIColor *gradOneEndColor   = [UIColor colorWithRed:244/255.0 green:177/255.0 blue:153/255.0 alpha:1.0];

            CAGradientLayer *gradLayer = [CAGradientLayer layer];
            gradLayer.frame = self->_offersView.bounds;
            gradLayer.startPoint = CGPointZero;
            gradLayer.endPoint = CGPointMake(1, 1);
            gradLayer.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];
            [self->_offersView.layer insertSublayer:gradLayer below:self->_lblOffer.layer];
            self->_priceAndqtyView.frame = CGRectMake(self->_priceAndqtyView.frame.origin.x, self->_priceAndqtyView.frame.origin.y + 35, self->_priceAndqtyView.frame.size.width, self->_priceAndqtyView.frame.size.height);
        }else{
//            CGRect newFrame = self.ImageContainer.frame;
//            newFrame.size.height = self.ImageContainer.frame.size.height+_offersView.frame.size.height;
//            [self.ImageContainer setFrame:newFrame];
        }
    }];
}


- (void) viewDidAppear:(BOOL)animated
{
    //sliding imageView
    _bannerView.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    _bannerView.pageControl.tintColor = [UIColor lightGrayColor];
    _bannerView.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:true];
    //kolamazz : Add gift to cart after selecting date,time etc from delivery details page
    NSDictionary *selectedGiftData = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedGiftData"];
    //NSLog(@"selected gift data>%lu", selectedGiftData);
    NSLog(@"selected gift data : %@", [selectedGiftData description]);
    if (selectedGiftData != nil){
        [self addToCart];
    }
    
    
    NSString *plistVal = [[NSString alloc]init];
    plistVal = [NSString stringWithFormat:@"%@",[Utility getfromplist:@"skippedUser" plist:@"iq"]];

    if([plistVal isEqualToString:@"YES"]){
        [menu.btnLogout setTitle:@"Log In" forState:UIControlStateNormal];
    }else{
        [menu.btnLogout setTitle:@"Log Out" forState:UIControlStateNormal];
    }

    self.pageIndicator.backgroundColor = [UIColor clearColor];

    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Product detail page"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;

    cartStatus = @"";
}

-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame = CGRectMake(-290, 0, 275, deviceHieght);
}


-(void)changeDateFromLabel:(id)sender
{

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


//MARK:- PICKERVIEW DELEGATES
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView
                  numberOfRowsInComponent:(NSInteger)component {
    if(thePickerView == self.colorPickerView){
        //NSLog(@"color terms>%lu", [colorArray count]);
        return [colorArray count];
    }else{
        //NSLog(@"sizearray count %lu",(unsigned long)[sizeArray count]);
        return [sizeArray count] ;
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    NSArray *arrayForPickerView;
    NSString *currentAttributeTerms = [productDetails valueForKey:@"current_attribute_terms"];
    NSArray *currentArrtibuteTermsArray = [currentAttributeTerms componentsSeparatedByString:@","];

    if(pickerView == self.colorPickerView){

        if ([currentArrtibuteTermsArray count] > 0 ){
            for(int i = 0; i < [currentArrtibuteTermsArray count];++i){

                int termIdOne = 0,termIdTwo;

                if(![[[colorArray valueForKey:@"term_id"]objectAtIndex:row]isEqual:(id)[NSNull null]])
                {
                    termIdOne = [[[colorArray valueForKey:@"term_id"] objectAtIndex:row]intValue];
                }
                termIdTwo = [currentArrtibuteTermsArray[i] intValue];

                if(termIdOne == termIdTwo){
                    self.lblColorDropDown.text = [[colorArray objectAtIndex:row] valueForKey:@"term_label"];
                }else{
                    self.lblColorDropDown.text = [[colorArray objectAtIndex:0] valueForKey:@"term_label"];
                }
            }
        }

        return [[colorArray objectAtIndex:row] valueForKey:@"term_label"];
    }else{


        NSLog(@"sizeArray>%@",sizeArray);
        
        if ([currentArrtibuteTermsArray count] > 0 ){
            for(int i = 0; i < [currentArrtibuteTermsArray count];i++){

                int termIdOne = 0,termIdTwo;
                termIdOne = [[[sizeArray valueForKey:@"term_id"] objectAtIndex:row]intValue];
                termIdTwo = [currentArrtibuteTermsArray[i] intValue];

                if(termIdOne == termIdTwo){
                    self.lblSizeDropDown.text = [[sizeArray objectAtIndex:row] valueForKey:@"term_label"];
                }else{
                    self.lblSizeDropDown.text = [[sizeArray objectAtIndex:0] valueForKey:@"term_label"];
                }
            }
             self.lblSizeDropDown.text = [[sizeArray objectAtIndex:0] valueForKey:@"term_label"];
        }
        return [[sizeArray objectAtIndex:row] valueForKey:@"term_label"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    self.colorPickerView.hidden = true;
    self.sizePickerView.hidden = true;

    if(pickerView == self.colorPickerView){

        if(![[colorArray objectAtIndex:row]isEqual:(id)[NSNull null]])
        {
            sizeArray = nil;
//            sizeArray = [[[[[[productDetails valueForKey:@"allvariants"]valueForKey:@"terms"] objectAtIndex:0]valueForKey:@"newattr"]valueForKey:@"terms"]objectAtIndex:row];
//            NSLog(@"sizearray in didselect>%@",sizeArray);
            
            NSArray *sizeStrArray = [[NSArray alloc]init];
            sizeStrArray = [[[[[[productDetails valueForKey:@"allvariants"]valueForKey:@"terms"] objectAtIndex:0]valueForKey:@"newattr"]valueForKey:@"terms"]objectAtIndex:row];
            
            NSLog(@"%@",sizeStrArray);
            
            if(![sizeStrArray isEqual:[NSNull null]]){
                sizeArray = [[[[[[productDetails valueForKey:@"allvariants"]valueForKey:@"terms"] objectAtIndex:0]valueForKey:@"newattr"]valueForKey:@"terms"]objectAtIndex:row];
            }
            
            
        }else{
            sizeArray = nil;
        }

        self.lblColorDropDown.text = [[colorArray objectAtIndex:row] valueForKey:@"term_label"];
        selectedColor = [NSString stringWithFormat:@"%@",[[colorArray objectAtIndex:row] valueForKey:@"term_id"]];
        [_sizePickerView reloadAllComponents];
    }else{
        self.lblSizeDropDown.text = [[sizeArray objectAtIndex:row] valueForKey:@"term_label"];
        selectedSize = [NSString stringWithFormat:@"%@",[[sizeArray objectAtIndex:row] valueForKey:@"term_id"]];
    }

    [self getProductDetailsCall:1 :^(BOOL finished) {

        [self setBannerImages];
        //sliding imageView
        self->_bannerView.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        self->_bannerView.pageControl.tintColor = [UIColor lightGrayColor];
        self->_bannerView.imageCounterDisabled = YES;
        self->_bannerView.pageControl.pageIndicatorTintColor = [UIColor grayColor];

        self->_lblTitle.text = self->productTitle;
        self->_lblPrice.text = [NSString stringWithFormat:@"%.02f QAR",self->productPrice];


        //HTML Attributed String
        //Converting HTML string with UTF-8 encoding to NSAttributedString
//        NSAttributedString *attributedString = [[NSAttributedString alloc]
//                                                initWithData: [productDescription dataUsingEncoding:NSUnicodeStringEncoding]
//                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
//                                                documentAttributes: nil
//                                                error: nil ];

        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self->productDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

        self->_tvDesciption.attributedText = attributedString;
        [self->_tvDesciption sizeToFit];


        CGRect frame = self->_tvDesciption.frame;
        frame.size.height = self->_tvDesciption.contentSize.height;
        self->_tvDesciption.frame = frame;

        if(self->max_quantity>0){
            [self->_btnQty setTitle:@"1" forState:UIControlStateNormal];
        }else{
            [self->_btnQty setTitle:@"0" forState:UIControlStateNormal];
        }

        //Setting scrollview Hieght
        self.mainScrollView.scrollEnabled = YES;
        [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.tvDesciption.frame.origin.y + self.tvDesciption.frame.size.height+20)];
    }];
}

//MARK:- API CALL
- (void)getProductDetailsCall: (int)tag :(myCompletion)compBlock {

    if ([Utility reachable]) {

        [ProgressHUD show];
        AppDelegate *appDelegate    = (AppDelegate*)[UIApplication sharedApplication].delegate;
        NSString *urlString;


        if(tag == 1) {//variant call
            NSString *mainProductId = [productDetails valueForKey:@"main_product_id"];
            NSString *attrTerms;

            if ([selectedSize isEqualToString:@"0"] ){
                attrTerms = [NSString stringWithFormat:@"%@",selectedColor];
            }else if ([selectedColor isEqualToString:@"0"]){
                attrTerms = [NSString stringWithFormat:@"%@",selectedSize];
            }else{
                attrTerms = [NSString stringWithFormat:@"%@,%@",selectedSize,selectedColor];
            }

            urlString = [NSString stringWithFormat:@"%@%@&product_id=%@&attr_terms=%@",parentURL,variantsAPI,mainProductId,attrTerms];

        }else{
            urlString = [NSString stringWithFormat:@"%@api.php?page=getProductDetails&product_id=%@&user_id=%@",parentURL,_selectedProductId,[appDelegate.userProfileDetails objectForKey:@"user_id"]];
        }

//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:[NSString stringWithFormat:@"%@",urlString] parameters:nil headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];

             NSLog(@"%@",responseObject);

             if ([text isEqualToString: @"Success!"])
             {
                 self->productDetails = [responseObject objectForKey:@"value"];

                 if([[self->productDetails valueForKey:@"images"] count] > 0){
                     self->productImagesArray = [[self->productDetails valueForKey:@"images"]valueForKey:@"imagepath"];
                 }

                 self->productTitle        = [[responseObject objectForKey:@"value"] valueForKey:@"product_name"];
                 self->stockAvailable      = [[responseObject objectForKey:@"value"] valueForKey:@"outofstock"];
                 self->productPrice        = [[[responseObject objectForKey:@"value"] valueForKey:@"newprice"]floatValue];
                 
                 if([self->_isGift isEqualToString:@"true"]){
                     self->productDescription  = [[responseObject objectForKey:@"value"] valueForKey:@"description"];
                 }else{
                     self->productDescription  = [[responseObject objectForKey:@"value"] valueForKey:@"product_description"];
                 }
                 
                 //productDescription  = [[responseObject objectForKey:@"value"] valueForKey:@"product_description"];
                 self->variantID           = [[responseObject objectForKey:@"value"] valueForKey:@"variant_id"];
                 self->strCuponCode        = [[responseObject objectForKey:@"value"] valueForKey:@"coupon_code"];
                 self->strOffer            = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"value"] valueForKey:@"coupon_discount"]];
                 self->max_quantity        = [[[responseObject objectForKey:@"value"] valueForKey:@"quantity"]intValue];
                 self->timeForGiftDeliveryArray = [responseObject objectForKey:@"timeslote"];
                 
                 self.colorPickerView.hidden = true;
                 self.sizePickerView.hidden = true;


                 //No stock view for 'out of stock' item
                 int isOutOfStock = [self->stockAvailable intValue];
                 if(isOutOfStock == 1)
                 {
                     self->_viewNoStockAvailable.hidden = NO;
                     [self->_cartBtn setTitle:@"Sold out" forState:UIControlStateNormal];
                     
                 }else{
                     [self->_cartBtn setTitle:@"Add to Cart" forState:UIControlStateNormal];
                     self->_viewNoStockAvailable.hidden = YES;
                 }

                 //If item not available now
                 if([self->productTitle length]<1)
                 {
                     UIAlertController * alert = [UIAlertController  alertControllerWithTitle:@"IamQatar" message:@"Item not found!" preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction* okButton = [UIAlertAction  actionWithTitle:@"Ok"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                         [ProgressHUD dismiss];
                         [self.navigationController popViewControllerAnimated:YES];
                     }];

                     //Add your buttons to alert controller
                     [alert addAction:okButton];
                     [self presentViewController:alert animated:YES completion:nil];

                 }else{
                     [ProgressHUD dismiss];
                 }
             }else{
                 [AlertController alertWithMessage:@"No records found!" presentingViewController:self];
             }
             NSLog(@"JSON: %@", responseObject);
             compBlock(YES);
             [ProgressHUD dismiss];

         } failure:^(NSURLSessionTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
             [ProgressHUD dismiss];
         }];
    }
    else{
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}

- (void)addToCart {
    
//    if ([[productDetails valueForKey:@"exist_cart"]integerValue]==1 || [cartStatus isEqualToString:@"IN"]) {
//        cartViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"cartView"];
//        [self.navigationController pushViewController:view animated:YES];
//
//    }else
//    {
    
    
    if ([Utility reachable]) {
        
        [ProgressHUD show];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        NSDictionary *parameters = @{@"user_id": [appDelegate.userProfileDetails objectForKey:@"user_id"], @"quantity": _btnQty.titleLabel.text, @"product_id": _selectedProductId,@"variant_id":variantID};
        
        //kolamazz : add gift parameters to existing parameters
        NSMutableDictionary *selectedGiftData = [[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedGiftData"] mutableCopy];
        NSLog(@"selected gift data : %@", [selectedGiftData description]);
        [selectedGiftData addEntriesFromDictionary:parameters];
        NSLog(@"parameters : %@", [selectedGiftData description]);
        
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,addTocart] parameters:_isGift ? selectedGiftData : parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject){
            NSString *text = [responseObject objectForKey:@"code"];
            NSString *msg  = [responseObject objectForKey:@"text"];
            
            if ([text isEqualToString: @"200"])
            {
                //kolamazz : erase data in "selectedGiftData" userdefaults
                [[NSUserDefaults standardUserDefaults]setValue: nil forKey:@"selectedGiftData"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                int badgeValue = [[[[responseObject objectForKey:@"value"] objectForKey:@"count"] objectForKey:@"count"] intValue];
                
                if (badgeValue != 0) {
                    NSString * value=[NSString stringWithFormat:@"%i",badgeValue];
                    [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:value];
                }
                else{
                    [[[[[self tabBarController] tabBar] items]objectAtIndex:3] setBadgeValue:nil];
                }
                //  fullCategoryDetails = [responseObject objectForKey:@"value"];
                //[_cartBtn setTitle:@"GO TO CART" forState:UIControlStateNormal];
                self->cartStatus = @"IN";
                
                
                NSString *badgeStr = [NSString stringWithFormat:@"%d",badgeValue];
                [Utility addtoplist:badgeStr key:@"cartCount" plist:@"iq"];
                [AlertController alertWithMessage:@"Added to bag!" presentingViewController:self];
                
            }
            else
            {
                //[AlertController alertWithMessage:msg presentingViewController:self];
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
    
    
//    }
}





//MARK:- METHODS
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

        x = x+[[UIScreen mainScreen] bounds].size.width;
        [self.bannerScrollView addSubview:img];
    }
    self.bannerScrollView.contentSize=CGSizeMake(x, self.bannerScrollView.frame.size.height);
    self.bannerScrollView.contentOffset=CGPointMake(0, 0);

}
- (void)setContentView {

    [self setBannerImages];

    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(imageTap:)];
    [self.bannerScrollView addGestureRecognizer:imageTap];

    NSString *currentAttributeTerms = [productDetails valueForKey:@"current_attribute_terms"];
    NSArray *currentArrtibuteTermsArray = [currentAttributeTerms componentsSeparatedByString:@","];
    NSLog(@"%@",currentArrtibuteTermsArray);

    if([sizeArray count] > 0 && [colorArray count]>0){

        self.btnColorDropDown.hidden = false;
        self.arrowColorDropDown.hidden = false;
        self.lblColorDropDown.hidden = false;

        self.btnSizeDropDown.hidden = false;
        self.arrowSizeDropDown.hidden = false;
        self.lblSizeDropDown.hidden = false;


        [self.colorPickerView reloadAllComponents];
        [self.sizePickerView reloadAllComponents];

    }else if ([colorArray count] > 0 && [sizeArray count] < 1){

        self.btnColorDropDown.hidden = false;
        self.arrowColorDropDown.hidden = false;
        self.lblColorDropDown.hidden = false;

        self.btnSizeDropDown.hidden = true;
        self.arrowSizeDropDown.hidden = true;
        self.lblSizeDropDown.hidden = true;


        [self.colorPickerView reloadAllComponents];
        [self.sizePickerView reloadAllComponents];

    }else{

        self.btnColorDropDown.hidden = true;
        self.arrowColorDropDown.hidden = true;
        self.lblColorDropDown.hidden = true;

        self.btnSizeDropDown.hidden = true;
        self.arrowSizeDropDown.hidden = true;
        self.lblSizeDropDown.hidden = true;

        [self.colorPickerView reloadAllComponents];
        [self.sizePickerView reloadAllComponents];
    }
}

//MARK:- BTN ACTIONS
- (IBAction)itemAddCartAction:(id)sender
{
    
    //No stock view for 'out of stock' item
    int isOutOfStock = [stockAvailable intValue];
    
    //check if item is already in cart
    if ([[productDetails valueForKey:@"exist_cart"]integerValue]==1 || [cartStatus isEqualToString:@"IN"]) {
        
        //cartViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"cartView"];
        CartNewViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"CartNewViewController"];
        [self.navigationController pushViewController:view animated:YES];
        
    }else if (isOutOfStock == 0){
        
        if (_isGift){ //_isGift = @"true";
            
            //kolamazz . show gift delivert details page
            GiftDeliveryDetailsViewController *vc = [[GiftDeliveryDetailsViewController alloc]init];
            //vc.
            
            [[NSUserDefaults standardUserDefaults]setValue:timeForGiftDeliveryArray forKey:@"giftTimeArray"];
            [[NSUserDefaults standardUserDefaults]setValue: [productDetails valueForKey:@"delivery_date"] forKey:@"minimumAvailableDateForGiftDelivery"];//extra number of days needed for order delivery. add this much date with current date to get minimum possible delivery date
            [[NSUserDefaults standardUserDefaults]setValue: [productDetails valueForKey:@"delivery_time"] forKey:@"minimumAvailableTimeForGiftDelivery"];
            [[NSUserDefaults standardUserDefaults]setValue: [productDetails valueForKey:@"current_date"] forKey:@"currentDate"];
            //[[NSUserDefaults standardUserDefaults]setValue: _selectedProductId forKey:@"giftId"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self.navigationController pushViewController:vc animated:YES];
            
//            [vc setModalPresentationStyle:UIModalPresentationFormSheet];
//            [self presentViewController:vc animated:true completion:nil];
            
            //        [self.view addSubview:vc.view];
            //        [self addChildViewController:vc];
            //        [vc.view layoutIfNeeded];
            //        vc.view.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
            //        [UIView animateWithDuration:0.3 animations:^{
            //            vc.view.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
            //        } completion:^(BOOL finished) {
            //            vc.view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:.3];
            //        }];
            
            
            
        }else{
            
            //Already in cart or not check
            [self addToCart];
            
            
        }
        
    }
    
    
    
    
    
}
- (void)imageTap:(UITapGestureRecognizer *)recognizer
{
    NSString *url =[NSString stringWithFormat:@"%@%@",parentURL,[productImagesArray objectAtIndex:self.pageIndicator.currentPage]];
    UIImageView *image = [[UIImageView alloc] init];
    [image sd_setImageWithURL:[NSURL URLWithString:url]];
    image.contentMode = UIViewContentModeScaleAspectFit;

    [EXPhotoViewer showImageFrom:image];
}

- (IBAction)QtyPlusMinus:(id)sender {

    UIButton *btn = (UIButton*) sender;
    int qty = [_btnQty.titleLabel.text intValue];

    if(btn.tag == 2){
        if(max_quantity > 0){
            if(qty<99){ //maximum qty we can set in the field is 99
                //Checking with maximum available stock
                if(qty+1 > max_quantity){
//                    [AlertController alertWithMessage:[NSString stringWithFormat:@"Maximum available quantity is:%d",qty] presentingViewController:self];
                }else{
                    qty = qty + 1;
                    [_btnQty setTitle:[NSString stringWithFormat:@"%d",qty] forState:UIControlStateNormal];
                }
            }
        }else{  //If no stock available
//             [AlertController alertWithMessage:[NSString stringWithFormat:@"No stock available!"] presentingViewController:self];
        }
    }else if (btn.tag == 1){
        if(qty>1){
            qty = qty - 1;
            [_btnQty setTitle:[NSString stringWithFormat:@"%d",qty] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)offerTapAction:(UIButton *)sender {

    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = strCuponCode;
    [AlertController alertWithMessage:@"Copied to clipboard" presentingViewController:self];

}

- (IBAction)dropDownBtnAction:(UIButton *)sender {

    if(sender.tag == 10){

        if ([self.colorPickerView isHidden] == true){
            //self.sizeDropDownTableView.hidden = false;
            _colorPickerView.hidden = NO;
        }else{
            //self.sizeDropDownTableView.hidden  = true;
            _colorPickerView.hidden = YES;
        }
    }else if(sender.tag == 20){

        if ([self.sizePickerView isHidden] == true){
            //self.colorDropDownTableView.hidden = false;
            _sizePickerView.hidden = NO;
            [_sizePickerView reloadAllComponents];
        }else{
            //self.colorDropDownTableView.hidden  = true;
            _sizePickerView.hidden = YES;
        }
    }
}

- (void)bgTapAction:(UITapGestureRecognizer *)recognizer {

    //    if(recognizer.view != self.colorDropDownTableView){
    //        self.sizeDropDownTableView.hidden = true;
    //        self.colorDropDownTableView.hidden = true;
    //    }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if([touch.view isDescendantOfView:self.sizePickerView]){

        return false;

    }else if([touch.view isDescendantOfView:self.colorPickerView]){

        return false;

    }else if([touch.view isDescendantOfView:menu.menuTableView]){
        return false;
    }else{

        self.colorPickerView.hidden = true;
        self.sizePickerView.hidden = true;
        return true;
    }

}
//MARK:- SCROLLVIEW DELEGATES
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _colorPickerView.hidden = YES;
    _sizePickerView.hidden  = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    CGFloat width = self.bannerScrollView.frame.size.width;
    NSInteger page = (self.bannerScrollView.contentOffset.x + (0.5f * width)) / width;

    self.pageIndicator.currentPage = page;

}



//MARK:- TABLE VEIEW DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    if(tableView == self.colorDropDownTableView){
//        return [[[[productDetails valueForKey:@"variations"] objectAtIndex:0] valueForKey:@"terms"] count];
//    }else{
//        return [[[[productDetails valueForKey:@"variations"] objectAtIndex:1] valueForKey:@"terms"] count];
//    }

    return 0;
}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//    UITableViewCell *cell;
//
//    cell = [[UITableViewCell alloc] init];
//
//    NSArray *arrayForTableView;
//
//    NSString *currentAttributeTerms = [productDetails valueForKey:@"current_attribute_terms"];
//    NSArray *currentArrtibuteTermsArray = [currentAttributeTerms componentsSeparatedByString:@","];
//    NSLog(@"%@",currentArrtibuteTermsArray);
//
//
//    if(tableView == self.colorDropDownTableView){
//
//        arrayForTableView = [[[productDetails valueForKey:@"allvariants"] objectAtIndex:0] valueForKey:@"terms"];
//        if ([currentArrtibuteTermsArray count] > 0 ){
//            for(int i = 0; i < [currentArrtibuteTermsArray count];++i){
//
//                int termIdOne = [[[arrayForTableView valueForKey:@"term_id"] objectAtIndex:indexPath.row]intValue];
//                int termIdTwo = [currentArrtibuteTermsArray[i] intValue];
//
//                if(termIdOne == termIdTwo){
//                    self.lblColorDropDown.text = [[arrayForTableView objectAtIndex:indexPath.row] valueForKey:@"term_label"];
//                }
//            }
//        }
//
//    }else{
//
//        arrayForTableView = [[[[[[productDetails valueForKey:@"allvariants"]valueForKey:@"terms"] objectAtIndex:0]valueForKey:@"newattr"]valueForKey:@"terms"]objectAtIndex:0];
//        NSLog(@"arrayForTable>%@",arrayForTableView);
//
//        if ([currentArrtibuteTermsArray count] > 0 ){
//            for(int i = 0; i < [currentArrtibuteTermsArray count];++i){
//
//                int termIdOne = [[[arrayForTableView valueForKey:@"term_id"] objectAtIndex:indexPath.row]intValue];
//                int termIdTwo = [currentArrtibuteTermsArray[i] intValue];
//
//                if(termIdOne == termIdTwo){
//                    self.lblSizeDropDown.text = [[arrayForTableView objectAtIndex:indexPath.row] valueForKey:@"term_label"];
//                }
//            }
//        }
//
//    }
//
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    //cell.backgroundColor = UIColor.lightGrayColor;
//    cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
//    cell.textLabel.text = [[arrayForTableView objectAtIndex:indexPath.row] valueForKey:@"term_label"];
//    return cell;
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 35;
//
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    self.colorDropDownTableView.hidden = true;
//    self.sizeDropDownTableView.hidden = true;
//
//    if(tableView == self.colorDropDownTableView){
//        NSArray *arrayForTableView = [[[productDetails valueForKey:@"allvariants"] objectAtIndex:0] valueForKey:@"terms"];
//
//        self.lblColorDropDown.text = [[arrayForTableView objectAtIndex:indexPath.row] valueForKey:@"term_label"];
//        selectedColor = [NSString stringWithFormat:@"%@",[[arrayForTableView objectAtIndex:indexPath.row] valueForKey:@"term_id"]];
//
//    }else{
//        NSArray *arrayForTableView = [[[[[[productDetails valueForKey:@"allvariants"]valueForKey:@"terms"] objectAtIndex:0]valueForKey:@"newattr"]valueForKey:@"terms"]objectAtIndex:0];
//        NSLog(@"arrayForTable>%@",arrayForTableView);
//
//        self.lblSizeDropDown.text = [[arrayForTableView objectAtIndex:indexPath.row] valueForKey:@"term_label"];
//        selectedSize = [NSString stringWithFormat:@"%@",[[arrayForTableView objectAtIndex:indexPath.row] valueForKey:@"term_id"]];
//    }
//
//    [self getProductDetailsCall:1 :^(BOOL finished) {
//
//        //sliding imageView
//        _bannerView.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
//        _bannerView.pageControl.tintColor = [UIColor lightGrayColor];
//        _bannerView.imageCounterDisabled = YES;
//        _bannerView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
//
//        _lblTitle.text = productTitle;
//        _lblPrice.text = [NSString stringWithFormat:@"%.02f QAR",productPrice];
//        _tvDesciption.text = productDescription;
//        [_tvDesciption sizeToFit];
//
//        CGRect frame = _tvDesciption.frame;
//        frame.size.height = _tvDesciption.contentSize.height;
//        _tvDesciption.frame = frame;
//
//        [_btnQty setTitle:@"1" forState:UIControlStateNormal];
//
//        //Setting scrollview Hieght
//        self.mainScrollView.scrollEnabled = YES;
//        [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.tvDesciption.frame.origin.y + self.tvDesciption.frame.size.height+20)];
//    }];
//}


//MARK:- KIIMAGE PICKER DELEGATE
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    fullUrlArray = [[NSMutableArray alloc]init];
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


//MARK:- TEXT FIELD DELEGATES
-(BOOL) textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
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
        plistVal = [NSString stringWithFormat:@"%@",[Utility getfromplist:@"skippedUser" plist:@"iq"]];

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
    plistVal = [NSString stringWithFormat:@"%@",[Utility getfromplist:@"skippedUser" plist:@"iq"]];

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
    plistVal = [NSString stringWithFormat:@"%@",[Utility getfromplist:@"skippedUser" plist:@"iq"]];

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
    plistVal = [NSString stringWithFormat:@"%@",[Utility getfromplist:@"skippedUser" plist:@"iq"]];

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



/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
