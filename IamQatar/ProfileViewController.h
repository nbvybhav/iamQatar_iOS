//
//  ProfileViewController.h
//  IamQatar
//
//  Created by alisons on 9/7/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "constants.pch"

extern NSString *jumpToHome;
@interface ProfileViewController : BaseForObjcViewController <UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainContentViewHeghtConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UIView *mainCotentView;
@property (strong, nonatomic) IBOutlet UIButton *profileImgPicker;
@property (strong, nonatomic) IBOutlet UIImageView *profileUserImgView;

@property (strong, nonatomic) IBOutlet UILabel *profileUserName;
@property (strong, nonatomic) IBOutlet UILabel *profileUserMailID;
@property (strong, nonatomic) IBOutlet UITextField *profileNameTF;
@property (strong, nonatomic) IBOutlet UITextField *profileEmailTF;
@property (strong, nonatomic) IBOutlet UITextField *profilePhoneTF;
@property (strong, nonatomic) IBOutlet UITextView *profileAddressTF;

@property (strong, nonatomic) IBOutlet UIButton *saveBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *editBtnOutlet;

- (IBAction)onSaveBtnClicked:(id)sender;
- (IBAction)onEditBtnClicked:(id)sender;

- (IBAction)onProfileImageBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;

@end
