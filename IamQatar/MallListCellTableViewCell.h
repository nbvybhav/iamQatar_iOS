//
//  MallListCellTableViewCell.h
//  IamQatar
//
//  Created by User on 22/06/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MallListCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

@end
