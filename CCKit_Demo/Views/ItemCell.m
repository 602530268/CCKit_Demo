//
//  ItemCell.m
//  CCKit_Demo
//
//  Created by chencheng on 2018/8/2.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
                
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLbl];
        _titleLbl.adjustsFontSizeToFitWidth = YES;
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.equalTo(self.mas_width).multipliedBy(0.6f);
        }];
        self.select = NO;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setSelect:(BOOL)select {
    _select = select;
    
    if (select) {
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
    }else {
        _titleLbl.textColor = [UIColor darkGrayColor];
        _titleLbl.backgroundColor = [UIColor lightGrayColor];
    }
}

@end
