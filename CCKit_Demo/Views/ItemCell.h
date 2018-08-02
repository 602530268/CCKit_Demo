//
//  ItemCell.h
//  CCKit_Demo
//
//  Created by chencheng on 2018/8/2.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kItemCellIdentifier = @"kItemCellIdentifier";

@interface ItemCell : UICollectionViewCell

@property(nonatomic,strong) UILabel *titleLbl;
@property(nonatomic,assign) BOOL select;

@end
