//
//  CCCalendar.m
//  ComWell
//
//  Created by chencheng on 2018/6/8.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "CCCalendar.h"

@interface CCCalendar ()

@property(nonatomic,strong) NSCalendar *calendar;
@property(nonatomic,strong) NSDateFormatter *dateFormatter;

@end

@implementation CCCalendar

//根据date获取日
- (NSInteger)convertDateToDay:(NSDate *)date {
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitDay) fromDate:date];
    return [components day];
}

//根据date获取月
- (NSInteger)convertDateToMonth:(NSDate *)date {
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitMonth) fromDate:date];
    return [components month];
}

//根据date获取年
- (NSInteger)convertDateToYear:(NSDate *)date {
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear) fromDate:date];
    return [components year];
}

//根据date获取当月周几 (美国时间周日-周六为 1-7,改为0-6方便计算)
- (NSInteger)convertDateToWeekDay:(NSDate *)date {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:date];
    NSInteger weekDay = [components weekday] - 1;
    weekDay = MAX(weekDay, 0);
    return weekDay;
}

//根据date获取当月周几
- (NSInteger)convertDateToFirstWeekDay:(NSDate *)date {
    NSCalendar *calendar = self.calendar;
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;  //美国时间周日为星期的第一天，所以周日-周六为1-7，改为0-6方便计算
}

//根据date获取当月总天数
- (NSInteger)convertDateToTotalDays:(NSDate *)date {
    NSRange daysInOfMonth = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

//根据date获取偏移指定天数的date
- (NSDate *)getDateFrom:(NSDate *)date offsetDays:(NSInteger)offsetDays {
    NSDateFormatter *formatter = self.dateFormatter;
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSCalendar *calendar = self.calendar;
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setDay:offsetDays];  //year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    return newdate;
}

//根据date获取偏移指定月数的date
- (NSDate *)getDateFrom:(NSDate *)date offsetMonths:(NSInteger)offsetMonths {
    NSDateFormatter *formatter = self.dateFormatter;
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSCalendar *calendar = self.calendar;
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setMonth:offsetMonths];  //year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    return newdate;
}

//根据date获取偏移指定年数的date
- (NSDate *)getDateFrom:(NSDate *)date offsetYears:(NSInteger)offsetYears {
    NSDateFormatter *formatter = self.dateFormatter;
    [formatter setDateFormat:@"yyyy"];
    
    NSCalendar *calendar = self.calendar;
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setYear:offsetYears];  //year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    return newdate;
}

//获取指定月的数据
- (NSArray <CCCalendar *>*)getCalendarDataOfMonth:(NSDate *)date {
    NSInteger firstWeekDay = [self convertDateToFirstWeekDay:date];
    NSInteger totalDays = [self convertDateToTotalDays:date];
    
    NSInteger line = 5;
    NSInteger column = 7;
    
    NSInteger available = 1;    //超过总天数后为下月
    NSInteger nextMonthDay = 1; //下月天数开始计数
    
    NSDate *lastMonthDate = [self getDateFrom:date offsetMonths:-1];    //上月月数
    NSInteger lastMonthTotalDays = [self convertDateToTotalDays:lastMonthDate]; //上月天数计数
    
    NSInteger year = [self convertDateToYear:date];
    NSInteger month = [self convertDateToMonth:date];
    NSInteger day = [self convertDateToDay:date];
    
    NSInteger thisYear = [self convertDateToYear:[NSDate date]];
    NSInteger thisMonth = [self convertDateToMonth:[NSDate date]];
    
    NSMutableArray *datas = @[].mutableCopy;
    for (int i = 0; i < line; i++) {
        for (int j = 0; j < column; j++) {
            NSInteger number = 0;
            
            CCCalendar *model = [[CCCalendar alloc] init];
            model.year = year;
            model.month = month;
            
            if (available > totalDays) {
                number = nextMonthDay++;
                model.belongToNextMonth = YES;
            }else if (i == 0 && j < firstWeekDay) {
                number = lastMonthTotalDays - firstWeekDay + j + 1; //j从0开始，所以这里+1
                model.belongToLastMonth = YES;
            }else {
                number = available++;
                model.today = (day == number);
                model.earlierOfMonth = (day > number && year == thisYear && month == thisMonth);
            }
            
            model.day = number;
            [datas addObject:model];
        }
    }
    
    return datas;
}

//判断是否是今天
- (BOOL)isToday:(NSDate *)date {
    return [self.calendar isDateInToday:date];
}

//判断是否是昨天
- (BOOL)isYesterday:(NSDate *)date {
    return [self.calendar isDateInYesterday:date];
}

//判断是否是明天
- (BOOL)isTomorrow:(NSDate *)date {
    return [self.calendar isDateInTomorrow:date];
}

//判断是否是周末，周六周日为周末
- (BOOL)isWeekend:(NSDate *)date {
    return [self.calendar isDateInWeekend:date];
}

# pragma mark - Test
//打印一整年的日历到打印台
- (void)logCalendarToYear:(NSDate *)date {
    NSDateFormatter *dateFormatter = self.dateFormatter;
    for (int i = 1; i <= 12; i++) {
        NSString *string = [NSString stringWithFormat:@"2018-%02d-01",i];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:string];
        [self logCalendarToMonth:date];
    }
}

//打印某个月的日历到打印台
- (void)logCalendarToMonth:(NSDate *)date {
//    NSInteger year = [self convertDateToYear:date];
    NSInteger month = [self convertDateToMonth:date];
//    NSInteger day = [self convertDateToDay:date];
    NSInteger firstWeekDay = [self convertDateToFirstWeekDay:date];
    NSInteger totalDays = [self convertDateToTotalDays:date];
    
    printf("第%ld月\n",(long)month);
    
    NSInteger line = 5;
    NSInteger column = 7;
    
    NSInteger available = 1;    //超过总天数后为下月
    NSInteger nextMonthDay = 1; //下月天数开始计数
    
    NSDate *lastMonthDate = [self getDateFrom:date offsetMonths:-1];    //上月月数
    NSInteger lastMonthTotalDays = [self convertDateToTotalDays:lastMonthDate]; //上月天数计数
    
    for (int i = 0; i < line; i++) {
        for (int j = 0; j < column; j++) {
            if (available > totalDays) {
                printf("\t%ld ",(long)nextMonthDay++);
            }else if (i == 0 && j < firstWeekDay) {
                NSInteger lastMonthDay = lastMonthTotalDays - firstWeekDay + j + 1; //j从0开始，所以这里+1
                printf("\t%ld ",(long)lastMonthDay);
            }else {
                printf("\t%ld",(long)available++);
            }
        }
        printf("\n");
    }
    printf("\n");
    printf("\n");
}

# pragma mark - Lazy load
- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}
@end
