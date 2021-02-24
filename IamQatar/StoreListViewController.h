//
//  StoreListViewController.h
//  IamQatar
//
//  Created by User on 27/06/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "KIImagePager.h"
#import "constants.pch"

@interface StoreListViewController : BaseForObjcViewController <UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSString *mallId;
@property (weak, nonatomic) IBOutlet UITableView *storeListTableView;
@property (strong, nonatomic) NSString *storeCatId;
@property (strong, nonatomic) NSString *idHere;
@property (strong, nonatomic) NSString *showFilterBar;
@property (strong, nonatomic) NSString *offerStores;

@property (strong, nonatomic) NSArray  *categoryArray;
@property (weak, nonatomic) IBOutlet UIButton *BtnSearch;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UIView *categoryTableContainerView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imageDownArrow;
@property (weak, nonatomic) IBOutlet UIButton *btnMainSearch;
@property (weak, nonatomic) IBOutlet UISearchBar *searhBar;
@end
