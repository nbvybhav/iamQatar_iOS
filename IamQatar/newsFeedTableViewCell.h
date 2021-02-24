//
//  newsFeedTableViewCell.h
//  IamQatar
//
//  Created by anuroop on 09/07/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newsFeedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblNewsContent;
@property (weak, nonatomic) IBOutlet UILabel *lblNewstitle;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end
