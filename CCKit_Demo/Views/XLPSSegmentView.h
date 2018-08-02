//
//  XLPSSegmentView.h
//  ProjectStreet_Demo
//
//  Created by chencheng on 2018/7/24.
//  Copyright © 2018年 double chen. All rights reserved.
//

/*
 定制标签视图，底部有个自行滑动的lineView
 */

#import <UIKit/UIKit.h>

@interface XLPSSegmentView : UIView

@property(nonatomic,assign) NSInteger index;
@property(nonatomic,strong) NSArray *items;
@property(nonatomic,copy) void (^selectEvent)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray <NSString *> *)items;

@end
