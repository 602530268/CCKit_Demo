//
//  CCItemsView.h
//  Sample
//
//  Created by chencheng on 2018/7/4.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCItemsView : UIView

@property(nonatomic,assign) NSUInteger total;    //总数
@property(nonatomic,assign) NSUInteger column;   //列数，当列数大于总数的时候会有空白区
@property(nonatomic,assign) NSUInteger line;   //行数,由总数和列数得出,不要自行设置

@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,copy) void (^registerClass)(void);
@property(nonatomic,copy) UICollectionViewCell *(^cellForItemAtIndexPath)(UICollectionView *collectionView, NSIndexPath *indexPath);
@property(nonatomic,copy) void (^didSelectItemAtIndexPath)(UICollectionView *collectionView, NSIndexPath *indexPath);
@property(nonatomic,copy) void (^didDeselectItemAtIndexPath)(UICollectionView *collectionView, NSIndexPath *indexPath);

- (void)registerClassWith:(Class)_class forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNibWith:(Class)_class forCellWithReuseIdentifier:(NSString *)identifier;

@end
