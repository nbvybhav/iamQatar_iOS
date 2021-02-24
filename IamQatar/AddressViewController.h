//
//  AddressViewController.h
//  IamQatar
//
//  Created by alisons on 4/12/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendDataBack <NSObject>
-(void)sendDataToCheckOutView : (NSMutableDictionary *) dict;
@end

@interface AddressViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property(nonatomic,assign)id Datadelegate;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *addAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property(nonatomic,assign)BOOL isBillingAddress;

@end
