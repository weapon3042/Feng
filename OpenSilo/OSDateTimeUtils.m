//
//  OSDateTimeUtils.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/15/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import "OSDateTimeUtils.h"
static NSString * const timeFormat = @"hh:mm a/MMM dd, yyyy";
@implementation OSDateTimeUtils

+ (OSDateTimeUtils *)getInstance
{
    static OSDateTimeUtils *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OSDateTimeUtils alloc] init];
        
    });
    return manager;
}

-(NSString *)dateTimeDifference:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:timeFormat];
    
    NSDate *startDate = [dateFormatter dateFromString:dateString];
    NSDate *endDate = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    NSUInteger unitFlags = NSMonthCalendarUnit | kCFCalendarUnitWeek | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:endDate options:0];
    
    NSInteger number = 0;
    NSString *text = @"";
    NSInteger month = [components month];
    number = month;
    if (month == 0) {
        NSInteger week = [components week];
        number = week;
        if (week == 0) {
            NSInteger day = [components day];
            number = day;
            if (day == 0) {
                NSInteger hour = [components hour];
                number = hour;
                if (hour == 0) {
                    NSInteger minute = [components minute];
                    number = minute;
                    if (minute == 0) {
                        NSInteger second = [components second];
                        number = second;
                        if (second == 0) {
                            return @"Just now";
                        } else {
                            text = @"Sec";
                        }
                    } else {
                        text = @"min";
                    }
                } else {
                    text = @"hours";
                }
            } else {
                if (day == 1) {
                    return @"Yesterday";
                }
                text = @"days";
            }
        } else {
            text = @"week";
        }
    } else {
        text = @"months";
    }
    return [NSString stringWithFormat:@"%ld %@ ago",(long)number,text];
}

-(NSString *)convertDateTimeFromUTCtoLocalForDateTime:(long)timestamp {
    
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    [dateFromatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    [dateFromatter setDateFormat:timeFormat];
    [dateFromatter setTimeZone:[NSTimeZone localTimeZone]];
    if (date) {
        return [dateFromatter stringFromDate:date];
    }
    return @"";
}

-(NSString *)convertDateTimeFromUTCtoLocalWithFormat:(NSString *)fromDateTimeFormat toDateTimeFormat:(NSString *)toDateTimeFormat forDateTime:(NSString *)forDateTime {
    
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    [dateFromatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFromatter setDateFormat:fromDateTimeFormat];
    
    NSDate *date = [dateFromatter dateFromString:forDateTime];
    [dateFromatter setDateFormat:toDateTimeFormat];
    [dateFromatter setTimeZone:[NSTimeZone localTimeZone]];
    if (date) {
        return [dateFromatter stringFromDate:date];
    }
    return @"";
}

-(NSString *)convertDateTimeFromLocalToUTCWithFormat:(NSString *)fromDateTimeFormat toDateTimeFormat:(NSString *)toDateTimeFormat forDateTime:(NSString *)forDateTime {
    
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    [dateFromatter setDateFormat:fromDateTimeFormat];
    [dateFromatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *date = [dateFromatter dateFromString:forDateTime];
    [dateFromatter setDateFormat:toDateTimeFormat];
    [dateFromatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    if (date) {
        return [dateFromatter stringFromDate:date];
    }
    return @"";
}



@end
