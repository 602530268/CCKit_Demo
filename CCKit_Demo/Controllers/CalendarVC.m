//
//  CalendarVC.m
//  CCKit_Demo
//
//  Created by chencheng on 2018/8/1.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "CalendarVC.h"

#import "CCCalendarView.h"
#import "CCCalendar.h"

@interface CalendarVC ()

@property(nonatomic,strong) CCCalendarView *calanderView;

@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _calanderView = [[CCCalendarView alloc] initWithFrame:CGRectZero date:nil target:self];
    [self.view addSubview:_calanderView];
    [_calanderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(self.view.mas_width).multipliedBy(0.8f);
    }];
    
    CCCalendar *calendar = [[CCCalendar alloc] init];
    [calendar logCalendarToYear:[NSDate date]];
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
