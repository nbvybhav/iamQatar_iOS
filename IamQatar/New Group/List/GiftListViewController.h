//
//  GiftListViewController.h
//  IamQatar
//
//  Created by User on 11/09/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.pch"
#import "Menu.h"
#import "BaseForObjcViewController.h"

@interface GiftListViewController : BaseForObjcViewController <UITabBarDelegate,UITabBarControllerDelegate,PopMenuDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *productListCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property NSString *giftCatId;
@end
