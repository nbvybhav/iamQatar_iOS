//
//  itemCell.h
//  IamQatar
//
//  Created by alisons on 4/12/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface itemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *BackgroundView;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UIImageView *DeleverySupplyierImage;
@property (weak, nonatomic) IBOutlet UILabel *NameOfCourier;
@property (weak, nonatomic) IBOutlet UILabel *DeleveryOption;
@property (weak, nonatomic) IBOutlet UILabel *DeleveryDescription;
@property (weak, nonatomic) IBOutlet UILabel *OrderDetails;
@property (strong, nonatomic) IBOutlet UIButton *radioBtn;

@end
