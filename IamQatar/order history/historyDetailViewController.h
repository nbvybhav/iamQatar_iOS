//
//  historyDetailViewController.h
//  IamQatar
//
//  Created by alisons on 8/23/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface historyDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *ivProduct;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderstatus;
@property (strong, nonatomic) IBOutlet UILabel *lblProductName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderDate;
@property (strong, nonatomic) IBOutlet UILabel *lblShippingPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderTotal;

@property (strong, nonatomic) IBOutlet UILabel *lblDeliveryAddress;
@property (strong, nonatomic) NSDictionary *productDict;
@end
