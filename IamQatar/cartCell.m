//
//  cartCell.m
//  IamQatar
//
//  Created by alisons on 8/29/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "cartCell.h"

@implementation cartCell

- (void)awakeFromNib {
    // Initialization code
    _cartQty.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    _qtyPickerContView.layer.borderWidth = 1;
    _qtyPickerContView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
}

@end
