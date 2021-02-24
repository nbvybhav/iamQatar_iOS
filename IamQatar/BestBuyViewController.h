//
//  BestBuyViewController.h
//  IamQatar
//
//  Created by alisons on 9/1/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.pch"
#import "Menu.h"
#import "BaseForObjcViewController.h"

@interface BestBuyViewController : BaseForObjcViewController <UITabBarControllerDelegate,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,PopMenuDelegate>
@property (strong, nonatomic) IBOutlet UITableView *bestBuyTableView;
@end
