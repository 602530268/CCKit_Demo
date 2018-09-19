//
//  NestVC.m
//  CCKit_Demo
//
//  Created by chencheng on 2018/8/1.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "NestVC.h"
#import "CCNestView.h"
#import "XLPSSegmentView.h"

static NSString *kCellIdentifier = @"kCellIdentifier";

@interface NestVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) CCNestView *nestView;
@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,strong) XLPSSegmentView *segmentView;
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) NSMutableArray *subScrollViews;

@end

@implementation NestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

# pragma mark - Event
- (void)segmentViewEvent {
    CCWeakSelf(weakSelf)
    _segmentView.selectEvent = ^(NSInteger index) {
        [weakSelf.scrollView setContentOffset:CGPointMake(CGRectGetWidth(weakSelf.scrollView.bounds) * index, 0) animated:YES];
    };
}

# pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%d",arc4random() % 100];
    return cell;
}

# pragma mark - UI
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNestView];
}

- (void)createNestView {
    [self createHeaderView];
    [self createSegmentView];
    [self createContentView];
    
    _nestView = [[CCNestView alloc] init];
    [self.view addSubview:_nestView];
    [_nestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _nestView.headerView = _headerView;
    _nestView.segmentView = _segmentView;
    _nestView.contentView = _scrollView;
    _nestView.allowGestureEventPassViews = _subScrollViews;
    _nestView.interiorHandleSubScrollViewsScrollDelegate = YES;
    
    CCWeakSelf(weakSelf)
    _nestView.nestTableViewContentInsetTop = ^CGFloat{
        return 0;
    };
    
    _nestView.nestMainScrollViewDidScroll = ^(UIScrollView *scrollView) {
        
    };
    
    _nestView.nestSubScrollViewDisScroll = ^(UIScrollView *scrollView) {
        //        NSLog(@"sub: %f",scrollView.contentOffset.y);
        //保证segment显示坐标无误
        if (scrollView.contentOffset.y > 0) {
            [weakSelf.nestView.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.nestView.headerView.superview);
            }];
        }
    };
}

- (void)createHeaderView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ps_wallet_bg"]];
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Banner Index"]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.clipsToBounds = YES;
    _headerView = imgView;
}

- (void)createSegmentView {
    _segmentView = [[XLPSSegmentView alloc] initWithFrame:CGRectZero items:@[@"我的项目",@"我的收藏"]];
    [self segmentViewEvent];
}

- (void)createContentView {
    _subScrollViews = @[].mutableCopy;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    _scrollView.scrollEnabled = NO;

    NSInteger count = 3;
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * count, 0);
    
    UIView *leftView = nil;
    for (int i = 0; i < count; i++) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.dataSource = self;
        tableView.delegate = self;
        [_scrollView addSubview:tableView];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];

        // 添加3个tableview
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(self.scrollView);
                }else {
                    make.left.equalTo(leftView.mas_right);
                }
                make.top.equalTo(self.scrollView);
                make.width.equalTo(self.view);
                make.height.equalTo(self.scrollView);
            }];
        });
        leftView = tableView;
        
        [_subScrollViews addObject:tableView];
    }

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
