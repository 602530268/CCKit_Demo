//
//  CCPickerColumnView.m
//  CollectionView_Text1
//
//  Created by chencheng on 2018/7/24.
//  Copyright © 2018年 Hinteen. All rights reserved.
//

#import "CCPickerColumnView.h"

static NSString *kCCPickerCellIdentifier = @"kCCPickerCellIdentifier";

@interface CCPickerColumnView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,assign) CGFloat rowHeight;  //高度要固定，不允许动态变化
@property(nonatomic,strong) NSMutableArray *datas;

@end

@implementation CCPickerColumnView

# pragma mark - APIs (public)
- (void)reloadWith:(NSArray <NSString *>*)datas {
    _datas = datas.mutableCopy;
    _currentRow = _currentRow >= _datas.count - 1 ? _datas.count - 1 : _currentRow;
    [self.collectionView reloadData];
}

- (void)reloadRowWith:(NSInteger)row obj:(NSString *)obj {
    if (obj) {
        [self.datas replaceObjectAtIndex:row withObject:obj];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:row];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)restoreMaskLayer {
    [self handle:self.collectionView];
}

//跳到选中行
- (void)selectRow:(NSInteger)row animate:(BOOL)animate {
    CGFloat contentOffsetY = row * self.rowHeight - self.collectionView.contentInset.top;
    [self.collectionView setContentOffset:CGPointMake(0, contentOffsetY) animated:animate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollViewDidEndScroll];
    });
}

- (NSString *)value {
    return _datas[_currentRow];
}

# pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCPickerColumnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCPickerCellIdentifier forIndexPath:indexPath];
    
    cell.titleLbl.text = _datas[indexPath.row];
    cell.renderLbl.text = cell.titleLbl.text;
    cell.titleLbl.textColor = self.normalColor;
    cell.renderLbl.textColor = self.selectColor;
    cell.renderLbl.backgroundColor = self.maskColor;
    if (indexPath.row == _currentRow) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self restoreMaskLayer];
        });
    }
    
    return cell;
}

//点击时
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _currentRow) return;
    _currentRow = indexPath.row;
    [self selectRow:indexPath.row animate:YES];
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

# pragma mark - UICollectionViewDelegateFlowLayout
//设置每个item的大小，collectionView会根据item的大小自动适应到屏幕
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(collectionView.bounds.size.width, self.rowHeight);
    return size;
}

# pragma mark - UIScrollViewDelegate
/*
 借鉴于
 https://www.jianshu.com/p/c3f489db8283
 自然的居中效果
 */
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat targetOffset = targetContentOffset->y + scrollView.contentInset.top;
    CGFloat partialRow = targetOffset / self.rowHeight;
    NSInteger roundedRow = lroundf(partialRow);
    
    if (roundedRow < 0) {
        roundedRow = 0;
    } else {
        targetContentOffset->y = (NSInteger)roundedRow * self.rowHeight - scrollView.contentInset.top;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self handle:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self scrollViewDidEndScroll];
        }
    }
}

//停止滚动
- (void)scrollViewDidEndScroll {
    if (self.columnViewBlock) self.columnViewBlock(_currentRow,self.value);
}

#pragma mark - APIs (private)
- (void)handle:(UIScrollView *)scrollView {
    
    /*
     在有效区间内时，总会有两个cell需要改变maskLayer的值
     计算中间展示区间内对应了两个cell
     通过差值设置cell的遮罩
     */
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //判断offsetY在第几行
    NSInteger topRow = (offsetY + scrollView.contentInset.top) / self.rowHeight;
    NSInteger bottomRow = floorf((offsetY + scrollView.contentInset.top + self.rowHeight) / self.rowHeight);
    
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:topRow inSection:0];
    NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:bottomRow inSection:0];
    
    CCPickerColumnCell *topCell = (CCPickerColumnCell *)[self.collectionView cellForItemAtIndexPath:topIndexPath];
    CCPickerColumnCell *bottomCell = (CCPickerColumnCell *)[self.collectionView cellForItemAtIndexPath:bottomIndexPath];
    
    CGFloat dValue = (offsetY + scrollView.contentInset.top) - topRow * self.rowHeight; //差值
    if (dValue < 0) {
        dValue += self.rowHeight;   //此时frame.y会小一个height值，这里特殊处理
    }
    //    NSLog(@"差值: %f",dValue);
    
    topCell.maskLayer.hidden = NO;
    bottomCell.maskLayer.hidden = NO;
    
    CGFloat cellWidth = CGRectGetWidth(topCell.bounds);
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    topCell.maskLayer.frame = CGRectMake(0, dValue, cellWidth, self.rowHeight);
    bottomCell.maskLayer.frame = CGRectMake(0, -self.rowHeight + dValue, cellWidth, self.rowHeight);
    [CATransaction commit];
    
    //当滑动太快，有些maskLayer会来不及收回，这里统一处理
    NSArray *visibleCells = [self.collectionView visibleCells];
    for (CCPickerColumnCell *cell in visibleCells) {
        if (cell != topCell && cell != bottomCell) {
            cell.maskLayer.frame = CGRectZero;
            cell.maskLayer.hidden = YES;
        }
    }
    
    _currentRow = topRow;   //记录
}

# pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame rowHeight:(CGFloat)rowHeight {
    if (self == [super initWithFrame:frame]) {
        _rowHeight = rowHeight;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat inset = (self.collectionView.frame.size.height - self.rowHeight) / 2;
        self.collectionView.contentInset = UIEdgeInsetsMake(inset, 0, inset, 0);
        [self selectRow:0 animate:NO];  //默认选择0
    });
    
    [_collectionView registerClass:[CCPickerColumnCell class] forCellWithReuseIdentifier:kCCPickerCellIdentifier];
    
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:@{@"collectionView":self.collectionView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:@{@"collectionView":self.collectionView}]];
}

@end

@implementation CCPickerColumnCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor lightGrayColor];
        _titleLbl.backgroundColor = [UIColor whiteColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLbl];
        _titleLbl.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLbl]|" options:0 metrics:nil views:@{@"titleLbl":_titleLbl}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLbl]|" options:0 metrics:nil views:@{@"titleLbl":_titleLbl}]];
        
        _renderLbl = [[UILabel alloc] init];
        _renderLbl.textColor = [UIColor blackColor];
        _renderLbl.backgroundColor = [UIColor whiteColor];
        _renderLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_renderLbl];
        _renderLbl.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[renderLbl]|" options:0 metrics:nil views:@{@"renderLbl":_renderLbl}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[renderLbl]|" options:0 metrics:nil views:@{@"renderLbl":_renderLbl}]];
        
        _maskLayer = [[CALayer alloc] init];
        _maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _renderLbl.layer.mask = _maskLayer;
    }
    return self;
}

@end
