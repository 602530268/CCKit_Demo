//
//  CCPickerView.m
//  CollectionView_Text1
//
//  Created by chencheng on 2018/7/24.
//  Copyright © 2018年 Hinteen. All rights reserved.
//

#import "CCPickerView.h"
#import "CCPickerColumnView.h"

@implementation CCPickerView

# pragma mark - APIs(public)
- (void)selectRow:(NSInteger)row column:(NSInteger)column animate:(BOOL)animate {
    CCPickerColumnView *columnView = self.columnViews[column];
    [columnView selectRow:row animate:animate];
}

- (NSArray <NSString *>*)obtainValues {
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < self.columnViews.count; i++) {
        CCPickerColumnView *columnView = self.columnViews[i];
        [arr addObject:columnView.value];
    }
    return arr;
}

# pragma mark - Setter
- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    if (_columnViews && _columnViews.count > 0) {
        for (CCPickerColumnView *columnView in _columnViews) {
            columnView.normalColor = normalColor;
        }
    }
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    if (_columnViews && _columnViews.count > 0) {
        for (CCPickerColumnView *columnView in _columnViews) {
            columnView.selectColor = selectColor;
        }
    }
}

- (void)setMaskColor:(UIColor *)maskColor {
    _maskColor = maskColor;
    if (_columnViews && _columnViews.count > 0) {
        for (CCPickerColumnView *columnView in _columnViews) {
            columnView.maskColor = maskColor;
        }
    }
}

# pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame rowHeight:(CGFloat)rowHeight datas:(NSArray <NSArray *> *)datas {
    if (self == [super initWithFrame:frame]) {
        
        _datas = datas.mutableCopy;
        _rowHeight = rowHeight;
        _normalColor = [UIColor lightGrayColor];
        _selectColor = [UIColor blackColor];
        _maskColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    NSInteger column = _datas.count;
    CGFloat proportion = 1.f / (CGFloat)column;
    _columnViews = @[].mutableCopy;
    
    UIView *leftView = nil;
    for (int i = 0; i < column; i++) {
        CCPickerColumnView *columnView = [[CCPickerColumnView alloc] initWithFrame:CGRectZero rowHeight:_rowHeight];
        columnView.normalColor = _normalColor;
        columnView.selectColor = _selectColor;
        columnView.maskColor = _maskColor;
        [self addSubview:columnView];
        
        [columnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.equalTo(self).multipliedBy(proportion);
            if (i == 0) {
                make.left.equalTo(self);
            }else {
                make.left.equalTo(leftView.mas_right);
            }
        }];
        leftView = columnView;
        
        NSArray *subDatas = _datas[i];
        [columnView reloadWith:subDatas];
        
        [_columnViews addObject:columnView];
    }
}

@end
