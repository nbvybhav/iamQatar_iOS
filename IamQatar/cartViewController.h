//
//  FifthViewController.h
//  IamQatar
//
//  Created by alisons on 8/18/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "BaseForObjcViewController.h"
#import "constants.pch"
#import "cartCell.h"

@interface cartViewController : BaseForObjcViewController <UITabBarControllerDelegate,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,PopMenuDelegate,UITextFieldDelegate,UIPickerViewDelegate,PopMenuDelegate>
//@property (nonatomic,strong)NSMutableArray *itemsArray;

@property (strong, nonatomic) IBOutlet UIView *emptyView;
@property (strong, nonatomic) IBOutlet UILabel *savedAmnt;

@property (strong, nonatomic) IBOutlet UIView *qtyPickerView;
@property (weak, nonatomic) IBOutlet UITableView *cartTableView;

@property (weak, nonatomic) IBOutlet UILabel *cartSubTotal;
@property (weak, nonatomic) IBOutlet UIButton *cartTotal;

@property (weak, nonatomic) IBOutlet UIView *priceDtailsView;

- (IBAction)onEditBtnClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *editBtnOutlet;

@property (strong, nonatomic) IBOutlet UIPickerView *qtyPicker;
@property (strong, nonatomic) IBOutlet UIButton *checkOutBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblSavedAmount;

@end
