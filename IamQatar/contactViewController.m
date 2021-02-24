//
//  contactViewController.m
//  IamQatar
//
//  Created by alisons on 12/11/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "emergencyContactViewController.h"
#import "ContactCell.h"
#import "constants.pch"

@interface emergencyContactViewController ()

@end

@implementation emergencyContactViewController
{
    Menu *menu;
    BOOL isSelected;
    NSMutableArray *contactArray;
    NSMutableArray *NameArray;
    NSMutableArray *linkArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //--------setting menu frame---------//
    isSelected = NO;
    menu= [[Menu alloc]init];
    NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"Menu" owner:self options:nil];
    menu = [nib1 objectAtIndex:0];
    menu.frame=CGRectMake(0, 625, 275, 335);
    menu.delegate = self;
    [self.view addSubview:menu];
    [menu setHidden:YES];

}


-(void) viewWillAppear:(BOOL)animated
{
    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Contact"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    //-----showing tabar item at index 4 (back button)-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:NO] ;
    self.tabBarController.delegate = self;
    [self getContacts];
}
-(void) viewDidAppear:(BOOL)animated
{
   // _contactTableView.frame = CGRectMake(_contactTableView.frame.origin.x, _contactTableView.frame.origin.y, _contactTableView.frame.size.width, _contactTableView.contentSize.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getContacts{
    
    if ([Utility reachable]) {
        
       [ProgressHUD show];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[NSString stringWithFormat:@"%@%@",parentURL,getContactAPI] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSString *text = [responseObject objectForKey:@"text"];
             if ([text isEqualToString: @"Success!"])
             {
                 contactArray = [[responseObject valueForKey:@"value"]valueForKey:@"key_value"];
                 NameArray    = [[responseObject valueForKey:@"value"]valueForKey:@"key_name"];
                 linkArray    = [[responseObject valueForKey:@"value"]valueForKey:@"website"];
                 
                 [_contactTableView reloadData];
                 _contactTableView.frame = CGRectMake(self.contactTableView.frame.origin.x, self.contactTableView.frame.origin.y, self.view.frame.size.width, 73*[contactArray count]);
                 //------Fit scrollview based on the content-------//
                 _mainScrollView.contentSize = CGSizeMake(320, _contactTableView.frame.origin.y+_contactTableView.frame.size.height);

             }
             NSLog(@"JSON: %@", responseObject);
             [ProgressHUD dismiss];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [ProgressHUD dismiss];
         }];
    }else
    {
        [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contactArray count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 45.0f;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
       // cell.lblContactNum.titleLabel.text = [contactArray objectAtIndex:indexPath.row];
        
        [cell.lblContactNum setTitle:[contactArray objectAtIndex:indexPath.row]forState:UIControlStateNormal];
        cell.lblName.text                  = [NameArray objectAtIndex:indexPath.row];
        [cell.lblUrl setTitle:[linkArray objectAtIndex:indexPath.row]forState:UIControlStateNormal];
        
        cell.lblContactNum.userInteractionEnabled = YES;
        cell.lblContactNum.tag = indexPath.row;
        UITapGestureRecognizer *contacTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactTap:)];
        [contacTapGestureRecognizer setNumberOfTapsRequired:1];
        [ cell.lblContactNum  addGestureRecognizer:contacTapGestureRecognizer];
        
        cell.lblUrl.userInteractionEnabled = YES;
        cell.lblUrl.tag = indexPath.row;
        UITapGestureRecognizer *urlTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(urlTap:)];
        [urlTapGestureRecognizer setNumberOfTapsRequired:1];
        [ cell.lblUrl  addGestureRecognizer:urlTapGestureRecognizer];
    }
    
//    if(indexPath.row%2 ==1)
//    {
//        cell.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1];
//        cell.lblContactNum.titleLabel.text = [contactArray objectAtIndex:indexPath.row];
//        cell.lblName.text                  = [NameArray objectAtIndex:indexPath.row];
//    }else{
//        cell.backgroundColor = [UIColor whiteColor];
//        cell.lblContactNum.titleLabel.text = [contactArray objectAtIndex:indexPath.row];
//        cell.lblName.text                  = [NameArray objectAtIndex:indexPath.row];
//    }
    
    return cell;
}

-(void)contactTap: (UITapGestureRecognizer *)sender{
    UIView *view =  sender.view;
    NSLog(@"tag>%ld",(long)view.tag);
    NSString *num = [contactArray objectAtIndex:view.tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",num]]];
}

-(void)urlTap: (UITapGestureRecognizer *)sender{
    UIView *view =  sender.view;
    NSLog(@"tag>%ld",(long)view.tag);
    NSString *link = [linkArray objectAtIndex:view.tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",link]]];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
    {
        if (isSelected) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                isSelected = NO;
                menu.frame=CGRectMake(0, 625, 275, 335);
            } completion:^(BOOL finished){
                // if you want to do something once the animation finishes, put it here
                [menu setHidden:YES];
            }];
        }else{
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [menu setHidden:NO];
                isSelected = YES;
                
                if ([[UIScreen mainScreen] bounds].size.height == 736.0){
                    menu.frame=CGRectMake(0, 352, 275, 335);
                }
                else if([[UIScreen mainScreen] bounds].size.height == 667.0){
                    menu.frame=CGRectMake(0, 283, 275, 335);
                }
                else{
                    menu.frame=CGRectMake(0, 185, 275, 335);
                }
                
            } completion:^(BOOL finished){
                // if you want to do something once the animation finishes, put it here
            }];
        }
        return NO;
    }
    else if (viewController == [self.tabBarController.viewControllers objectAtIndex:3])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
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
    contestViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"contestView"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)GoProfilePage:(Menu *)sender{
    ProfileViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)GoAboutUsPage:(Menu *)sender{
    AboutUsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutUsView"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)History:(Menu *)sender{
    historyListViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"history"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)LogOut:(Menu *)sender{
    LoginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
    
    //G+ signout
    GIDSignIn *signin = [GIDSignIn sharedInstance];
    [signin signOut];
    
    //Logout plist clear
    [Utility addtoplist:@"" key:@"login" plist:@"iq"];
    
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
