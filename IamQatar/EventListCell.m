//
//  ListCellTableViewCell.m
//  IamQatar
//
//  Created by alisons on 9/3/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "EventListCell.h"

@implementation EventListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
    [_mainContentView.layer setCornerRadius:10];
    
    [_mainContentView.layer setShadowOffset:CGSizeZero];
    [_mainContentView.layer setShadowOpacity:0.5];
    [_mainContentView.layer setShadowColor:[[UIColor grayColor]CGColor]];
    [_mainContentView.layer setShadowOffset:CGSizeZero];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
