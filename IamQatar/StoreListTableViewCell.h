//
//  StoreListTableViewCell.h
//  IamQatar
//
//  Created by anuroop on 27/06/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgStore;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPlace;
@property (weak, nonatomic) IBOutlet UITextView *lblWeb;
@property (weak, nonatomic) IBOutlet UITextView *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblOpen;
@property (weak, nonatomic) IBOutlet UILabel *lblOffer;
@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UIView *tagsView;
@property (weak, nonatomic) IBOutlet UIImageView *offerGradient;
@property (weak, nonatomic) IBOutlet UITextView *lblTag;

@end
