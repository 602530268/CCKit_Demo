//
//  CCRollView.m
//  ScrollView_Demo
//
//  Created by chencheng on 2018/3/5.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "CCRollView.h"
#import "Masonry.h"
#import "CCRollViewCell.h"

static NSInteger sectionCount = 100;
@interface CCRollView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL _manualRolling;    //用户手动滚动时
}

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic,strong) NSTimer *timer;

@end

@implementation CCRollView

- (instancetype)initWithFrame:(CGRect)frame imgs:(NSArray <UIImage *>*)imgs {
    if (self = [super initWithFrame:frame]) {
        _imgs = imgs;
        _currentIndex = 0;
        _autoRoll = YES;
        _rollIntervalTime = 2.0f;
        _manualRolling = NO;
        
        [self createUI];
        [self updateTimer];
    }
    return self;
}

- (void)setImgs:(NSArray *)imgs {
    _imgs = imgs;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self updateRollView:YES];
}

- (void)setAutoRoll:(BOOL)autoRoll {
    _autoRoll = autoRoll;
    [self updateTimer];
}

- (void)setRollIntervalTime:(CGFloat)rollIntervalTime {
    _rollIntervalTime = rollIntervalTime;
    [self updateTimer];
}

- (void)updateRollView:(BOOL)animate {
    //延迟一帧设置
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:sectionCount/2] atScrollPosition:UICollectionViewScrollPositionNone animated:animate];
    });
}

# pragma mark - Timer
- (void)updateTimer {
    [self removeTimer];
    if (self.autoRoll == NO || _manualRolling == YES) {
        return;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.rollIntervalTime target:self selector:@selector(autoRollViewTimer) userInfo:nil repeats:YES];
}

- (void)removeTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)autoRollViewTimer {
    
    NSLog(@"自动轮播");
    if (_currentIndex == self.imgs.count -1) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:sectionCount/2-1] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    NSInteger index = _currentIndex + 1;
    index = index >= self.imgs.count ? 0 : index;
    _currentIndex = index;
    [self updateRollView:YES];
}

# pragma mark - UI
- (void)createUI {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;  //行与行或列与列之间最短距离
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[CCRollViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    [self updateRollView:NO];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self);
    }];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pageControl.numberOfPages = self.imgs.count;
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

# pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgs.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCRollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.imgView.image = self.imgs[indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return sectionCount;
}

# pragma mark - UICollectionViewDelegate

# pragma mark - UICollectionViewDelegateFlowLayout
//设置每个item的大小，collectionView会根据item的大小自动适应到屏幕
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}

//两个cell之间的间距（同一行的cell的间距）PS:cell自适应的优先级更高
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//设置分区的上左下右距离边的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = (int) (scrollView.contentOffset.x / scrollView.frame.size.width + 0.5f) % self.imgs.count;
    _pageControl.currentPage = page;
    _currentIndex = page;
}

//用户手指开始拖动时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"用户手指触碰时");
    _manualRolling = YES;
    [self removeTimer];
}

//用户手指离开时
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"用户手指离开时");
}

//开始减速时
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"开始减速时");
}

//滚动停止时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"滚动停止时");
    int page = (int) (scrollView.contentOffset.x / scrollView.frame.size.width + 0.5f) % self.imgs.count;
    _pageControl.currentPage = page;
    _currentIndex = page;
    [self updateRollView:NO];
    
    _manualRolling = NO;
    [self updateTimer];
}

- (void)dealloc {
    NSLog(@"dealloc: %@",[self class]);
}


@end
