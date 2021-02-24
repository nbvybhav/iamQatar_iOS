//
//  ThirdViewController.h
//  IamQatar
//
//  Created by alisons on 8/18/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "constants.pch"
#import "KIImagePager.h"


@interface categoryViewController : BaseForObjcViewController <UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, KIImagePagerDelegate,KIImagePagerDataSource,KIImagePagerImageSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shadowViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLblOne;

@property (weak, nonatomic) IBOutlet UICollectionView *salesAndPromoCollectionView;
@property (strong, nonatomic) IBOutlet KIImagePager *ivAdvt;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchByOffer;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *bannerTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *bannerDescLbl;
@property (strong, nonatomic) NSString   *categoryType;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
