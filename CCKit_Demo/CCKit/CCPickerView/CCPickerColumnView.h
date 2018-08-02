//
//  CCPickerColumnView.h
//  CollectionView_Text1
//
//  Created by chencheng on 2018/7/24.
//  Copyright © 2018年 Hinteen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCPickerColumnView : UIView

@property(nonatomic,strong) UIColor *normalColor;
@property(nonatomic,strong) UIColor *selectColor;
@property(nonatomic,strong) UIColor *maskColor; 

@property(nonatomic,assign) NSInteger currentRow;     //记录当前是第几行
@property(nonatomic,strong) id value;   //值

- (instancetype)initWithFrame:(CGRect)frame rowHeight:(CGFloat)rowHeight;

//加载数据
- (void)reloadWith:(NSArray <NSString *>*)datas;

//跳到选中行
- (void)selectRow:(NSInteger)row animate:(BOOL)animate;

@end

@interface CCPickerColumnCell : UICollectionViewCell

@property(nonatomic,strong) UILabel *titleLbl;
@property(nonatomic,strong) UILabel *renderLbl; //渲染
@property(nonatomic,strong) CALayer *maskLayer; //渲染遮罩

@end
