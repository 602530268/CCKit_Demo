//
//  CCPickerView.h
//  CollectionView_Text1
//
//  Created by chencheng on 2018/7/24.
//  Copyright © 2018年 Hinteen. All rights reserved.
//

/*
 pickerView封装，仅支持显示NSString类型数据
 */

#import <UIKit/UIKit.h>

@interface CCPickerView : UIView

@property(nonatomic,strong) NSMutableArray *columnViews;
@property(nonatomic,strong) NSMutableArray *datas;
@property(nonatomic,assign) CGFloat rowHeight;

@property(nonatomic,strong) UIColor *normalColor;   //普通颜色
@property(nonatomic,strong) UIColor *selectColor;   //选择颜色
@property(nonatomic,strong) UIColor *maskColor; //中间遮罩层颜色

- (instancetype)initWithFrame:(CGRect)frame rowHeight:(CGFloat)rowHeight datas:(NSArray <NSArray *> *)datas;

//停止滚动或手动点击时，回调当前索引
@property(nonatomic,copy) void(^pickerViewBlock)(NSInteger row, NSInteger column, NSString *value);

//默认行列，设置该方法后内部将会在一帧后无动画的跳转行列
- (void)normalRow:(NSInteger)row column:(NSInteger)column;

//定制跳转，需要在pickerView有意义的时候执行，即至少在一帧后
- (void)selectRow:(NSInteger)row column:(NSInteger)column animate:(BOOL)animate;

- (NSInteger)column;    //列数
- (NSInteger)rowWithColumn:(NSInteger)column; //获取指定列的行数
- (NSString *)rowStringWithRow:(NSInteger)row column:(NSInteger)column; //获取指定行列的字符串
- (NSString *)currentValueWith:(NSInteger)column; //获取指定列当前行的数据
- (NSArray *)toArray; //按列数顺序转成数组返回
- (NSString *)componentsJoinedByString:(NSString *)separator; //使用指定字符串将数据拼接返回

- (void)reloadRowWith:(NSInteger)row column:(NSInteger)column obj:(NSString *)obj; //刷新指定行数据
- (void)reloadColumnWith:(NSInteger)column array:(NSArray *)array; //刷新指定列数据
- (void)reloadAllDatas; //刷新所有数据

@end

