//
//  contestViewController.h
//  IamQatar
//
//  Created by alisons on 12/11/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "KIImagePager.h"
@interface contestViewController : BaseForObjcViewController <UITabBarControllerDelegate,PopMenuDelegate,KIImagePagerDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIScrollView *contestScroll;
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet KIImagePager *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnRules;

@end
