//
//  CCNestView.m
//  Sample
//
//  Created by chencheng on 2018/7/31.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "CCNestView.h"
#import "CCNestScrollView.h"

#import <Masonry.h>

@interface CCNestView ()<UIScrollViewDelegate>
{
    BOOL _subScrollViewsCanScroll;  //轮到子scrollView开始滚动
}

@property(nonatomic,strong) CCNestScrollView *mainScrollView;

@end

@implementation CCNestView

# pragma mark - Setter
- (void)setHeaderView:(UIView *)headerView {
    if (_headerView == headerView) return;
    _headerView = headerView;
    [self addHeaderView];
}

- (void)setSegmentView:(UIView *)segmentView {
    if (_segmentView == segmentView) return;
    _segmentView = segmentView;
    [self addSegmentView];
}

- (void)setContentView:(UIView *)contentView {
    if (_contentView == contentView) return;
    _contentView = contentView;
    [self addContentView];
}

- (void)setAllowGestureEventPassViews:(NSArray *)allowGestureEventPassViews {
    _allowGestureEventPassViews = allowGestureEventPassViews;
    self.mainScrollView.allowGestureEventPassViews = allowGestureEventPassViews;
}

- (void)setCanScroll:(BOOL)canScroll {
    if (_canScroll == canScroll) return;
    _canScroll = canScroll;
    if (canScroll) {
        //轮到容器开始滚动了，将子内容设置回顶部
        for (id view in self.allowGestureEventPassViews) {
            UIScrollView *scrollView;
            if ([view isKindOfClass:[UIScrollView class]]) {
                scrollView = view;
            } else if ([view isKindOfClass:[UIWebView class]]) {
                scrollView = ((UIWebView *)view).scrollView;
            }
            if (scrollView) {
                scrollView.contentOffset = CGPointZero;
            }
        }
    }
}

- (void)setInteriorHandleSubScrollViewsScrollDelegate:(BOOL)interiorHandleSubScrollViewsScrollDelegate {
    _interiorHandleSubScrollViewsScrollDelegate = interiorHandleSubScrollViewsScrollDelegate;
    if (interiorHandleSubScrollViewsScrollDelegate) {
        for (UIScrollView *scrollView in self.allowGestureEventPassViews) {
            scrollView.delegate = self;
        }
    }
}

# pragma mark - APIs (private)
//注意添加顺序
- (void)addHeaderView {
    [_mainScrollView addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_mainScrollView);
        make.height.greaterThanOrEqualTo(@(0));
    }];
}

- (void)addSegmentView {
    [_mainScrollView addSubview:_segmentView];
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.top.equalTo(_headerView.mas_bottom);
        make.height.equalTo(@(self.segmentViewHeight));
    }];
}

- (void)addContentView {
    [_mainScrollView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.top.equalTo(_segmentView.mas_bottom);
        make.centerX.bottom.equalTo(self);
    }];
}

# pragma mark - Heights
//距离顶部的距离，一般在有导航栏的情况下有效
- (CGFloat)contentInsetTop {
    if (self.nestTableViewContentInsetTop) {
        return self.nestTableViewContentInsetTop();
    }
    return 0;
}

//容器可滚动范围
- (CGFloat)heightForContainerCanScroll {
    if (_mainScrollView && _headerView) {
        return CGRectGetHeight(_headerView.frame) - [self contentInsetTop];
    } else {
        return 0;
    }
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //main 和 subs同一时刻只有一个在滚动，当满足某个条件时会互相切换
    [self mainScrollViewScroll:scrollView];
    [self subScrollViewDidScroll:scrollView];
}

//main scrollview 的滚动
- (void)mainScrollViewScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) {
        CGFloat contentOffset = [self heightForContainerCanScroll] - [self contentInsetTop];
        
//        contentOffset = CGRectGetHeight(_headerView.frame); //容器可滚动范围
//        CGFloat offsetY = scrollView.contentOffset.y;
        
        NSLog(@"contentOffset: %f，scrollView.contentOffset.y: %f",contentOffset,scrollView.contentOffset.y);
        NSLog(@"contentInset: %@",[NSValue valueWithUIEdgeInsets:scrollView.contentInset]);
//        self.mainScrollView.adjustedContentInset
        
        if (!_canScroll) {
            // 这里通过固定contentOffset的值，来实现不滚动
            scrollView.contentOffset = CGPointMake(0, contentOffset);
        } else if (scrollView.contentOffset.y >= contentOffset) {
            scrollView.contentOffset = CGPointMake(0, contentOffset);
            self.canScroll = NO;

            _subScrollViewsCanScroll = YES;
        }
        scrollView.showsVerticalScrollIndicator = _canScroll;
        
        if (self.nestMainScrollViewDidScroll) {
            self.nestMainScrollViewDidScroll(scrollView);
        }
    }
}

//sub scrollview 的滚动    public接口，供外部调用
- (void)subScrollViewDidScroll:(UIScrollView *)scrollView {
    if (_interiorHandleSubScrollViewsScrollDelegate || _exteriorCallSubScrollViewsScrollDelegate) {
        if ([self.allowGestureEventPassViews containsObject:scrollView]) {
            if (!_subScrollViewsCanScroll) {
                // 这里通过固定contentOffset，来实现不滚动
//                scrollView.contentOffset = CGPointZero;
                scrollView.contentOffset = CGPointMake(0, -scrollView.contentInset.top);    //兼容有偏移的情况
            } else if (scrollView.contentOffset.y <= 0) {
                _subScrollViewsCanScroll = NO;
                // 通知容器可以开始滚动
                self.canScroll = YES;
            }
            scrollView.showsVerticalScrollIndicator = _subScrollViewsCanScroll;
            
            if (self.nestSubScrollViewDisScroll) {
                self.nestSubScrollViewDisScroll(scrollView);
            }
        }
    }
}

# pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.canScroll = YES;
        self.exteriorCallSubScrollViewsScrollDelegate = YES;
        self.segmentViewHeight = 40.f;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _mainScrollView = [[CCNestScrollView alloc] initWithFrame:CGRectZero];
    _mainScrollView.alwaysBounceVertical = YES;
    [self addSubview:_mainScrollView];
    [_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([self contentInsetTop]);
        make.left.right.bottom.equalTo(self);
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        _mainScrollView.delegate = self;    //延迟一帧设置，避免iOS10之后scrollViewDidScroll默认执行导致的问题
        //设置大一些的contentSize使其可以滑动，因为有滚动逻辑处理，所以只要保证大于两页高度就可以了
        _mainScrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.bounds) * 1.5f);
    });
}

@end
