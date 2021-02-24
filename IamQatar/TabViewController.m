//
//  TabViewController.m
//  IamQatar
//
//  Created by alisons on 8/17/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController
@synthesize tabBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    
//    for (int i = 0; i < [[self.tabBarController.tabBar subviews] count]; i++) {
//
//        [[[self.tabBarController.tabBar subviews] objectAtIndex:i] setAccessibilityLabel:@"pala"];
//
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.delegate = self;
    self.tabBar.delegate           = self;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"tag>>%ld",(long)item.tag);
    
    if (item.tag == 1) {
        
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
        if (viewController == [self.tabBarController.viewControllers objectAtIndex:2])
        {
           
        }
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
