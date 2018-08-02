//
//  BaseUIViewController.h
//  CCKit_Demo
//
//  Created by chencheng on 2018/8/1.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CCWeakSelf(weakSelf) __weak typeof(self) weakSelf = self;

@interface BaseUIViewController : UIViewController

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *datas;

@property(nonatomic,copy) NSInteger (^numberOfRowsInSection)(UITableView *tableView, NSInteger section);
@property(nonatomic,copy) UITableViewCell * (^cellForRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);

@property(nonatomic,copy) void (^didSelectRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
@property(nonatomic,copy) void (^scrollViewDidScroll)(UIScrollView *scrollView);

@end
