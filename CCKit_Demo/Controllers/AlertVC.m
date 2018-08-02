//
//  AlertVC.m
//  CCKit_Demo
//
//  Created by chencheng on 2018/8/1.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "AlertVC.h"
#import "CCAlertController.h"

@interface AlertVC ()

@end

@implementation AlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.datas = @[@"弹窗1",
                   @"弹窗2",
                   @"弹窗3",
                   @"底部弹窗1",
                   @"底部弹窗2",
                   @"底部弹窗3"].mutableCopy;
    
    CCWeakSelf(weakSelf)
    self.didSelectRowAtIndexPath = ^(UITableView *tableView, NSIndexPath *indexPath) {
        switch (indexPath.row) {
            case 0:
            {
                [CCAlertController showWithTitle:@"Title"
                                         message:@"message"
                                          action:@"action"
                                          target:weakSelf];
            }
                break;
            case 1:
            {
                [CCAlertController showWithTitle:@"Title"
                                         message:@"message"
                                           style:(UIAlertControllerStyleAlert)
                                    actionTitles:@[@"action",
                                                   @"action",]
                                    actionStyles:nil
                                          target:weakSelf handlers:nil];
            }
                break;
            case 2:
            {
                [CCAlertController showWithTitle:@"Title"
                                         message:@"message"
                                           style:(UIAlertControllerStyleAlert)
                                    actionTitles:@[@"action",
                                                   @"action",
                                                   @"action",]
                                    actionStyles:@[@(UIAlertActionStyleDefault),
                                                   @(UIAlertActionStyleDefault),
                                                   @(UIAlertActionStyleDestructive),]
                                          target:weakSelf handlers:nil];
            }
                break;
            case 3:
            {
                [CCAlertController showWithTitle:@"Title"
                                         message:@"message"
                                           style:(UIAlertControllerStyleActionSheet)
                                    actionTitles:@[@"action"]
                                    actionStyles:nil target:weakSelf handlers:nil];
            }
                break;
            case 4:
            {
                [CCAlertController showWithTitle:@"Title"
                                         message:@"message"
                                           style:(UIAlertControllerStyleActionSheet)
                                    actionTitles:@[@"action",
                                                   @"action",]
                                    actionStyles:nil
                                          target:weakSelf handlers:nil];
            }
                break;
            case 5:
            {
                [CCAlertController showWithTitle:@"Title"
                                         message:@"message"
                                           style:(UIAlertControllerStyleActionSheet)
                                    actionTitles:@[@"action",
                                                   @"action",
                                                   @"action",]
                                    actionStyles:@[@(UIAlertActionStyleDefault),
                                                   @(UIAlertActionStyleDefault),
                                                   @(UIAlertActionStyleCancel),]
                                          target:weakSelf handlers:nil];
            }
                break;
            default:
                break;
        }
    };
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
