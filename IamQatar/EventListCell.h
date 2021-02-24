//
//  ListCellTableViewCell.h
//  IamQatar
//
//  Created by alisons on 9/3/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIImageView *ivIconImage;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imgDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgTag;
@property (weak, nonatomic) IBOutlet UIButton *tagBtnOne;
@property (weak, nonatomic) IBOutlet UIButton *tagBtnTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblTagOne;
@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UIView *tagsView;
@property (weak, nonatomic) IBOutlet UILabel *lblTagTwo;
@end
