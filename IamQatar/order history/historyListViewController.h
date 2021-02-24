//
//  historyListViewController.h
//  IamQatar
//
//  Created by alisons on 5/8/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.pch"

@interface historyListViewController : UIViewController <PopMenuDelegate,UITabBarControllerDelegate,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic) IBOutlet UILabel *lblNoOrders;

@end
