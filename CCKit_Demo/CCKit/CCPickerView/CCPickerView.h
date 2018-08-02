//
//  CCPickerView.h
//  CollectionView_Text1
//
//  Created by chencheng on 2018/7/24.
//  Copyright © 2018年 Hinteen. All rights reserved.
//

/*
 暂不支持reload功能
 */

#import <UIKit/UIKit.h>

@interface CCPickerView : UIView

@property(nonatomic,strong) NSMutableArray *columnViews;
@property(nonatomic,strong) NSMutableArray *datas;
@property(nonatomic,assign) CGFloat rowHeight;

@property(nonatomic,strong) UIColor *normalColor;   //普通颜色
@property(nonatomic,strong) UIColor *selectColor;   //选择颜色
@property(nonatomic,strong) UIColor *maskColor; //中间遮罩层颜色

//定制跳转
- (void)selectRow:(NSInteger)row column:(NSInteger)column animate:(BOOL)animate;

//获取值
- (NSArray <NSString *>*)obtainValues;

- (instancetype)initWithFrame:(CGRect)frame rowHeight:(CGFloat)rowHeight datas:(NSArray <NSArray *> *)datas;

@end

