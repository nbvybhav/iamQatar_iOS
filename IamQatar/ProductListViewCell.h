//
//  ProductListViewCell.h
//  IamQatar
//
//  Created by User on 03/06/18.
//  Copyright © 2018 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblGrayLine;
@property (weak, nonatomic) IBOutlet UIView *noStockFadeView;
@property (weak, nonatomic) IBOutlet UIImageView *imgOnSale;
@property (weak, nonatomic) IBOutlet UIView *saleTagView;
@property (weak, nonatomic) IBOutlet UILabel *lblSalesTag;

@end
