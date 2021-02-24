//
//  GiftCategoryViewController.h
//  IamQatar
//
//  Created by User on 10/09/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"
#import "constants.pch"

@interface GiftCategoryViewController : UIViewController <KIImagePagerDelegate,KIImagePagerDataSource,KIImagePagerImageSource,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITableView *giftListTableView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet KIImagePager *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *bannerTitle;
@property (weak, nonatomic) IBOutlet UILabel *bannerDesc;

@end
