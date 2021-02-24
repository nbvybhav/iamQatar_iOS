//
//  ContactUsViewController.h
//  IamQatar
//
//  Created by User on 12/07/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.pch"

@interface ContactUsViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate,PopMenuDelegate,UITabBarControllerDelegate,UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *TxtPhone;
@property (weak, nonatomic) IBOutlet UITextView *tvMessage;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeightConstraint;

@end
