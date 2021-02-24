//
//  AddressCell.h
//  IamQatar
//
//  Created by alisons on 4/12/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
-(void) setSelected:(BOOL)selected;
@property (weak, nonatomic) IBOutlet UIButton *radioButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
