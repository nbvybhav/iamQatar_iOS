//
//  RetailDetailViewController.h
//  IamQatar
//
//  Created by alisons on 9/5/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.pch"
#import "Menu.h"
#import "BaseForObjcViewController.h"

@interface RetailDetailViewController : BaseForObjcViewController <UITabBarControllerDelegate,UITabBarDelegate,PopMenuDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *swipingImageView;
- (IBAction)swipeHandler:(UIGestureRecognizer*)sender;
@property (strong, nonatomic) NSMutableArray *flipsArray;
@property (strong, nonatomic) IBOutlet UIButton *rightArrow;
@property (strong, nonatomic) IBOutlet UIButton *leftArrow;
@property  (strong, nonatomic) NSString *position;





@end
