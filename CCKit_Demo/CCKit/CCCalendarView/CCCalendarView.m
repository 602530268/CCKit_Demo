//
//  CCCalendarView.m
//  ComWell
//
//  Created by chencheng on 2018/6/7.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "CCCalendarView.h"

#import "CCCalendar.h"

static NSString *kCCCalendarCellIdentifier = @"kCCCalendarCellIdentifier";

@interface CCCalendarView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UIButton *leftBtn;
@property(nonatomic,strong) UIButton *rightBtn;
@property(nonatomic,strong) UILabel *monthLbl;

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSMutableArray *datas;

@property(nonatomic,strong) CCCalendar *calendar;
@property(nonatomic,strong) NSDate *currentDate;

@property(nonatomic,strong) UIViewController *target;

@end

@implementation CCCalendarView

- (void)initData {
    
    _calendar = [[CCCalendar alloc] init];
    _datas = [self.calendar getCalendarDataOfMonth:[NSDate date]].mutableCopy;
}

# pragma mark - APIs(private)
- (void)updateCalendarData {
    NSAssert(self.currentDate, @"date can not be nil");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM"];
    
    NSString *monthOfEnglish = [dateFormatter stringFromDate:self.currentDate];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *yearString = [dateFormatter stringFromDate:self.currentDate];
    NSString *monthTitle = [NSString stringWithFormat:@"%@ %@",monthOfEnglish,yearString];
    self.monthLbl.text = monthTitle;
        
    _datas = [self.calendar getCalendarDataOfMonth:_currentDate].mutableCopy;
    [self.collectionView reloadData];
}

- (void)controlsEvent {
    __weak typeof(self) weakSelf = self;

    [[_leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        weakSelf.currentDate = [self.calendar getDateFrom:weakSelf.currentDate offsetMonths:-1];
        [weakSelf updateCalendarData];
    }];
    
    [[_rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        weakSelf.currentDate = [self.calendar getDateFrom:weakSelf.currentDate offsetMonths:1];
        [weakSelf updateCalendarData];
    }];
}

# pragma mark - UICollectionViewDataSource
//个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CCCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCCalendarCellIdentifier forIndexPath:indexPath];
    CCCalendar *model = _datas[indexPath.row];
    [cell selectItemWith:NO];
    
    cell.titleLbl.text = [NSString stringWithFormat:@"%ld",(long)model.day];
    
    UIColor *titleColor = [UIColor blackColor];
    if (model.belongToLastMonth || model.belongToNextMonth) {
        titleColor = [UIColor lightGrayColor];
    }else if (model.today) {
        titleColor = [UIColor redColor];
    }else if (model.earlierOfMonth) {
        titleColor = [UIColor darkGrayColor];
    }
    
    cell.titleLbl.textColor = titleColor;
    
    return cell;
}

# pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CCCalendar *model = _datas[indexPath.row];
    if (model.belongToNextMonth || model.belongToLastMonth) return;
    
    CCCalendarCell *cell = (CCCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell selectItemWith:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    CCCalendarCell *cell = (CCCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell selectItemWith:NO];
}

//两个cell之间的间距（同一行的cell的间距）PS:cell自适应的优先级更高
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

# pragma mark - UICollectionViewDelegateFlowLayout
//设置每个item的大小，collectionView会根据item的大小自动适应到屏幕
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger line = _datas.count <= 28 ? 4 : 5;
    CGSize size = CGSizeMake(collectionView.bounds.size.width/7, collectionView.bounds.size.height/line);
    return size;
}

# pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame
                         date:(NSDate *)date
                       target:(UIViewController *)target {
    if (self == [super initWithFrame:frame]) {
        
        self.target = target;
        _currentDate = date ? date : [NSDate date];
        
        [self initData];
        [self createUI];
        [self updateCalendarData];
        //        [self.calendar logCalendarToYear:[NSDate date]];
    }
    return self;
}

- (void)createUI {
    //    self.backgroundColor = [UIColor lightGrayColor];
    self.layer.cornerRadius = 3.f;
    __weak typeof(self) weakSelf = self;
    
    _monthLbl = [[UILabel alloc] init];
    _monthLbl.text = @"JUNE 2018";
    _monthLbl.textAlignment = NSTextAlignmentCenter;
    _monthLbl.textColor = [UIColor blackColor];
    _monthLbl.font = [UIFont systemFontOfSize:20.f];
    [self addSubview:_monthLbl];
    [_monthLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(self).multipliedBy(0.1f);
    }];
    
    _leftBtn = [[UIButton alloc] init];
    [_leftBtn setTitle:@"<" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_leftBtn];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(weakSelf.monthLbl);
        make.width.equalTo(@50.f);
    }];
    
    _rightBtn = [[UIButton alloc] init];
    [_rightBtn setTitle:@">" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_rightBtn];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(weakSelf.monthLbl);
        make.width.equalTo(@50.f);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
//    _collectionView.layer.borderColor = BaseColor.CGColor;
//    _collectionView.layer.borderWidth = 3.f;
    [_collectionView registerClass:[CCCalendarCell class] forCellWithReuseIdentifier:kCCCalendarCellIdentifier];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monthLbl.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            label.adjustsFontSizeToFitWidth = YES;
        }
    }
    
    [self controlsEvent];
}

@end

@implementation CCCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        _touchBgView = [[UIView alloc] init];
        _touchBgView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
        [self addSubview:_touchBgView];
        [_touchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.equalTo(self.mas_width).multipliedBy(0.6f);
        }];
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLbl];
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

//选中/取消选中事件事件
- (void)selectItemWith:(BOOL)select {
    
    if (select) {
        self.touchBgView.hidden = NO;
        CGFloat width = CGRectGetWidth(self.touchBgView.bounds);
        self.touchBgView.layer.cornerRadius = width / 2.f;
        self.touchBgView.layer.masksToBounds = YES;
    }else {
        self.touchBgView.hidden = YES;
    }
}

@end
