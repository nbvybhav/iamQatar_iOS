//
//  NewsFeedsViewController.h
//  IamQatar
//
//  Created by User on 26/06/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "KIImagePager.h"
#import "constants.pch"

@interface NewsFeedsViewController : BaseForObjcViewController <KIImagePagerDelegate,KIImagePagerDataSource,UIGestureRecognizerDelegate,KIImagePagerImageSource,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet KIImagePager *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *bannerTitle;
@property (weak, nonatomic) IBOutlet UILabel *bannerDesc;
@property (strong, nonatomic) NSString *bannerUrl;
@property (strong, nonatomic) NSString *newsFeedTitle;
@property (strong, nonatomic) NSString *reporter;
@property (strong, nonatomic) NSString *createdDate;
@property (strong, nonatomic) NSString *newsFeedDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblNewsFeedTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UITextView *tvDesc;
@property (weak, nonatomic) NSDictionary *selectedNews;



@end
