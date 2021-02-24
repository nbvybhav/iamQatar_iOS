//
//  contactViewController.h
//  IamQatar
//
//  Created by alisons on 12/11/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
@interface emergencyContactViewController : BaseForObjcViewController <UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,PopMenuDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *contactTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end
