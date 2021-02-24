//
//  EventsList.h
//  IamQatar
//
//  Created by alisons on 9/3/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "constants.pch"

@interface EventsList : BaseForObjcViewController <UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) NSString *eventCatId;
@property (strong, nonatomic) NSString *eventDate;
@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSString *IsCalendar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UITableView *eventListTableView;
@property (strong, nonatomic) IBOutlet UILabel *lblNoEvents;

@end
