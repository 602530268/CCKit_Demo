//
//  CCCalendar.h
//  ComWell
//
//  Created by chencheng on 2018/6/8.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCCalendar : NSObject

@property(nonatomic,assign) NSInteger year;
@property(nonatomic,assign) NSInteger month;
@property(nonatomic,assign) NSInteger day;
@property(nonatomic,assign) NSInteger hour;
@property(nonatomic,assign) NSInteger minute;
@property(nonatomic,assign) BOOL today; //今天
@property(nonatomic,assign) BOOL yesterday; //昨天
@property(nonatomic,assign) BOOL tomorrow;  //明天
@property(nonatomic,assign) BOOL thisMonth;   //当月
@property(nonatomic,assign) BOOL thisYear;  //今年
@property(nonatomic,assign) BOOL earlierOfMonth;    //该月已过日期
@property(nonatomic,assign) BOOL belongToLastMonth; //上月日期
@property(nonatomic,assign) BOOL belongToNextMonth; //下月日期

//根据date获取日
- (NSInteger)convertDateToDay:(NSDate *)date;

//根据date获取月
- (NSInteger)convertDateToMonth:(NSDate *)date;

//根据date获取年
- (NSInteger)convertDateToYear:(NSDate *)date;

//根据date获取当月周几 (美国时间周日-周六为 1-7,改为0-6方便计算)
- (NSInteger)convertDateToWeekDay:(NSDate *)date;

//根据date获取当月周几
- (NSInteger)convertDateToFirstWeekDay:(NSDate *)date;

//根据date获取当月总天数
- (NSInteger)convertDateToTotalDays:(NSDate *)date;

//根据date获取偏移指定天数的date
- (NSDate *)getDateFrom:(NSDate *)date offsetDays:(NSInteger)offsetDays;

//根据date获取偏移指定月数的date
- (NSDate *)getDateFrom:(NSDate *)date offsetMonths:(NSInteger)offsetMonths;

//根据date获取偏移指定年数的date
- (NSDate *)getDateFrom:(NSDate *)date offsetYears:(NSInteger)offsetYears;

//获取指定月的数据
- (NSArray <CCCalendar *>*)getCalendarDataOfMonth:(NSDate *)date;

//判断是否是今天
- (BOOL)isToday:(NSDate *)date;

//判断是否是昨天
- (BOOL)isYesterday:(NSDate *)date;

//判断是否是明天
- (BOOL)isTomorrow:(NSDate *)date;

//判断是否是周末，周六周日为周末
- (BOOL)isWeekend:(NSDate *)date;

# pragma mark - Test
//打印一整年的日历到打印台
- (void)logCalendarToYear:(NSDate *)date;

//打印某个月的日历到打印台
- (void)logCalendarToMonth:(NSDate *)date;

@end
