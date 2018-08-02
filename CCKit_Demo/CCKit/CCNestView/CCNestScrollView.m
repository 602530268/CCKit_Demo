//
//  CCNestScrollView.m
//  Sample
//
//  Created by chencheng on 2018/7/31.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "CCNestScrollView.h"

@interface CCNestScrollView ()<UIGestureRecognizerDelegate>

@end

@implementation CCNestScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    /*
     在某些情况下，contentView中的点击事件会被panGestureRecognizer拦截，导致不能响应
     这里设置cancelsTouchesInView为NO即为不拦截
     */
    self.panGestureRecognizer.cancelsTouchesInView = NO;
}

# pragma mark - UIGestureRecognizerDelegate
/*
 返回YES表示可以继续传递触摸事件，这样两个嵌套的scrollView才能同时滚动
 */
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    id view = otherGestureRecognizer.view;
    
    if (_allowGestureEventPassViews && [_allowGestureEventPassViews containsObject:view]) {
        return YES;
    }
    return NO;
}

@end
