//
//  MallCategoryCell.h
//  IamQatar
//
//  Created by User on 09/08/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MallCategoryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellBgImage;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *txtCategory;
@property (weak, nonatomic) IBOutlet UIView *shadowImg;

@end
