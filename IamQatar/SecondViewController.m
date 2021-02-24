//
//  SecondViewController.m
//  IamQatar
//
//  Created by alisons on 8/17/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "SecondViewController.h"


@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"back_button"]
                                     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    exit(0);
   //[self.tabBarItem addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:true];
//    //-----hiding tabar item-------//
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:FALSE] ;
//    self.tabBarController.delegate = self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    NSLog(@"tabBarController Log>> %@",tabBarController.tabBarItem);
    if (viewController == [self.tabBarController.viewControllers objectAtIndex:3])
    {
        //[self.navigationController popViewControllerAnimated:YES];
        //return NO;
    }


    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (viewController == [self.tabBarController.viewControllers objectAtIndex:2])
    {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
