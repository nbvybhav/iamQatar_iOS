//
//  StoreListViewController.m
//  IamQatar
//
//  Created by User on 27/06/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import "StoreListViewController.h"
#import "constants.pch"
#import "StoreListTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "IamQatar-Swift.h"

@interface StoreListViewController ()

@end

@implementation StoreListViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;
    NSDictionary *store;
    NSArray   *responseStores;
    NSArray   *catIdArray;
    NSArray   *catNameArray;
    NSString  *tagsString;

}

//MARK:- VIEW DID LOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];

    _noRecordsLbl.hidden = YES;

    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];

    menuHideTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    [self.view addGestureRecognizer:menuHideTap];
    menuHideTap.enabled = NO;

    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];

    _searhBar.placeholder = @"Search for Stores..";

}

-(void)viewDidLayoutSubviews{
    self.categoryTableContainerView.hidden = true;

    //Hide 'filter search bar' if it is from 'standard search'
    if([_showFilterBar isEqualToString:@"YES"])
    {
        _BtnSearch.hidden = false;
        _BtnSearch.titleLabel.text = @"Search for stores category";
        _BtnSearch.layer.cornerRadius = 14.0;
        [self addShadowTo:_BtnSearch];

        _imageDownArrow.frame = CGRectMake(_BtnSearch.frame.size.width-20, _BtnSearch.frame.origin.y+(_BtnSearch.frame.size.height/2)-5, _imageDownArrow.frame.size.width, _imageDownArrow.frame.size.height);
        [self.view addSubview:_imageDownArrow];

        self.categoryTableContainerView.frame = CGRectMake(self.BtnSearch.frame.origin.x, (self.BtnSearch.frame.origin.y+self.BtnSearch.frame.size.height)+5 , self.BtnSearch.frame.size.width, 170);
        [self.view layoutIfNeeded];

        _storeListTableView.frame =   CGRectMake(_storeListTableView.frame.origin.x, (self.BtnSearch.frame.origin.y+self.BtnSearch.frame.size.height)+10 , _storeListTableView.frame.size.width, _storeListTableView.frame.size.height);
        [self.view layoutIfNeeded];

    }else{
        _BtnSearch.hidden = true;
        [_BtnSearch removeFromSuperview];
        [_imageDownArrow removeFromSuperview];

        _storeListTableView.frame =   CGRectMake(0,(self.btnMainSearch.frame.origin.y+self.btnMainSearch.frame.size.height)+5 ,self.storeListTableView.frame.size.width, self.storeListTableView.frame.size.height);
        [self.view layoutIfNeeded];
    }

    [self.categoryTableContainerView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [self.categoryTableContainerView.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.categoryTableContainerView.layer setShadowRadius:5.0];
    [self.categoryTableContainerView.layer setShadowOpacity:1];

    self.categoryTableContainerView.layer.cornerRadius = 10;
    self.categoryTableView.layer.cornerRadius = 10;

    catIdArray     = [_categoryArray valueForKey:@"id"];
    catNameArray   = [_categoryArray valueForKey:@"name"];

    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapAction:)];
    singleFingerTap.delegate = self;
    [self.view addGestureRecognizer:singleFingerTap];

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
    [tracker set:kGAIScreenName value:@"Store list inside Mall"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;

    [self getStoresList];
}

-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(-290, 0, 275, deviceHieght);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bgTapAction:(UITapGestureRecognizer *)recognizer {

}

-(void)addShadowTo:(UIView*)view{

    UIView *shadowView = [[UIView alloc] initWithFrame:view.frame];


    [shadowView.layer setShadowOffset:CGSizeZero];
    [shadowView.layer setShadowOpacity:0.5];
    [shadowView.layer setShadowColor:[[UIColor grayColor]CGColor]];

    shadowView.backgroundColor = [UIColor whiteColor];
    [view.superview addSubview:shadowView];
    shadowView.layer.cornerRadius = view.layer.cornerRadius;
    [view.superview bringSubviewToFront:view];
}

//MARK:- BTN ACTIONS
- (IBAction)searchForCatBtnAction:(UIButton *)sender {

    //[_mainScrollView bringSubviewToFront:_categoryTableContainerView];
    //[_mainScrollView bringSubviewToFront:_btnSearchForCat];

    if( _categoryTableContainerView.hidden == true) {
        self.categoryTableContainerView.hidden = false;
        //[self.storeListTableView bringSubviewToFront:self.categoryTableContainerView];
        [self.categoryTableView reloadData];
    }else{
        self.categoryTableContainerView.hidden = true;
        //[self.categoryTableContainerView bringSubviewToFront:self.storeListTableView];
    }
}


