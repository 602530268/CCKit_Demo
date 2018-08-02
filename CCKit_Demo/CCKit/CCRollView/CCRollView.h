//
//  CCRollView.h
//  ScrollView_Demo
//
//  Created by chencheng on 2018/3/5.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCRollView : UIView

- (instancetype)initWithFrame:(CGRect)frame imgs:(NSArray <UIImage *>*)imgs;

@property(nonatomic,strong) NSArray *imgs;  //图片数组
@property(nonatomic,assign) NSInteger currentIndex; //当前索引

@property(nonatomic,assign) BOOL autoRoll;  //自动轮播
@property(nonatomic,assign) CGFloat rollIntervalTime;   //自动轮播间隔时间

@end
