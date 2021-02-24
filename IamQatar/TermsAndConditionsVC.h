//
//  TermsAndConditionsVC.h
//  IamQatar
//
//  Created by User on 12/07/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.pch"

@interface TermsAndConditionsVC : UIViewController <PopMenuDelegate,UITabBarControllerDelegate,UITabBarDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *cellContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;
@property (weak, nonatomic) IBOutlet UIView *bannerView;

@end
