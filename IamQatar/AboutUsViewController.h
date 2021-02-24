//
//  AboutUsViewController.h
//  IamQatar
//
//  Created by alisons on 9/4/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "constants.pch"

@interface AboutUsViewController : BaseForObjcViewController <UITabBarDelegate,UITabBarControllerDelegate,PopMenuDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *tvAboutUs;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIView *bannerView;


@end
