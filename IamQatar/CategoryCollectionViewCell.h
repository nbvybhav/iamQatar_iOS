//
//  CategoryCollectionViewCell.h
//  IamQatar
//
//  Created by User on 15/05/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCollectionViewCell : UICollectionViewCell
    @property (weak, nonatomic) IBOutlet UIImageView *iconImage;
    @property (weak, nonatomic) IBOutlet UIImageView *gradientImage;
    @property (weak, nonatomic) IBOutlet UILabel *textLbl;
    
@end
