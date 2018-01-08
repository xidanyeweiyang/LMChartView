//
//  NSObject+DateCalendar.m
//  LMChart
//
//  Created by liuming on 2018/1/8.
//  Copyright © 2018年 U9. All rights reserved.
//

#import "NSObject+DateCalendar.h"

@implementation NSObject (DateCalendar)
- (NSInteger)numberOfDaysCurrentMonth {
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger days = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth  forDate:currentDate].length;
    return days;
}
@end
