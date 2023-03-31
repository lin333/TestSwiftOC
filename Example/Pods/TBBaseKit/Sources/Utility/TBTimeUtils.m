//
//  TBTimeUtils.m
//  Stock
//
//  Created by yangfan on 17/1/12.
//  Copyright © 2017年 com.tigerbrokers. All rights reserved.
//

#import "TBTimeUtils.h"
#import "TBLanguageManager.h"

@implementation TBTimeUtils

+ (NSInteger)getDateHour:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSTimeZone * timeZone = cal.timeZone;
    cal.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateComponents *components = [cal components:NSCalendarUnitHour fromDate:date];
    NSInteger hour = [components hour];
    
    cal.timeZone = timeZone;
    
    return hour;
}

+ (NSDate *)systemTimeZoneDateFromDateInterger:(NSInteger)time
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSDate * date = [formatter dateFromString:[NSString stringWithFormat:@"%ld",time]];
    return [self covertDateToSystemZoneDate:date];
}

+ (NSDate *)covertDateToSystemZoneDate:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSInteger)dateToInteger:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSInteger currentTime = [[formatter stringFromDate:date] longLongValue];
    return currentTime;
}

+ (NSInteger)weekdayOfDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone * timeZone = calendar.timeZone;
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    NSArray * weekdayArray = @[@(7),@(1),@(2),@(3),@(4),@(5),@(6)];
    
    weekDay = [weekdayArray[weekDay - 1] integerValue];
    calendar.timeZone = timeZone;
    return weekDay;
}

+ (NSString *)weekdayStringOfDate:(NSDate *)date {
    NSString *weekday = TBResourcesLocalizedString(@"mobile_ios_common_sunday", nil);
    switch ([self weekdayOfDate:[TBTimeUtils covertDateToSystemZoneDate:date]]) {
        case 7:
            weekday = TBResourcesLocalizedString(@"mobile_ios_common_sunday", nil);
            break;
        case 6:
            weekday = TBResourcesLocalizedString(@"mobile_ios_common_saturday", nil);
            break;
        case 5:
            weekday = TBResourcesLocalizedString(@"mobile_ios_common_friday", nil);
            break;
        case 4:
            weekday = TBResourcesLocalizedString(@"mobile_ios_common_thursday", nil);
            break;
        case 3:
            weekday = TBResourcesLocalizedString(@"mobile_ios_common_wednesday", nil);
            break;
        case 2:
            weekday = TBResourcesLocalizedString(@"mobile_ios_common_tuesday", nil);
            break;
        case 1:
            weekday = TBResourcesLocalizedString(@"mobile_ios_common_monday", nil);
            break;
        default:
            break;
    }
    return weekday;
}

+ (BOOL)isSameWeekCompare:(NSDate *)time withTime:(NSDate *)newTime
{
    BOOL isSame = NO;
    
    NSInteger time1 = [self dateToInteger:time];
    NSInteger time2 = [self dateToInteger:newTime];
    
    NSInteger smallTimeInterger = (time1 < time2 ? time1 : time2);
    NSDate * bigTime = (time1 >= time2 ? time : newTime);
    
    NSInteger bigTimeWeekday = [self weekdayOfDate:bigTime];
    NSDate * lastSunday =  [NSDate dateWithTimeInterval:-24 * 60 * 60 * bigTimeWeekday sinceDate:bigTime];//前一天
    
    NSInteger lastSundayTimeInterger =  [self dateToInteger:lastSunday];
    if(smallTimeInterger > lastSundayTimeInterger){
        isSame = YES;
    }
    
    return isSame;
}

@end
