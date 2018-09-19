//
//  PickerVC.m
//  CCKit_Demo
//
//  Created by chencheng on 2018/8/1.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "PickerVC.h"
#import "CCPickerView.h"
#import "CCPopupContainerView.h"

@interface PickerVC ()

@property(nonatomic,strong) CCPickerView *pickerView;

@end

@implementation PickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.datas = @[@"1列",
                   @"2列",
                   @"3列",].mutableCopy;
    
    CCWeakSelf(weakSelf)
    self.didSelectRowAtIndexPath = ^(UITableView *tableView, NSIndexPath *indexPath) {
        if (indexPath.row <= 2) {
            NSInteger column = indexPath.row + 1;
            
            CCPickerView *pickerView = [weakSelf generatePickerView:column];
            [pickerView normalRow:2 column:0];
            
            CCPopupContainerView *popupView = [[CCPopupContainerView alloc] initWithFrame:CGRectZero direction:XLPSPopupDirectionFromBottomToTop edgeInsets:UIEdgeInsetsZero];
            [popupView addTargetWith:pickerView];
            [popupView show];
            
            popupView.tapShadeEvent = ^{
                NSLog(@"获取列数:%ld",[pickerView column]);
                NSLog(@"获取指定列的行数:%ld",[pickerView rowWithColumn:0]);
                NSLog(@"获取指定行列的字符串:%@",[pickerView rowStringWithRow:2 column:0]);
                NSLog(@"按列数顺序转成数组返回:%@",[pickerView toArray]);
                NSLog(@"使用指定字符串将数据拼接返回:%@",[pickerView componentsJoinedByString:@"-"]);
            };
            
            pickerView.pickerViewBlock = ^(NSInteger row, NSInteger column, NSString *value) {
                NSLog(@"row:%ld,column:%ld,value:%@",row,column,value);
            };
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSLog(@"刷新指定行数据");
//                [weakSelf.pickerView reloadRowWith:0 column:0 obj:@"hello"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    NSLog(@"刷新指定列数据");
//                    NSArray *arr = @[@"q",@"w",@"e",@"r",@"t",@"y"];
//                    [weakSelf.pickerView reloadColumnWith:0 array:arr];
//
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        NSLog(@"刷新所有数据");
//                        NSMutableArray *total = @[].mutableCopy;
//                        for (int i = 0; i < 3; i++) {
//                            NSMutableArray *arr = @[].mutableCopy;
//                            int ran = arc4random() % 50 + 10;
//                            for (int i = 0; i < ran; i++) {
//                                [arr addObject:[NSString stringWithFormat:@"%d",i]];
//                            }
//                            [total addObject:arr];
//                        }
//                        weakSelf.pickerView.datas = total;
//                        [weakSelf.pickerView reloadAllDatas];
//                    });
//                });
//            });
            
            weakSelf.pickerView = pickerView;
        }
    };
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger column = 2;
        
        CCPickerView *pickerView = [weakSelf generatePickerView:column];
        CCPopupContainerView *popupView = [[CCPopupContainerView alloc] initWithFrame:CGRectZero direction:XLPSPopupDirectionFromBottomToTop edgeInsets:UIEdgeInsetsZero];
        [popupView addTargetWith:pickerView];
        [popupView show];

    });
    
}

- (NSArray *)loadPickerViewDatas:(NSInteger)column {
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < column; i++) {
        NSMutableArray *subArr = @[].mutableCopy;
        NSInteger arc = arc4random() % 50 + 10;
        for (int j = 0; j < arc; j++) {
            [subArr addObject:[NSString stringWithFormat:@"%d",j]];
        }
        [arr addObject:subArr];
    }
    return arr;
}

- (CCPickerView *)generatePickerView:(NSInteger)column {
    CGFloat rowHeight = 50.f;
    CCPickerView *pickerView = [[CCPickerView alloc] initWithFrame:CGRectZero rowHeight:rowHeight datas:[self loadPickerViewDatas:column]];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(rowHeight * 5));
    }];
    
    pickerView.normalColor = [UIColor lightGrayColor];
    pickerView.selectColor = [UIColor redColor];
    pickerView.maskColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [pickerView selectRow:5 column:0 animate:YES];
    });
//    return;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [pickerView selectRow:5 column:0 animate:YES];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [pickerView selectRow:10 column:0 animate:NO];
//        });
//
//    });
    
    return pickerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
