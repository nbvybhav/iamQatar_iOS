//
//  bestBuyDetailViewController.h
//  IamQatar
//
//  Created by alisons on 1/5/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
@interface bestBuyDetailViewController : BaseForObjcViewController <UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate>

@property (strong, nonatomic) NSString *bbProductId;
@property (strong, nonatomic) IBOutlet UILabel *bestBuyTitle;
@property (strong, nonatomic) IBOutlet UITextView *bestBuyDescription;
@property (strong, nonatomic) IBOutlet UILabel *bestBuyStockAvailablity;
@property (strong, nonatomic) IBOutlet UITableView *bestBuyTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *bestBuyBanner;
@property (strong, nonatomic) IBOutlet UILabel *lblStockAvailability;
@property (strong, nonatomic) IBOutlet UILabel *lblOldPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblNewPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeleft;
@property (strong, nonatomic) NSString *isFromSearch;
@property (strong, nonatomic) IBOutlet UIView *dealView;

@property (strong, nonatomic) IBOutlet UILabel *lblNoDesc;

@end
