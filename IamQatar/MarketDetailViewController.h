//
//  MarketDetailViewController.h
//  IamQatar
//
//  Created by alisons on 9/5/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.pch"
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "KIImagePager.h"

@interface MarketDetailViewController : BaseForObjcViewController <UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UIPickerViewDelegate,UIActivityItemSource,KIImagePagerDelegate,KIImagePagerDataSource,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *bannerScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageIndicator;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet KIImagePager *bannerView;
@property (strong, nonatomic) NSString *selectedProductId;
@property (strong, nonatomic) NSString *isGift;

@property (strong, nonatomic) NSDictionary *selectedProductDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnQty;
@property (weak, nonatomic) IBOutlet UITextView *tvDesciption;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnSizeDropDown;
@property (weak, nonatomic) IBOutlet UIView *offersView;
@property (weak, nonatomic) IBOutlet UILabel *lblOffer;

@property (weak, nonatomic) IBOutlet UITableView *sizeDropDownTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblSizeDropDown;

@property (weak, nonatomic) IBOutlet UILabel *lblColorDropDown;
@property (weak, nonatomic) IBOutlet UITableView *colorDropDownTableView;

@property (weak, nonatomic) IBOutlet UIButton *btnColorDropDown;
@property (weak, nonatomic) IBOutlet UIButton *arrowColorDropDown;
@property (weak, nonatomic) IBOutlet UIButton *arrowSizeDropDown;
//@property (weak, nonatomic) IBOutlet UIView *colorPickerView;
//@property (weak, nonatomic) IBOutlet UIView *sizePickerView;
@property (weak, nonatomic) IBOutlet UIView *ImageContainer;
@property (weak, nonatomic) IBOutlet UIView *priceAndqtyView;
@property (weak, nonatomic) IBOutlet UIPickerView *colorPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *sizePickerView;
@property (weak, nonatomic) IBOutlet UILabel *lblProductDescTitle;
@property (weak, nonatomic) IBOutlet UIView *viewNoStockAvailable;
@property (weak, nonatomic) IBOutlet UIView *qtyPickerContView;



@end
