//
//  OrderHistoryTableViewCell.h
//  IamQatar
//
//  Created by anuroop on 18/07/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderID;
@property (weak, nonatomic) IBOutlet UILabel *lblDeliveryDate;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblDeliveryMsg;
@property (weak, nonatomic) IBOutlet UILabel *lblDeliverDateMsg;

@end
