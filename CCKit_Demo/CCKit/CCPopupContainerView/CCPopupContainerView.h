//
//  CCPopupContainerView.h
//  CCKit_Demo
//
//  Created by chencheng on 2018/8/1.
//  Copyright © 2018年 double chen. All rights reserved.
//

/*
 弹窗视图封装，更换装载内容显示
 
 统一加载到window上，可设置edgeInsets值
 设置弹出方向，从下往上 或 从上往下
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XLPSPopupDirection)
{
    XLPSPopupDirectionFromTopToBottom,  //从上往下
    XLPSPopupDirectionFromBottomToTop,  //从下往上
};

@interface CCPopupContainerView : UIView

@property(nonatomic,strong) UIView *containerView;  //用这个view来装载子视图

@property(nonatomic,assign) XLPSPopupDirection direction;
@property(nonatomic,assign) UIEdgeInsets edgeInsets;
@property(nonatomic,assign) CGFloat duration;   //动画时间,默认0.25f

@property(nonatomic,copy) void (^tapShadeEvent)(void);  //点击阴影事件，内部自带dismiss功能，此block仅供回调

- (instancetype)initWithFrame:(CGRect)frame direction:(XLPSPopupDirection)direction edgeInsets:(UIEdgeInsets)edgeInsets;

//添加需要装载的视图
- (void)addTargetWith:(UIView *)subView;

/*
 animate:动画，默认带动画
 finish:完成回调
 */
- (void)show;
- (void)dismiss;
- (void)showWith:(BOOL)animate finish:(void(^)(void))finish;
- (void)dismissWith:(BOOL)animate finish:(void(^)(void))finish;

@end
