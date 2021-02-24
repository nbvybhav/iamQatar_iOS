//
//  historyDetailViewController.m
//  IamQatar
//
//  Created by alisons on 8/23/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import "historyDetailViewController.h"
#import <UIImageView+WebCache.h>
#import "constants.pch"

@interface historyDetailViewController ()

@end

@implementation historyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    NSLog(@"PArray>%@",_productDict);
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",parentURL,[_productDict objectForKey:@"product_image"]];
    
    NSURL *imageURL = [NSURL URLWithString:urlString];
    _ivProduct.contentMode = UIViewContentModeScaleAspectFit;
    [_ivProduct sd_setImageWithURL:imageURL];
    
    _lblOrderNumber.text = [_productDict objectForKey:@"order_number"];
    _lblOrderstatus.text = [_productDict objectForKey:@"orderstatus"];
    _lblProductName.text = [_productDict objectForKey:@"product_name"];
    _lblOrderDate.text   = [NSString stringWithFormat:@"Order placed on \n%@",[_productDict objectForKey:@"ordered_date"]];
    _lblPrice.text       = [NSString stringWithFormat:@"QAR %@", [_productDict objectForKey:@"price"]];
    
   //-------Html stripping start-------------//
    NSString *htmlContents = [_productDict objectForKey:@"delivery_address"];
    NSRange r;
    while ((r = [htmlContents rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        htmlContents = [htmlContents stringByReplacingCharactersInRange:r withString:@" "];
    //------end---------//
    
    _lblDeliveryAddress.text = htmlContents;
    _lblShippingPrice.text   = [NSString stringWithFormat:@"QAR %@",[_productDict objectForKey:@"delivery_charge"]];
    _lblOrderTotal.text      = [NSString stringWithFormat:@"QAR %@",[_productDict objectForKey:@"price"]];
    
    if([[_productDict objectForKey:@"orderstatus"]isEqualToString:@"Cancelled"])
    {
        _lblOrderstatus.textColor = [UIColor redColor];
    }
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
