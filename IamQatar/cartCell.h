//
//  cartCell.h
//  IamQatar
//
//  Created by alisons on 8/29/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cartCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *qtyPickerContView;

@property (weak, nonatomic) IBOutlet UIButton *btnChangeDate;
@property (weak, nonatomic) IBOutlet UILabel *lblGift;
@property (weak, nonatomic) IBOutlet UIImageView *cartImage;

@property (weak, nonatomic) IBOutlet UITextField *cartQty;
@property (weak, nonatomic) IBOutlet UILabel *cartComboGifts;

@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UILabel *lblAttribute;
@property (weak, nonatomic) IBOutlet UIButton *btnPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UIButton *kolamazzbtnMinus;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;


@end
