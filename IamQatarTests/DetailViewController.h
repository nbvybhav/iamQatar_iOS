//
//  DetailViewController.h
//  IamQatarTests
//
//  Created by Alisons on 09/01/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

