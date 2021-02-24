//
//  checkOutViewController.h
//  IamQatar
//
//  Created by alisons on 4/12/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.pch"

@interface checkOutViewController : UIViewController <PopMenuDelegate,UITabBarControllerDelegate,UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblBillingAddress;
@property (weak, nonatomic) IBOutlet UIView *viewForPrize;
@property (weak, nonatomic) IBOutlet UILabel *AddressOutlet;
@property (weak, nonatomic) IBOutlet UILabel *NameOutlet;
@property (weak, nonatomic) IBOutlet UILabel *PriceItemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *ProductTotalCount;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollViewOutlet;
@property (weak, nonatomic) IBOutlet UILabel *DeleveryChargeOutlet;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeBillingAddress;
@property (weak, nonatomic) IBOutlet UILabel *TotalAmountMainOutlet;
@property (weak, nonatomic) IBOutlet UITableView *DeleveryTableView;
@property (weak, nonatomic) IBOutlet UILabel *TotalAmoutOutlet;
@property (strong, nonatomic) IBOutlet UIButton *continueBtn;
@property (strong, nonatomic) NSDictionary *paramRecieved;
@property (weak, nonatomic) IBOutlet UIView *viewForShipping;
@property (weak, nonatomic) IBOutlet UIView *viewForDeliveryAddress;
@property (weak, nonatomic) IBOutlet UIView *viewForBillingAddress;
@property (weak, nonatomic) IBOutlet UIImageView *shippingBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblShoppingSpeeds;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalSaved;
@property (strong, nonatomic) NSString *savedAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalSavedHeading;


 @end
