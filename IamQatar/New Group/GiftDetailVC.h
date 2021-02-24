//
//  GiftDetailVC.h
//  IamQatar
//
//  Created by User on 17/09/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "KIImagePager.h"

@interface GiftDetailVC : BaseForObjcViewController <UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UIPickerViewDelegate,KIImagePagerDelegate,KIImagePagerDataSource,UIGestureRecognizerDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *bannerScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageIndicator;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet KIImagePager *bannerView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnQty;
@property (weak, nonatomic) IBOutlet UITextView *tvDesciption;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;


@property (weak, nonatomic) IBOutlet UIView *ImageContainer;
@property (weak, nonatomic) IBOutlet UIView *priceAndqtyView;
@property (weak, nonatomic) IBOutlet UIPickerView *qtyPickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *timePickerView;
@property (weak, nonatomic) IBOutlet UITextField *qtyTxt;
@property (weak, nonatomic) IBOutlet UITextField *deliverDateTxt;
@property (weak, nonatomic) IBOutlet UITextField *deliverTimeTxt;

@property NSDictionary *selectedDic;
@end
