//
//  Menu.h
//  IamQatar
//
//  Created by alisons on 8/30/16.
//  Copyright © 2016 alisons. All rights reserved.
//


#import <UIKit/UIKit.h>

@class Menu;
@protocol PopMenuDelegate <NSObject>
- (void) todaysDeal:         (Menu *) sender;
- (void) whatsNew:           (Menu *) sender;
- (void) emergencyContact:   (Menu *) sender;
- (void) contest:            (Menu *) sender;
- (void) GoAboutUsPage:      (Menu *) sender;
- (void) GoProfilePage:      (Menu *) sender;
- (void) History:            (Menu *) sender;
- (void) ContactUs:          (Menu *) sender;
- (void) goTermsOfUse:       (Menu *) sender;
- (void) LogOut:             (Menu *) sender;


@end

@interface Menu : UIView <UITableViewDelegate,UITableViewDataSource>
{
    id<PopMenuDelegate> delegate;
}
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic,retain)id<PopMenuDelegate>delegate;
@property (strong, nonatomic) IBOutlet Menu *menuView;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

@end
