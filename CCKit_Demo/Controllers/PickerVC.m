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

@end

@implementation PickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.datas = @[@"1列",
                   @"2列",
                   @"3列"].mutableCopy;
    
    CCWeakSelf(weakSelf)
    self.didSelectRowAtIndexPath = ^(UITableView *tableView, NSIndexPath *indexPath) {
        NSInteger column = indexPath.row + 1;
        CCPopupContainerView *popupView = [[CCPopupContainerView alloc] initWithFrame:CGRectZero direction:XLPSPopupDirectionFromBottomToTop edgeInsets:UIEdgeInsetsZero];
        [popupView addTargetWith:[weakSelf generatePickerView:column]];
        [popupView show];
    };
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
    CGFloat rowHeight = 40.f;
    CCPickerView *pickerView = [[CCPickerView alloc] initWithFrame:CGRectZero rowHeight:40.f datas:[self loadPickerViewDatas:column]];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(rowHeight * 5));
    }];
    
    pickerView.normalColor = [UIColor lightGrayColor];
    pickerView.selectColor = [UIColor blackColor];
    pickerView.maskColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
    
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
