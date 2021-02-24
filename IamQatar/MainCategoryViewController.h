//
//  MainCategoryViewController.h
//  IamQatar
//
//  Created by alisons on 11/18/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "BaseForObjcViewController.h"

@interface MainCategoryViewController : BaseForObjcViewController <UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate,KIImagePagerDelegate, KIImagePagerDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *catCollectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeightConstraint;
@property (strong, nonatomic) IBOutlet KIImagePager *ivAdvt;
@property (strong, nonatomic) NSString *badgeHere;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCatCollectionview;
@property (weak, nonatomic) IBOutlet UILabel *bannerDescLbl;
@property (weak, nonatomic) IBOutlet UILabel *bannerTitleLbl;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblFeaturedProducts;
@property (weak, nonatomic) IBOutlet UICollectionView *featuredProductsCollectionView;
//@property (weak, nonatomic) IBOutlet UILabel *lblNeewArrival;
//@property (weak, nonatomic) IBOutlet UICollectionView *neewArrivalCollectionView;




@end
