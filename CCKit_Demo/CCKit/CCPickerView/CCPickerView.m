//
//  CCPickerView.m
//  CollectionView_Text1
//
//  Created by chencheng on 2018/7/24.
//  Copyright © 2018年 Hinteen. All rights reserved.
//

#import "CCPickerView.h"
#import "CCPickerColumnView.h"

@interface CCPickerView ()
{
    
}

@end

@implementation CCPickerView

# pragma mark - APIs(public)
- (void)normalRow:(NSInteger)row column:(NSInteger)column {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self selectRow:row column:column animate:NO];
    });
}

- (void)selectRow:(NSInteger)row column:(NSInteger)column animate:(BOOL)animate {
    CCPickerColumnView *columnView = self.columnViews[column];
    [columnView selectRow:row animate:animate];
    dispatch_async(dispatch_get_main_queue(), ^{
        [columnView restoreMaskLayer];
    });
}

- (NSInteger)column {
    return self.datas.count;
}

- (NSInteger)rowWithColumn:(NSInteger)column {
    @try {
        return [self.datas[column] count];
    }@catch (NSException *e) {return 0;}
}

- (NSString *)rowStringWithRow:(NSInteger)row column:(NSInteger)column {
    @try {
        return self.datas[column][row];
    }@catch (NSException *e) {return nil;}
}

- (NSString *)currentValueWith:(NSInteger)column {
    @try {
        CCPickerColumnView *columnView = self.columnViews[column];
        return columnView.value;
    }@catch (NSException *e) {return nil;}
}

- (NSArray *)toArray {
    NSInteger column = [self column];
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0;i < column; i++) {
        CCPickerColumnView *columnView = self.columnViews[i];
        [arr addObject:columnView.value];
    }
    return arr;
}

- (NSString *)componentsJoinedByString:(NSString *)separator {
    NSArray *arr = [self toArray];
    return [arr componentsJoinedByString:separator];;
}

- (void)reloadRowWith:(NSInteger)row column:(NSInteger)column obj:(NSString *)obj {
    CCPickerColumnView *columnView = self.columnViews[column];
    [columnView reloadRowWith:row obj:obj];
    dispatch_async(dispatch_get_main_queue(), ^{
        [columnView restoreMaskLayer];
    });
}

- (void)reloadColumnWith:(NSInteger)column array:(NSArray *)array {
    CCPickerColumnView *columnView = self.columnViews[column];
    if (array && array.count != 0) {
        NSArray *sub = self.datas[column];
        if (![sub isEqualToArray:array]) {
            [self.datas replaceObjectAtIndex:column withObject:array];
            [columnView reloadWith:self.datas[column]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [columnView restoreMaskLayer];
            });
        }
    }
}

- (void)reloadAllDatas {
    NSInteger column = [self column];
    for (int i = 0; i < column; i++) {
        [self reloadColumnWith:i array:nil];
    }
}

#pragma mark - Event
- (void)columnViewEvent:(CCPickerColumnView *)columnView {
    __weak typeof(self) weakSelf = self;
    columnView.columnViewBlock = ^(NSInteger row, NSString *value) {
        NSInteger column = 0;
        for (int i = 0; i < weakSelf.columnViews.count; i++) {
            if (columnView == weakSelf.columnViews[i]) {
                column = i;
                break;
            }
        }
        if (weakSelf.pickerViewBlock) weakSelf.pickerViewBlock(row, column, value);
    };
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
        [self columnViewEvent:columnView];
        
        [_columnViews addObject:columnView];
    }
}

@end
