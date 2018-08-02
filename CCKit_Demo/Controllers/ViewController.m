//
//  ViewController.m
//  CCKit_Demo
//
//  Created by chencheng on 2018/8/1.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "ViewController.h"
#import "NestVC.h"

static NSString *kCellIdentifier = @"kCellIdentifier";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     将我在项目中有所收获的功能或封装进行整理，总会有可以优化的地方，边使用边完善吧
     库里大部分的控件都是用Masonry布局
     */
    self.title = @"CCKit";
    
    [self loadDatas];
    
    __weak typeof(self) weakSelf = self;
    self.cellForRowAtIndexPath = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
        NSDictionary *info = weakSelf.datas[indexPath.row];
        cell.textLabel.text = info[@"title"];
        cell.detailTextLabel.text = info[@"detail"];
        
        return cell;
    };
    
    self.didSelectRowAtIndexPath = ^(UITableView *tableView, NSIndexPath *indexPath) {
        NSDictionary *info = weakSelf.datas[indexPath.row];
        Class Controller = NSClassFromString(info[@"vc"]);
        BaseUIViewController *vc = [[Controller alloc]init];
        vc.title = info[@"title"];
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    BaseUIViewController *vc = [[BaseUIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadDatas {
    self.datas = @[@{@"title":@"CCPopupContainerView",
                     @"detail":@"弹窗装载视图",
                     @"vc":@"PopupVC"},
                   @{@"title":@"CCPickerView",
                     @"detail":@"picker风格选择器",
                     @"vc":@"PickerVC"},
                   @{@"title":@"CCCalendar",
                     @"detail":@"日历",
                     @"vc":@"CalendarVC"},
                   @{@"title":@"CCAlertController",
                     @"detail":@"系统弹窗",
                     @"vc":@"AlertVC"},
                   @{@"title":@"CCItemsView",
                     @"detail":@"多格列表",
                     @"vc":@"ItemsVC"},
                   @{@"title":@"CCRollView",
                     @"detail":@"轮播图",
                     @"vc":@"RollVC"},
                   @{@"title":@"CCNestView",
                     @"detail":@"scrollView嵌套scrollView",
                     @"vc":@"NestVC"},].mutableCopy;
}

# pragma mark - Other
- (void)dealloc {
    NSLog(@"dealloc: %@",[self class]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
