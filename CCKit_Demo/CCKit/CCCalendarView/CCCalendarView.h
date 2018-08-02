//
//  CCCalendarView.h
//  ComWell
//
//  Created by chencheng on 2018/6/7.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCCalendarView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                         date:(NSDate *)date
                       target:(UIViewController *)target;
@end

@interface CCCalendarCell : UICollectionViewCell

@property(nonatomic,strong) UILabel *titleLbl;
@property(nonatomic,strong) UIView *touchBgView;

//选中/取消选中事件事件
- (void)selectItemWith:(BOOL)select;

@end
