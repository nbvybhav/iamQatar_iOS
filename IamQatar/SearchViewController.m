//
//  FourthViewController.m
//  IamQatar
//
//  Created by alisons on 8/18/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "SearchViewController.h"
#import "constants.pch"
#import "UIImageView+WebCache.h"
#import "MarketDetailViewController.h"
#import "bestBuyDetailViewController.h"
#import "RetailDetailViewController.h"
#import "contestViewController.h"
#import "EventDetalPage.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "EventDetalPage.h"
#import "MallDetailsViewController.h"
#import "StoreListViewController.h"
#import "IamQatar-Swift.h"

@interface SearchViewController ()

@end


@implementation SearchViewController

{

    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;

    NSMutableArray *marketItems;
    NSMutableArray *descriptionArray;
    NSMutableArray *nameArray;
    NSMutableArray *descArray;
    NSMutableArray *idArray;
    NSMutableArray *tagsArray;
    NSMutableArray *apiArray;
    NSMutableArray *responseSearchResluts;
    NSMutableArray *searchedDescArray;
    NSMutableArray *searchedtypeArray;
    NSMutableArray *searchedapiArray;
    NSMutableArray *searchedBbIdArray;
    NSMutableArray *searchResultsArray;
    NSMutableArray *mallNameArray;
    NSMutableArray *flyersArray;
    BOOL marketItemsCalled;
}


//MARK:- VIEW DID LOAD

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    self.title = @"SEARCH";
    
    searchedDescArray = [[NSMutableArray alloc]init];
    searchedtypeArray = [[NSMutableArray alloc]init];
    searchedapiArray  = [[NSMutableArray alloc]init];
    searchedBbIdArray = [[NSMutableArray alloc]init];
    idArray           = [[NSMutableArray alloc]init];
    tagsArray         = [[NSMutableArray alloc]init];
    descArray         = [[NSMutableArray alloc]init];
    nameArray         = [[NSMutableArray alloc]init];
    descriptionArray  = [[NSMutableArray alloc]init];
    apiArray          = [[NSMutableArray alloc]init];

    self.tabBarController.delegate = self;
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


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

    //------Setup searchBar--------//
    searchResultsArray    = [[NSMutableArray alloc]init];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchTableView.delegate= self;
    self.tabBarController.delegate = self;
    self.searchController.searchBar.text        = @"";
    self.searchController.searchBar.delegate    = self;
    self.searchController.searchResultsUpdater  = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.obscuresBackgroundDuringPresentation      = NO;
    self.definesPresentationContext             = YES;
    self.searchTableView.tableHeaderView        = self.searchController.searchBar;
    //self.navigationItem.hidesBackButton         = false;
    self.searchController.searchBar.showsCancelButton           = NO;
    self.searchController.hidesNavigationBarDuringPresentation  = false;

    //Setting searchBar placeholder
    if([self.searchType isEqualToString:@"product"]){
        self.searchController.searchBar.placeholder = @"Search for IAQ Market items..";

    }else if ([self.searchType isEqualToString:@"events"]){
        self.searchController.searchBar.placeholder = @"Search for Events..";

    }else if ([self.searchType isEqualToString:@"retails"]){
        self.searchController.searchBar.placeholder = @"Search for Retail items..";

    }else if ([self.searchType isEqualToString:@"malls"]){
        self.searchController.searchBar.placeholder = @"Search for Malls..";

    }else if ([self.searchType isEqualToString:@"stores"]){
        self.searchController.searchBar.placeholder = @"Search for Stores..";

    }else if ([self.searchType isEqualToString:@"promotions"]){
        self.searchController.searchBar.placeholder = @"Search for Sales & Promo..";

    }else if([self.searchType isEqualToString:@"todaysdeals"]){
        self.searchController.searchBar.placeholder = @"Search for Todays deal..";
    }

    [self.searchTableView setTableHeaderView:self.searchController.searchBar];
    self.definesPresentationContext = YES;
    [_searchController setActive:YES];
    [_searchController.searchBar becomeFirstResponder];
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
    [tracker set:kGAIScreenName value:@"Search page"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    //-----hiding back btn-------//
    //[[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:YES];
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    [searchController.searchBar becomeFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(-290, 0, 275, deviceHieght);
}

//MARK:- API CALL
-(void)searchFor : (NSString*)string
{
    if ([Utility reachable]) {
        [ProgressHUD show];
       // NSString *argumentsString = [NSString stringWithFormat:@"&term=%@&search_type=%@",string,_searchType];

        NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:string,@"term",_searchType,@"search_type", nil];

        NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,search];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSLog(@"%@",responseObject);
             NSString *text = [responseObject objectForKey:@"text"];
             if ([text isEqualToString: @"Success!"])
             {
                 self->responseSearchResluts = [[responseObject objectForKey:@"value"]mutableCopy];
                 self->searchResultsArray = [[self->responseSearchResluts valueForKey:@"title"]mutableCopy];
                 self->flyersArray        = [[self->responseSearchResluts valueForKey:@"image"]mutableCopy];
                 self->idArray            = [[self->responseSearchResluts valueForKey:@"id"]mutableCopy];
                 self->mallNameArray      = [[self->responseSearchResluts valueForKey:@"malls"]mutableCopy];
             }
             [self.searchTableView reloadData];
             [ProgressHUD dismiss];

         } failure:^(NSURLSessionTask *task, NSError *error) {

             NSLog(@"Error: %@", error);
             [ProgressHUD dismiss];
         }];

    }else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
        [ProgressHUD dismiss];
    }
}



