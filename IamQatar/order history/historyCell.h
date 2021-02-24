//
//  historyCell.h
//  IamQatar
//
//  Created by alisons on 5/9/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface historyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblOrderNum;
@property (strong, nonatomic) IBOutlet UILabel *lblProductName;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblDelivery;
@property (strong, nonatomic) IBOutlet UIImageView *productImg;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentType;

@end
