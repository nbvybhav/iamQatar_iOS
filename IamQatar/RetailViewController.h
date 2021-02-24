//
//  RetailViewController.h
//  IamQatar
//
//  Created by alisons on 9/4/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.pch"
#import "Menu.h"
#import "BaseForObjcViewController.h"

@interface RetailViewController : BaseForObjcViewController <UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate,UITableViewDataSource,PopMenuDelegate,UITabBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *retailTableView;
@property (strong, nonatomic) NSString *pushedFrom;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *catId;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecords;
@property (strong, nonatomic) NSString *selectedSearchItem;
typedef void(^myCompletion)(BOOL);
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end
