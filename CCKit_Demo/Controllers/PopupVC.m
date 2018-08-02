//
//  PopupVC.m
//  CCKit_Demo
//
//  Created by chencheng on 2018/8/1.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "PopupVC.h"

#import "CCPopupContainerView.h"

@interface PopupVC ()

@property(nonatomic,strong) UIView *contentView;

@end

@implementation PopupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.datas = @[@"从上到下弹出",
                   @"从下到上弹出",
                   @"从上到下弹出，设置edgeInset值",
                   @"从下到上弹出，设置edgeInset值"].mutableCopy;
    
    CCWeakSelf(weakSelf)
    self.didSelectRowAtIndexPath = ^(UITableView *tableView, NSIndexPath *indexPath) {
        switch (indexPath.row) {
            case 0:
            {
                CCPopupContainerView *popupView = [[CCPopupContainerView alloc] initWithFrame:CGRectZero direction:XLPSPopupDirectionFromTopToBottom edgeInsets:UIEdgeInsetsZero];
                [popupView addTargetWith:[weakSelf generateContentView]];
                [popupView show];
            }
                break;
            case 1:
            {
                CCPopupContainerView *popupView = [[CCPopupContainerView alloc] initWithFrame:CGRectZero direction:XLPSPopupDirectionFromBottomToTop edgeInsets:UIEdgeInsetsZero];
                [popupView addTargetWith:[weakSelf generateContentView]];
                [popupView show];
            }
                break;
            case 2:
            {
                CCPopupContainerView *popupView = [[CCPopupContainerView alloc] initWithFrame:CGRectZero direction:XLPSPopupDirectionFromTopToBottom edgeInsets:UIEdgeInsetsMake(64.f, 0, 0, 0)];
                [popupView addTargetWith:[weakSelf generateContentView]];
                [popupView show];
            }
                break;
            case 3:
            {
                CCPopupContainerView *popupView = [[CCPopupContainerView alloc] initWithFrame:CGRectZero direction:XLPSPopupDirectionFromBottomToTop edgeInsets:UIEdgeInsetsMake(0, 0, 64.f, 0)];
                [popupView addTargetWith:[weakSelf generateContentView]];
                [popupView show];
            }
                break;
                
            default:
                break;
        }
    };
}

- (UIView *)generateContentView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor redColor];
    
    //给定高度，或者它的子view约束到位能支撑起来
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@200.f);
    }];
    return contentView;
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
