//
//  FourthViewController.h
//  IamQatar
//
//  Created by alisons on 8/18/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
@interface SearchViewController : BaseForObjcViewController <UITabBarDelegate,UITabBarControllerDelegate,UISearchDisplayDelegate,UISearchResultsUpdating,UISearchBarDelegate,PopMenuDelegate,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) UISearchController *searchController;
@property  NSString  *searchType;
@end