//MARK:- SEARCH
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

        NSString *searchString = self.searchController.searchBar.text;
        // NSPredicate *resultPredicate;

        [searchedDescArray  removeAllObjects];
        [searchedtypeArray  removeAllObjects];
        [searchedapiArray   removeAllObjects];
        [searchedBbIdArray  removeAllObjects];
        [searchResultsArray removeAllObjects];
        [mallNameArray removeAllObjects];

        //searchString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        if (searchText != nil){
            if(searchText.length > 2){
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchFor:) object:searchString];
                [self performSelector:@selector(searchFor:) withObject:searchString afterDelay:0.5];
            }
            // [self searchFor:searchString];
        }else{

            [self.navigationController popViewControllerAnimated:false];
        }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:false];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
    [self.searchTableView endEditing:YES];


    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(0, 625, 275, 335);
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{

}

//MARK:- TABLE VIEW DELEGATES
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [searchResultsArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    NSLog(@"%@",searchResultsArray);


     if ([self.searchType isEqualToString:@"stores"]){
         if(![[mallNameArray objectAtIndex:indexPath.row]isEqualToString:@""])
         {
             cell.textLabel.text        = [NSString stringWithFormat:@"%@ - %@",[searchResultsArray objectAtIndex: indexPath.row],[mallNameArray objectAtIndex:indexPath.row]];
         }else{
             cell.textLabel.text        = [NSString stringWithFormat:@"%@",[searchResultsArray objectAtIndex: indexPath.row]];
         }
     }else{
             cell.textLabel.text        = [searchResultsArray objectAtIndex: indexPath.row];
     }

    //cell.detailTextLabel.text  = [searchedtypeArray objectAtIndex:indexPath.row];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.searchType isEqualToString:@"product"]){
        
        MarketDetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"marketDetailView"];
        view.selectedProductId = [[responseSearchResluts objectAtIndex:indexPath.row] valueForKey:@"product_id"];
        [self.navigationController pushViewController:view animated:YES];

    }else if ([self.searchType isEqualToString:@"events"]){
        
        EventDetalPage *view = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetails"];
        NSLog(@"%@",responseSearchResluts);
        view.fromNotificationTap = NO;
        view.selectedEventId = [[responseSearchResluts objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:view animated:YES];

    }else if ([self.searchType isEqualToString:@"retails"]){
        
        MarketViewController *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"marketView"];
        NSString *selectedRetailId= [idArray objectAtIndex:indexPath.row];
        vc.selectedRetailId = [[NSString alloc]initWithFormat:@"%@",selectedRetailId];
        vc.type = @"storeOffer";
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([self.searchType isEqualToString:@"malls"]){
        
        MallDetailsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"MallDetailsViewController"];
        view.mallId = [[responseSearchResluts objectAtIndex:indexPath.row] valueForKey:@"id"];
        [self.navigationController pushViewController:view animated:YES];

    }else if ([self.searchType isEqualToString:@"stores"]){
        
        StoreListViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreListViewController"];
        view.idHere = [[responseSearchResluts objectAtIndex:indexPath.row] valueForKey:@"id"];
        [self.navigationController pushViewController:view animated:YES];

    }else if ([self.searchType isEqualToString:@"promotions"]){
        
        RetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
        vc.pushedFrom = @"categoryItem";
        vc.type  = @"";
        NSLog(@"%@",[responseSearchResluts objectAtIndex:indexPath.row]);
        vc.selectedSearchItem = [idArray objectAtIndex:indexPath.row];//[responseSearchResluts objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];

    }else if([self.searchType isEqualToString:@"todaysdeals"]){
        
        RetailViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
        vc.pushedFrom = @"todaysDeal";
        vc.type  = @"";
        NSLog(@"%@",[responseSearchResluts objectAtIndex:indexPath.row]);
        vc.selectedSearchItem = [idArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if([self.searchType isEqualToString:@"gift"]){
        
        MarketDetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"marketDetailView"];
        view.selectedProductId = [[responseSearchResluts objectAtIndex:indexPath.row] valueForKey:@"product_id"];
        view.isGift = @"true";
        [self.navigationController pushViewController:view animated:YES];
        
        
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
