//
//  LMChart2.h
//  LMChart
//
//  Created by liuming on 2018/1/8.
//  Copyright © 2018年 U9. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMChart2 : UIView
/**
 肌肤年龄表格
 
 @param xTitlesArr x轴文字集合
 @param yTitlesArr y轴文字集合
 @return 表格
 */
- (instancetype)initWithXtitlesArr:(NSArray *)xTitlesArr
                         yTilesArr:(NSArray *)yTitlesArr
                          timeType:(USkinTimeType)timeType;

/**
 表格填充数据
 
 @param dataArr y的值
 */
- (void)fillDataWithArr:(NSArray *)dataArr;
@end
