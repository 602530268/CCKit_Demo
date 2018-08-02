//
//  CCAlertController.m
//  Recollect_Demo
//
//  Created by chencheng on 2018/5/14.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "CCAlertController.h"

@implementation CCAlertController

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
               action:(NSString *)action
               target:(UIViewController *)target {
    [self showWithTitle:title
                message:message
                  style:UIAlertControllerStyleAlert
           actionTitles:@[action]
           actionStyles:nil
                 target:target
               handlers:nil];
}

+ (void)showWithTitle:(NSString *)title
               message:(NSString *)message
                 style:(UIAlertControllerStyle)style
          actionTitles:(id)actionTitles
          actionStyles:(id)actionStyles
                target:(UIViewController *)target
              handlers:(void(^)(NSInteger index))handlers {
    
    UIAlertControllerStyle controllerStyle = style;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:controllerStyle];
    
    if ([actionTitles isKindOfClass:[NSString class]]) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handlers) {
                handlers(0);
            }
        }];
        [alertController addAction:action];
    }else if ([actionTitles isKindOfClass:[NSArray class]]) {
        
        NSArray *titles = (NSArray *)actionTitles;
        NSArray *styles = (NSArray *)actionStyles;
        
        for (int i = 0; i < titles.count; i++) {
            
            UIAlertActionStyle actionStyle;
            if (styles == nil) {
                actionStyle = UIAlertActionStyleDefault;  //默认
            }else {
                actionStyle = [styles[i] integerValue];
            }
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i] style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
                if (handlers) {
                    handlers(i);
                }
            }];
            [alertController addAction:action];
        }
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [target presentViewController:alertController animated:YES completion:nil];
    });
}

@end
