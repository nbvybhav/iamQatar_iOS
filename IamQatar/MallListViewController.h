//
//  MallListViewController.h
//  IamQatar
//
//  Created by User on 21/06/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"
#import "constants.pch"


@interface MallListViewController : UIViewController <KIImagePagerDelegate,KIImagePagerDataSource,KIImagePagerImageSource,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainContentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITableView *mallListTableView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet KIImagePager *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *bannerTitle;
@property (weak, nonatomic) IBOutlet UILabel *bannerDesc;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
