//
//  CCRollViewCell.m
//  ScrollView_Demo
//
//  Created by chencheng on 2018/3/5.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "CCRollViewCell.h"

@implementation CCRollViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
    }
    return self;
}

@end