//MARK:- API CALL
- (void)getStoresList{

    if([Utility reachable]){

        [ProgressHUD show];
        NSLog(@"categoryId %@, mallId %@",_storeCatId,_mallId);

        NSDictionary *parameters;

        if(_idHere != nil){
            parameters = @{@"id":_idHere};
        }else{
            if(_storeCatId == nil){
                _storeCatId = @"";
            }
            if(_mallId == nil){
                _mallId = @"";
            }

            if([_offerStores  isEqual: @"YES"]){
                parameters = @{@"mall_id":_mallId,@"category_id":_storeCatId,@"offer":@1};
            }else{
                parameters = @{@"mall_id":_mallId,@"category_id":_storeCatId};
            }

        }
        

//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager POST:[NSString stringWithFormat:@"%@%@",parentURL,StoreInMallsAPI] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             NSLog(@"%@",responseObject);

             if ([text isEqualToString: @"Success!"])
             {
                 self->_noRecordsLbl.hidden = YES;
                 self.storeListTableView.hidden = false;
                 NSLog(@"JSON: %@", responseObject);
                 self->responseStores                 = [[responseObject objectForKey:@"value"]valueForKey:@"stores"];
                 [self.storeListTableView reloadData];
             }else{
                 self.storeListTableView.hidden = true;
                 self->_noRecordsLbl.hidden = NO;
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

// MENU SWIPE
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if([touch.view isDescendantOfView:self.categoryTableContainerView]){
        return false;
    }else if([touch.view isDescendantOfView:self.BtnSearch]){
        return false;
    }else if([touch.view isDescendantOfView:menu.menuTableView]){
        return false;
    }else if([touch.view isDescendantOfView:self.storeListTableView]){
        return false;
    }else{
        self.categoryTableContainerView.hidden = true;
        return true;
    }
}

//MARK:- SETTING TAGS
- (void)setTags : (UIView *)view array:(NSArray *)array {

    NSLog(@"array logging: %@",array);

    CGFloat xPos = 0;
    CGFloat yPos = 0;
    CGFloat height = 13;

    UIColor *gradOneStartColor = [UIColor colorWithRed:135/255.f green:245/255.f blue:250/255.f alpha:1.0];
    UIColor *gradOneEndColor   = [UIColor colorWithRed:100/255.0 green:195/255.0 blue:255/255.0 alpha:1.0];
    UIColor *gradTwoStartColor = [UIColor colorWithRed:218/255.0 green:161/255.0 blue:249/255.0 alpha:1.0];
    UIColor *gradTwoEndColor   = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:248/255.0 alpha:1.0];

    for (int i = 0; i < array.count; i++) {


        UILabel *label = [[UILabel alloc]init];
        UIView *bgView = [[UIView alloc]init];

        bgView.layer.cornerRadius = 7;
        bgView.clipsToBounds = true;

        label.text = [NSString stringWithFormat:@"%@",array[i]];
        label.font = [label.font fontWithSize:12];
        label.textColor = UIColor.whiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 10;
        label.clipsToBounds = true;


//        CGRect expectedLabelSize = [label.text boundingRectWithSize:view.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Medium" size:12]} context:nil];

//        CGSize expectedLabelSize = [[NSString stringWithFormat:@"%@",array[i]] sizeWithFont:label.font constrainedToSize:CGSizeMake(view.frame.size.width, height) lineBreakMode:label.lineBreakMode];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping; //set the line break mode
        NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:label.font, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
        
//        CGSize expectedLabelSize = [[NSString stringWithFormat:@"%@",array[i]] boundingRectWithSize:label.frame.size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil].size;
        
        CGSize expectedLabelSize = [[NSString stringWithFormat:@"%@",array[i]] boundingRectWithSize:CGSizeMake(view.frame.size.width, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil].size;

        float width = expectedLabelSize.width;//4.5 * label.text.length
        label.frame = CGRectMake(xPos, yPos, width + 10, height);
        xPos = xPos + width + 15;

        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.startPoint = CGPointMake(0, 0.5);
        gradient.endPoint = CGPointMake(1, 0.5);


        if(i%2 == 0){
            gradient.colors = @[(id)gradTwoStartColor.CGColor, (id)gradTwoEndColor.CGColor];

        }else{
            gradient.colors = @[(id)gradOneStartColor.CGColor, (id)gradOneEndColor.CGColor];
        }


        if (xPos < view.frame.size.width){

            bgView.frame = label.frame;
            gradient.frame = bgView.bounds;
            [bgView.layer insertSublayer:gradient atIndex:0];

            if(![array[i]  isEqual: @""]){
                [view addSubview:bgView];
                [view addSubview:label];
            }

        }
        //        else{
        //
        //            xPos = 0;
        //            yPos = yPos + height + 5;
        //            label.frame = CGRectMake(xPos, yPos, width + 20, height);
        //            xPos = xPos + width + 25;
        //
        //            bgView.frame = label.frame;
        //            gradient.frame = bgView.bounds;
        //            [bgView.layer insertSublayer:gradient atIndex:0];
        //
        //          //  [view addSubview:bgView];
        ////            [view addSubview:label];
        //            [view layoutIfNeeded];
        //
        //        }
    }

    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,view.frame.size.width, yPos + height + 5);
    //cellHeight = 116 + view.frame.size.height;
}

//MARK:- TABLE VIEW DELEGATES
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.categoryTableView){
        return [catIdArray count];
    }else{
        return responseStores.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.categoryTableView) {

        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [catNameArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:14.0];
        cell.textLabel.textColor = [UIColor blackColor];
        return  cell;

    }else{

        StoreListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"StoreListTableViewCell"];
