//
//  Menu.m
//  IamQatar
//
//  Created by alisons on 8/30/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "Menu.h"
#import "BaseForObjcViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation Menu
@synthesize delegate;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Shadow effect for menu
    self.menuView.layer.masksToBounds = NO;
    self.menuView.layer.shadowOffset  = CGSizeMake(6, -10);
    self.menuView.layer.shadowRadius  = 9;
    self.menuView.layer.shadowOpacity = 0.3;
}

- (IBAction)closeAction:(UIButton *)sender {
    [self close];
}

-(void)close{
    int deviceHieght = [[UIScreen mainScreen] bounds].size.height;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame=CGRectMake(-290, 0, 275, deviceHieght);
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        [self setHidden:YES];
    }];
}


//MARK:- TABLEVIEW DELEGATES
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"menu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSMutableArray *menuContentsArray = [[NSMutableArray alloc]initWithObjects:@"Profile",@"About Us",@"Order History",@"Contest",@"Contact Us",@"Terms of Use", nil];
    NSMutableArray *iconArray = [[NSMutableArray alloc]initWithObjects:@"profileSideMenu",@"aboutSideMenu",@"orderHistorySidemenu",@"contest_SideMenu",@"contactusSideMenu",@"termsOfUseSidemenu", nil];
    
    cell.textLabel.text  = [menuContentsArray objectAtIndex:indexPath.row];
    cell.textLabel.font  = [UIFont fontWithName:@"SFUIDisplay-Medium" size:15.0];
    cell.imageView.image = [UIImage imageNamed:[iconArray objectAtIndex:indexPath.row]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor= [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self close];
    
    if(indexPath.row==0){
        [delegate GoProfilePage:self];
    }
    else if(indexPath.row==1){
        [delegate GoAboutUsPage:self];
    }
    else if(indexPath.row==2){
         [delegate History:self];
    }
    else if(indexPath.row==3){
        [delegate contest:self];
    }
    else if(indexPath.row==4){
        [delegate ContactUs:self];
    }
    else if(indexPath.row==5){
        [delegate goTermsOfUse:self];
    }
}


- (IBAction)logout:(id)sender {
   [delegate LogOut:self];
}
- (IBAction)goAboutUsPage:(id)sender {
    
}






@end
