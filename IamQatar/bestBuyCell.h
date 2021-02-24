//
//  bestBuyCellTableViewCell.h
//  IamQatar
//
//  Created by alisons on 9/1/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bestBuyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *stockLeft;
@property (strong, nonatomic) IBOutlet UILabel *timeLeft;
@property (strong, nonatomic) IBOutlet UILabel *oldPrice;
@property (strong, nonatomic) IBOutlet UILabel *offerPrice;
@property (strong, nonatomic) IBOutlet UILabel *discountPercent;
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UILabel *lblTimer;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;

@end