//
//        if(cell == nil){
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StoreListTableViewCell" owner:self options:nil];
//            cell = [nib objectAtIndex:0];
//        }

        store = [responseStores objectAtIndex:indexPath.row];

        NSString *lattString             = [store valueForKey:@"latitude"];
        NSString *longString             = [store valueForKey:@"longitude"];

        NSString *imageUrlString         = [store valueForKey:@"image"];
        NSString *storeImageUrl =[NSString stringWithFormat:@"%@%@",parentURL,imageUrlString];
        [cell.imgStore sd_setImageWithURL:[NSURL URLWithString:storeImageUrl]];

        cell.offerGradient.layer.masksToBounds= YES;



        //Setting 'Place' Label size dynamically
        cell.lblPlace.text = [store valueForKey:@"address"];
        cell.lblName.text = [store valueForKey:@"store_name"];

//        #define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)
//        cell.lblName.transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));

        cell.lblPlace.lineBreakMode = NSLineBreakByWordWrapping;
        cell.lblPlace.numberOfLines = 1;
        CGRect frame = cell.lblPlace.frame;
        //frame.size.width = 200;
        //cell.lblPlace.frame = frame;
        //[cell.lblPlace sizeToFit];
        
        if(cell.lblPlace.frame.size.height > 48)
        {
            cell.lblPlace.frame = CGRectMake(cell.lblPlace.frame.origin.x, cell.lblPlace.frame.origin.y, cell.lblPlace.frame.size.width, 48);
        }


        ///phone number & tap
         NSAttributedString *attributedString;
        if(![[store valueForKey:@"phone2"]isEqualToString:@""]){

              NSString *trimmedPhoneNumOne = [[store valueForKey:@"phone1"] stringByReplacingOccurrencesOfString:@" " withString:@""];

              NSString *trimmedPhoneNumTwo = [[store valueForKey:@"phone2"] stringByReplacingOccurrencesOfString:@" " withString:@""];

            attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@,%@",trimmedPhoneNumOne,trimmedPhoneNumTwo]                                                               attributes:@{ NSLinkAttributeName: [NSURL URLWithString:@""] }];
             cell.lblPhone.attributedText = attributedString;

            UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneTap:)];
            [cell.lblPhone addGestureRecognizer:phoneTap];

        }else if(![[store valueForKey:@"phone1"]isEqualToString:@""]){

            NSString *trimmedPhoneNum = [[store valueForKey:@"phone1"] stringByReplacingOccurrencesOfString:@" " withString:@""];

            attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",trimmedPhoneNum]                                                              attributes:@{ NSLinkAttributeName: [NSURL URLWithString:@""] }];
            cell.lblPhone.attributedText = attributedString;

            UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneTap:)];
            [cell.lblPhone addGestureRecognizer:phoneTap];
        }
        cell.lblPhone.userInteractionEnabled = true;
        cell.lblPhone.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
        cell.lblPhone.tag = indexPath.row;

        ///webiste URL & tap
        if([[store valueForKey:@"website_url"] isEqualToString:@""])
        {
            attributedString = [[NSAttributedString alloc] initWithString:@""
                                                               attributes:@{ NSLinkAttributeName: [NSURL URLWithString:@""] }];
             //UITapGestureRecognizer *websiteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(websiteTap:)];
             //[cell.lblWeb removeGestureRecognizer:websiteTap];
        }else{

            NSString *str = [[NSString alloc]init];
            str = [store valueForKey:@"website_url"];
            NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
            NSString *resultString = [[str componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];

            attributedString = [[NSAttributedString alloc] initWithString:@"Website"
                                                                                   attributes:@{ NSLinkAttributeName: [NSURL URLWithString:[NSString stringWithFormat:@"%@",resultString]] }];
            UITapGestureRecognizer *websiteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(websiteTap:)];
            [cell.lblWeb addGestureRecognizer:websiteTap];
        }

        cell.lblWeb.attributedText = attributedString;
        cell.lblWeb.dataDetectorTypes = UIDataDetectorTypeLink;
        cell.lblWeb.userInteractionEnabled = true;
        cell.lblWeb.tag = indexPath.row;

        // [cell.lblWeb setTitle:[store valueForKey:@"website_url"] forState:UIControlStateNormal];
        //[cell.lblName sizeToFit];
        //[cell.lblPlace sizeToFit];
        //[cell.lblPhone sizeToFit];
        //[cell.lblWeb.titleLabel sizeToFit];

        NSString *offerTextString = [store valueForKey:@"offer_text"];
        if (![offerTextString  isEqualToString: @""]){
            cell.offerGradient.hidden  = NO;
            cell.lblOffer.hidden  = NO;
            cell.lblOffer.text    = [NSString stringWithFormat:@"%@",offerTextString];
            //cell.lblOffer.textAlignment = NSTextAlignmentRight;

            float widthIs = cell.lblOffer.intrinsicContentSize.width+20;
//            if([offerTextString length]<=10){
//                widthIs         = cell.lblOffer.intrinsicContentSize.width+30;
//            }else{
//                widthIs         = cell.lblOffer.intrinsicContentSize.width+10;
//            }

            cell.lblOffer.frame = CGRectMake(cell.lblOffer.frame.origin.x, cell.lblOffer.frame.origin.y, widthIs, cell.lblOffer.frame.size.height);
            cell.offerGradient.frame    = CGRectMake(cell.offerGradient.frame.origin.x, cell.offerGradient.frame.origin.y, widthIs, cell.offerGradient.frame.size.height);
        }else{
            cell.offerGradient.hidden = YES;
            cell.lblOffer.hidden  = YES;

        }

