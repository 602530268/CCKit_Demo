//
//  CCPopupContainerView.m
//  CCKit_Demo
//
//  Created by chencheng on 2018/8/1.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "CCPopupContainerView.h"

@interface CCPopupContainerView ()

@property(nonatomic,strong) UIView *shadeView;

@end

@implementation CCPopupContainerView

# pragma mark - APIs(public)
- (void)show {
    [self showWith:YES finish:nil];
}

- (void)dismiss {
    [self dismissWith:YES finish:nil];
}

- (void)showWith:(BOOL)animate finish:(void (^)(void))finish {
    [self checkIfExist];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.frame = CGRectMake(_edgeInsets.left, _edgeInsets.top, CGRectGetWidth(window.bounds) - (_edgeInsets.left + _edgeInsets.right), CGRectGetHeight(window.bounds) - (_edgeInsets.bottom + _edgeInsets.top));
    
    [self layoutIfNeeded];
    
    self.shadeView.alpha = 0;
    self.alpha = 1.f;
    
    CGFloat containerViewHeight = CGRectGetHeight(self.containerView.bounds);
    CGFloat duration = animate ? _duration : 0;
    [UIView animateWithDuration:duration animations:^{
        self.shadeView.alpha = 1.f;
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.direction == XLPSPopupDirectionFromBottomToTop) {
                make.top.equalTo(self.mas_bottom).offset(-containerViewHeight);
            }else {
                make.top.equalTo(self).offset(0);
            }
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finish) finish();
    }];
}

- (void)dismissWith:(BOOL)animate finish:(void (^)(void))finish {
    CGFloat duration = animate ? _duration : 0;
    [UIView animateWithDuration:duration animations:^{
        self.shadeView.alpha = 0;
        
        CGFloat containerViewHeight = CGRectGetHeight(self.containerView.bounds);
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.direction == XLPSPopupDirectionFromBottomToTop) {
                make.top.equalTo(self.mas_bottom);
            }else {
                make.top.equalTo(self).offset(-containerViewHeight);
            }
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self checkIfExist];
        if (finish) finish();
    }];
}

//添加需要装载的视图
- (void)addTargetWith:(UIView *)subView {
    [self.containerView addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
}

# pragma mark - APIs (private)
- (void)checkIfExist {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *subView in window.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            [subView removeFromSuperview];
            break;
        }
    }
}

# pragma mark - Event
- (void)controlsEvent {
    __weak typeof(self) weakSelf = self;
    _shadeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapShade = [[UITapGestureRecognizer alloc] init];
    [[tapShade rac_gestureSignal] subscribeNext:^(id x) {
        [weakSelf dismiss];
        if (weakSelf.tapShadeEvent) weakSelf.tapShadeEvent();
    }];
    [_shadeView addGestureRecognizer:tapShade];
}

# pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame direction:(XLPSPopupDirection)direction edgeInsets:(UIEdgeInsets)edgeInsets {
    if (self == [super initWithFrame:frame]) {
        _direction = direction;
        _edgeInsets = edgeInsets;
        _duration = 0.25f;
        
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.clipsToBounds = YES;
    
    _shadeView = [[UIView alloc] init];
    _shadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [self addSubview:_shadeView];
    [_shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_containerView];
    
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds) / 2.f; //此时没有办法获取确切高度
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.greaterThanOrEqualTo(@0);
        if (self.direction == XLPSPopupDirectionFromBottomToTop) {
            make.top.equalTo(self.mas_bottom);
        }else {
            make.top.equalTo(self).offset(-screenHeight);
        }
    }];
    
    [self controlsEvent];
}

@end
