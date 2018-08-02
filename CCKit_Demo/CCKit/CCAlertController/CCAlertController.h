//
//  CCAlertController.h
//  Recollect_Demo
//
//  Created by chencheng on 2018/5/14.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CCAlertController : NSObject

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
               action:(NSString *)action
               target:(UIViewController *)target;

/*
 title:             标题
 messag:            内容
 style:             弹窗类型,
 actionTitles:      actitions标题数组
 actionStyles:      actions类型
 handlers:          回调
 target:            调用者
 */
+ (void)showWithTitle:(NSString *)title
               message:(NSString *)message
                 style:(UIAlertControllerStyle)style
          actionTitles:(id)actionTitles
          actionStyles:(id)actionStyles
                target:(UIViewController *)target
              handlers:(void(^)(NSInteger index))handlers;

@end