//         float widthIs =
//        [cell.lblOffer.text
//         boundingRectWithSize:cell.lblOffer.frame.size
//         options:NSStringDrawingTruncatesLastVisibleLine
//         attributes:@{ NSFontAttributeName:cell.lblOffer.font }
//         context:nil]
//        .size.width+10;

        //cell.lblOffer.numberOfLines = 0;
        //[cell.lblOffer sizeToFit];

        NSLog(@"x is:%f",cell.lblOffer.frame.origin.x);
        //NSLog(@"width is:%f",widthIs);

        //To align offerLabel right
//        if(cell.lblOffer.frame.origin.x <= 262)
//        {
//            if(widthIs < 75 ){
//                float diff = 75 - widthIs;
//                cell.lblOffer.frame = CGRectMake(cell.lblOffer.frame.origin.x+diff, cell.lblOffer.frame.origin.y, widthIs, cell.lblOffer.frame.size.height);
//            }else{
//                cell.lblOffer.frame = CGRectMake(cell.lblOffer.frame.origin.x, cell.lblOffer.frame.origin.y, widthIs, cell.lblOffer.frame.size.height);
//            }
//        }else{
           // cell.lblOffer.frame = CGRectMake(cell.lblOffer.frame.origin.x, cell.lblOffer.frame.origin.y, widthIs, cell.lblOffer.frame.size.height);
       // }


        //compare date
        NSString *openTime = [store valueForKey:@"open_time"];
        NSString *closeTime = [store valueForKey:@"closing_time"];

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm:ss"];
        NSDate *openDate = [dateFormat dateFromString:openTime];
        NSLog(@"%@",openDate);
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components1 = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:openDate];
        NSInteger openHour = [components1 hour];
        //  NSInteger openMinute = [components1 minute];

        NSDate *closeDate = [dateFormat dateFromString:closeTime];
        NSLog(@"%@",closeDate);
        NSDateComponents *components2 = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:closeDate];
        NSInteger closeHour = [components2 hour];
        // NSInteger closeMinute = [components2 minute];


        NSDate *curruntDate  = [NSDate date];
        NSLog(@"%@",curruntDate);
        NSDateComponents *components3 = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:curruntDate];
        NSInteger currentHour = [components3 hour];
        //  NSInteger currentMinute = [components3 minute];


        //design
        cell.imgStore.clipsToBounds = true;

        [cell.mainContentView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
        [cell.mainContentView.layer setShadowOffset:CGSizeMake(3, 3)];
        [cell.mainContentView.layer setShadowRadius:5.0];
        [cell.mainContentView.layer setShadowOpacity:1];
        cell.mainContentView.backgroundColor = [UIColor whiteColor];
        cell.mainContentView.layer.cornerRadius = 10;

        cell.lblOffer.clipsToBounds = true;
        //[cell.lblOffer sizeToFit];

//        UIColor *gradOneStartColor = [UIColor colorWithRed:245/255.f green:133/255.f blue:169/255.f alpha:1.0];
//        UIColor *gradOneEndColor   = [UIColor colorWithRed:244/255.0 green:177/255.0 blue:153/255.0 alpha:1.0];

//        [self.view layoutIfNeeded];
//        UIView *gradView = [[UIView alloc] init];
//        gradView.frame = cell.lblOpen.frame;
//        [self.view layoutIfNeeded];
//        CAGradientLayer *grad = [CAGradientLayer layer];
//        grad.frame = gradView.bounds;
//        grad.startPoint = CGPointZero;
//        grad.endPoint = CGPointMake(1, 1);
//        grad.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];
//
//        gradView.layer.cornerRadius = 8;
//        gradView.clipsToBounds = true;
//        [cell.mainContentView addSubview:gradView];
//
//        [gradView.layer addSublayer:grad];
        cell.lblOpen.layer.cornerRadius = 8.0;
        cell.lblOpen.clipsToBounds = true;
        [cell.mainContentView bringSubviewToFront:cell.lblOpen];


        if (openHour < currentHour && closeHour > currentHour){
            cell.lblOpen.text   = @"Open";
           //gradView.hidden = false;
        }else{
            cell.lblOpen.text   = @"Closed";
            //gradView.hidden = true;
        }

        tagsString = [store valueForKey:@"tags"];
        tagsString = [tagsString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        tagsString = [tagsString stringByReplacingOccurrencesOfString:@"\n" withString:@","];
        tagsString = [tagsString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        cell.lblTag.text   = tagsString;
        

//        NSArray *viewsToRemove = [cell.tagsView subviews];
//        for (UIView *v in viewsToRemove) {
//            [v removeFromSuperview];
//        }
//       [self setTags:cell.tagsView array:tagsArray];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView){
        return 40;
    }else{
        return 160;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView){
        self.categoryTableContainerView.hidden = true;
        _storeCatId = [catIdArray objectAtIndex:indexPath.row];
        _BtnSearch.titleLabel.text = [NSString stringWithFormat:@"%@",[catNameArray objectAtIndex:indexPath.row]];
        [self getStoresList];
    }
}

//MARK:- TABBAR DELEGATE
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
        }
        else
        {
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

- (void)websiteTap:(UITapGestureRecognizer *)recognizer {
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

    UIView *view = recognizer.view;
    NSInteger indexHere = view.tag;
    NSDictionary *storesHere = [responseStores objectAtIndex:indexHere];

    NSString *url = [storesHere valueForKey:@"website_url"];
    NSString *trimmedUrl = [[NSString alloc]init];

    //Chceking 'http' presents in url string
    if (!contains(url, @"http")) {
        url = [NSString stringWithFormat:@"http://%@", url];
        trimmedUrl = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    }else{
        trimmedUrl = url;
    }

    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:trimmedUrl];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }else{

        }
    }];
}

-(void)phoneTap:(UITapGestureRecognizer *)recognizer{

    UIView *view = recognizer.view;
    NSInteger indexHere = view.tag;
    NSDictionary *storesHere = [responseStores objectAtIndex:indexHere];

     NSString *trimmedPhoneNum = [[storesHere valueForKey:@"phone1"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",trimmedPhoneNum]] options:@{} completionHandler:nil];
}

- (IBAction)searchTap:(id)sender {
    SearchViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"fourthv"];
    vc.searchType = @"stores";
    _showFilterBar = @"NO";
    [self.navigationController pushViewController:vc animated:false];
}


//MARK:- POPUP MENU DELEGAES
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





@end
