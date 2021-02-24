//
//  OrderHistoryTableViewCell.m
//  IamQatar
//
//  Created by anuroop on 18/07/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import "OrderHistoryTableViewCell.h"

@implementation OrderHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [ _mainContentView.layer setCornerRadius:8];
    [ _mainContentView.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [ _mainContentView.layer setShadowOpacity:0.5];
    [ _mainContentView.layer setShadowColor:[[UIColor grayColor]CGColor]];

    //Gradient for  button
    UIColor *gradOneStartColor = [UIColor colorWithRed:244/255.f green:108/255.f blue:122/255.f alpha:1.0];
    UIColor *gradOneEndColor   = [UIColor colorWithRed:251/255.0 green:145/255.0 blue:86/255.0 alpha:1.0];

    _btnCancel.layer.masksToBounds = YES;
    _btnCancel.layer.cornerRadius  = 12.0;

    CAGradientLayer *gradientlayerOne = [CAGradientLayer layer];
    gradientlayerOne.frame = _btnCancel.bounds;
    gradientlayerOne.startPoint = CGPointZero;
    gradientlayerOne.endPoint = CGPointMake(1, 1);
    gradientlayerOne.colors = [NSArray arrayWithObjects:(id)gradOneStartColor.CGColor,(id)gradOneEndColor.CGColor, nil];

    [_btnCancel.layer insertSublayer:gradientlayerOne atIndex:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
