//
//  EventsHome.h
//  IamQatar
//
//  Created by alisons on 9/1/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "constants.pch"
#import "KIImagePager.h"


@interface EventsHome : BaseForObjcViewController<UITabBarDelegate,UITabBarControllerDelegate,PopMenuDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UICollectionViewDelegateFlowLayout,KIImagePagerDelegate,KIImagePagerDataSource>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *catCollectionViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shadowViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *viewDatePicker;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *DoneBtn;
@property (strong, nonatomic) IBOutlet UIDatePicker *datepicker;
@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet KIImagePager *bannerView;
@property (weak, nonatomic) IBOutlet UIButton *calendarBtn;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *bannerTitle;
@property (weak, nonatomic) IBOutlet UILabel *bannerDesc;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchBycategory;



@end
