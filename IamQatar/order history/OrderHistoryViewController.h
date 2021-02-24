//
//  OrderHistoryViewController.h
//  IamQatar
//
//  Created by anuroop on 18/07/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.pch"

@interface OrderHistoryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,PopMenuDelegate,UITabBarDelegate,UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *orderHistoryTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOrders;

@end
