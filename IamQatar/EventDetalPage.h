//
//  EventDetalPage.h
//  IamQatar
//
//  Created by alisons on 9/3/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "constants.pch"

@interface EventDetalPage : BaseForObjcViewController <UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *txtSynopsis;
@property (strong, nonatomic) NSArray *selectedEventId;
@property  BOOL fromNotificationTap;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *ivEvent;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UITextView *tvDesc;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UILabel *lblFare;

@property (weak, nonatomic) IBOutlet UITextView *lblUrl;

@property (weak, nonatomic) IBOutlet UILabel *lblTitleTwo;
@property (weak, nonatomic) IBOutlet UITextView *tvSynopsis;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UIView *tagsView;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;
@property (weak, nonatomic) IBOutlet UIImageView *imgTicket;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end
