//
//  MarketViewController.h
//  IamQatar
//
//  Created by alisons on 9/4/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.pch"
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "KIImagePager.h"

@interface MarketViewController : BaseForObjcViewController <UITabBarDelegate,UITabBarControllerDelegate,PopMenuDelegate>
@property (strong, nonatomic) IBOutlet KIImagePager *ivBanner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerVIewHeightConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *productListCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *storeOfferId;
@property (strong, nonatomic) NSString *selectedRetailId;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblbannerTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblBannerDesc;

@property (weak, nonatomic) IBOutlet UILabel *lblLineDraw;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;


@property (strong, nonatomic) NSString *storeID;

@end
