//
//  ItemsVC.m
//  CCKit_Demo
//
//  Created by chencheng on 2018/8/1.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "ItemsVC.h"

#import "CCItemsView.h"
#import "ItemCell.h"

@interface ItemsVC ()

@property(nonatomic,strong) CCItemsView *itemsView;

@end

@implementation ItemsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //不支持一行，一行的话直接用tableView就好了
    self.datas = @[@"2列",
                   @"3列",
                   @"4列",
                   @"5列",
                   @"6列",].mutableCopy;
    
    CCWeakSelf(weakSelf)
    self.didSelectRowAtIndexPath = ^(UITableView *tableView, NSIndexPath *indexPath) {
        NSInteger column = indexPath.row + 2;
        weakSelf.itemsView.column = column;
        [weakSelf.itemsView.collectionView reloadData];
    };
    
    [self createUI];
}

- (NSArray *)loadData {
    return @[@"数据源",@"数据源",@"数据源",@"数据源",
             @"数据源",@"数据源",@"数据源",@"数据源",
             @"数据源",@"数据源",@"数据源",@"数据源",
             @"数据源",@"数据源",@"数据源",@"数据源",];
}

- (void)createUI {
    NSArray *datas = [self loadData];
    
    _itemsView = [[CCItemsView alloc] init];
    _itemsView.total = datas.count; //设定总数
    _itemsView.column = 4;  //分4列展示
    [self.view addSubview:_itemsView];
    [_itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(self.view.mas_width);
    }];
    
    NSString *itemsViewCellIdentifier = kItemCellIdentifier;
    [_itemsView registerClassWith:[ItemCell class] forCellWithReuseIdentifier:itemsViewCellIdentifier];
    
    _itemsView.cellForItemAtIndexPath = ^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath) {
        ItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemsViewCellIdentifier forIndexPath:indexPath];
        cell.titleLbl.text = datas[indexPath.row];
        return cell;
    };
    
    _itemsView.didSelectItemAtIndexPath = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        ItemCell *cell = (ItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.select = !cell.select;
    };
    _itemsView.didDeselectItemAtIndexPath = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        ItemCell *cell = (ItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.select = NO;
    };
    
    [_itemsView.collectionView reloadData];
    
    _itemsView.layer.borderColor = [UIColor blackColor].CGColor;
    _itemsView.layer.borderWidth = 2.f;
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
