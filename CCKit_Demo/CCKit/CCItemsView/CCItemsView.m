//
//  CCItemsView.m
//  Sample
//
//  Created by chencheng on 2018/7/4.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "CCItemsView.h"
#import "CCRepairExtraLineLayout.h"

static NSString *kccCollectionViewCellIdentifier = @"kccCollectionViewCellIdentifier";

@interface CCItemsView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation CCItemsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        CCRepairExtraLineLayout *flowLayout = [[CCRepairExtraLineLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_collectionView];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kccCollectionViewCellIdentifier];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}

//注册cell，
- (void)registerClassWith:(Class)_class forCellWithReuseIdentifier:(NSString *)identifier {
    if (!_collectionView) {
        NSLog(@"_collectionView 为空.");
        return;
    }
    [_collectionView registerClass:_class forCellWithReuseIdentifier:identifier];
}

- (void)registerNibWith:(Class)_class forCellWithReuseIdentifier:(NSString *)identifier {
    if (!_collectionView) {
        NSLog(@"_collectionView 为空.");
        return;
    }
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(_class) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
}

# pragma mark - Setter/Getter
- (void)setTotal:(NSUInteger)total {
    _total = total;
}

- (void)setColumn:(NSUInteger)column {
    _column = column;
}

- (NSUInteger)line {
    return (NSUInteger)ceil((float)_total / (float)_column);
}

- (UIColor *)randomColor {
    return [UIColor colorWithRed:(arc4random() % 256)/255.0f green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1.f];
}

# pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _total;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellForItemAtIndexPath) {
        return self.cellForItemAtIndexPath(collectionView, indexPath);
    }else {
        //测试用例
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kccCollectionViewCellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [self randomColor];
        return cell;
    }
    
    return nil;
}

///分区数
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 10;
//}

# pragma mark - UICollectionViewDelegate
//点击时
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectItemAtIndexPath) {
        self.didSelectItemAtIndexPath(collectionView, indexPath);
    }
}

//不在点击时，即上一次点击和这一次点击不同时
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didDeselectItemAtIndexPath) {
        self.didDeselectItemAtIndexPath(collectionView, indexPath);
    }
}

//设置每个item的大小，collectionView会根据item的大小自动适应到屏幕
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat superWidth = CGRectGetWidth(collectionView.bounds);
    CGFloat superHeight = CGRectGetHeight(collectionView.bounds);
    
    _line = (NSInteger)ceil((float)_total / (float)_column);
    
    CGFloat itemWidth = superWidth / _column;
    CGFloat itemHeight = superHeight / _line;
    
    return CGSizeMake(itemWidth, itemHeight);
}

//两个cell之间的间距（同一行的cell的间距）PS:cell自适应的优先级更高
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//这个是两行cell之间的间距（竖直布局下为上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//设置分区的上左下右距离边的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}


@end
