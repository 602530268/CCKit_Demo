//
//  XLPSSegmentView.m
//  ProjectStreet_Demo
//
//  Created by chencheng on 2018/7/24.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "XLPSSegmentView.h"

@interface XLPSSegmentView ()

@property(nonatomic,strong) NSMutableArray *btns;
@property(nonatomic,strong) UIView *bottomLineView;

@end

@implementation XLPSSegmentView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray <NSString *> *)items {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUIWith:items];
    }
    return self;
}

- (void)createUIWith:(NSArray *)items {    
    _items = items;

    UIView *leftView = nil;
    CGFloat proportion = 1.f / (CGFloat)items.count;
    _btns = @[].mutableCopy;
    
    for (int i = 0; i < items.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:items[i] forState:UIControlStateNormal];
        [btn setTitleColor:[[UIColor blueColor] colorWithAlphaComponent:0.5f] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:btn];
        
        if (i == 0) btn.selected = YES;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.equalTo(self).multipliedBy(proportion);
            if (i == 0) {
                make.left.equalTo(self);
            }else {
                make.left.equalTo(leftView.mas_right);
            }
        }];
        leftView = btn;
        [_btns addObject:btn];
    }
    
    _bottomLineView = [[UIView alloc] init];
    [self addSubview:_bottomLineView];
    _bottomLineView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(proportion);
        make.height.equalTo(@2.f);
    }];
    
    [self controlsEvent];
}

- (void)controlsEvent {
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < _btns.count; i++) {
        UIButton *btn = _btns[i];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            [weakSelf changeBtnsStatusWith:btn];
            CGFloat lineWidth = CGRectGetWidth(_bottomLineView.bounds);
            [UIView animateWithDuration:0.25f animations:^{
                [_bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(lineWidth * i);
                }];
                [self layoutIfNeeded];
            }];
            
            weakSelf.index = i;
            if (weakSelf.selectEvent) weakSelf.selectEvent(i);
        }];
    }
}

- (void)changeBtnsStatusWith:(UIButton *)button {
    for (UIButton *btn in _btns) {
        if (btn == button) {
            btn.selected = YES;
        }else {
            btn.selected = NO;
        }
    }
}

@end
