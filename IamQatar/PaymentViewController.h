//
//  PaymentViewController.h
//  IamQatar
//
//  Created by alisons on 4/21/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PayFortSDK/PayFortSDK.h>
@interface PaymentViewController : UIViewController <UIAlertViewDelegate,PayFortDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UILabel *qtyTxt;
@property (strong, nonatomic) IBOutlet UILabel *priceTxt;
@property (strong, nonatomic) IBOutlet UILabel *deliverChargeTxt;
@property (strong, nonatomic) IBOutlet UILabel *amountPayableTxt;
@property (strong, nonatomic) IBOutlet UILabel *grantTotal;
@property (strong,nonatomic) NSDictionary *paymentDetailsRecieved;
@property (strong, nonatomic) IBOutlet UIButton *radioBtnCard;
@property (strong, nonatomic) IBOutlet UITextField *txtCoupon;
@property (strong, nonatomic) IBOutlet UIButton *radioBtnCOD;
@property (strong, nonatomic) IBOutlet UIView *hidingView;
@property (strong, nonatomic) IBOutlet UILabel *lblcoupon;
@property (strong, nonatomic) IBOutlet UIButton *btnRemove;
@property (strong, nonatomic) IBOutlet UILabel *lblCouponPrice;
@property (weak, nonatomic) IBOutlet UIView *paymentView;
@property (weak, nonatomic) IBOutlet UIButton *btnApply;
@property (weak, nonatomic) IBOutlet UIButton *btnPlaceOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnCod;
@property (weak, nonatomic) IBOutlet UIButton *btnCardPayment;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalSaved;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalSavedHeading;

@end
