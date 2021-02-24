//
//  AddressCell.m
//  IamQatar
//
//  Created by alisons on 4/12/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [ _shadowView.layer setCornerRadius:8];
    [ _shadowView.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [ _shadowView.layer setShadowOpacity:0.5];
    [ _shadowView.layer setShadowColor:[[UIColor grayColor]CGColor]];
    //[ _shadowView.layer setShadowOffset:CGSizeMake(3, 3)];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
