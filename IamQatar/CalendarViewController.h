//
//  CalendarViewController.h
//  IamQatar
//
//  Created by User on 30/05/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarView.h"
#import "constants.pch"

@interface CalendarViewController : UIViewController <UITabBarDelegate,UITabBarControllerDelegate,CalendarViewDelegate,PopMenuDelegate>
@property (strong, nonatomic) IBOutlet CalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoEvents;
@property (weak, nonatomic) IBOutlet UITableView *eventsListTableView;
@property (weak, nonatomic) IBOutlet UIImageView *gradientImageView;

@end
