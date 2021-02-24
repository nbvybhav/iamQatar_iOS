//
//  RetailCell.h
//  IamQatar
//
//  Created by alisons on 9/5/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ivBgImage;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *continerView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblExpiryDate;
@property (weak, nonatomic) IBOutlet UILabel *expiryDateBg;
@property (weak, nonatomic) IBOutlet UILabel *lblOffer;


@end
