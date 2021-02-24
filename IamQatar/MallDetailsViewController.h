//
//  MallDetailsViewController.h
//  IamQatar
//
//  Created by User on 22/06/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "KIImagePager.h"
#import "constants.pch"

@interface MallDetailsViewController : BaseForObjcViewController <KIImagePagerDelegate,KIImagePagerDataSource,UIGestureRecognizerDelegate,KIImagePagerImageSource,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate>
@property (weak, nonatomic) IBOutlet UIButton *BtnSearch;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet KIImagePager *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *bannerTitle;
@property (weak, nonatomic) IBOutlet UILabel *bannerDesc;
//@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchForStore;
//@property (weak, nonatomic) IBOutlet UIButton *btnSearchForCat;
@property (strong, nonatomic) NSString *mallId;

//@property (weak, nonatomic) IBOutlet UIView *categoryTableContainerView;
@property (weak, nonatomic) IBOutlet KIImagePager *newsFeedView;
@property (weak, nonatomic) IBOutlet UILabel *newsFeedTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsFeedDesc;
@property (weak, nonatomic) IBOutlet UIView *newsFeedShadowView;
@property (weak, nonatomic) IBOutlet UIButton *BtnSearchForStore;
@property (weak, nonatomic) IBOutlet UICollectionView *mallCategoryCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblGalleryTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *imagePreviewCollectionView;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UITextView *txtViewInPopUpView;
@property (weak, nonatomic) IBOutlet UILabel *lblPopUpTitle;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
