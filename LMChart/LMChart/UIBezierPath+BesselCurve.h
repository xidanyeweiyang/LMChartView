//
//  UIBezierPath+BesselCurve.h
//  LMChart
//
//  Created by liuming on 2018/1/8.
//  Copyright © 2018年 U9. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIBezierPath (BesselCurve)
/**
 *  曲线的弯曲程度, 默认值为0.7
 */
@property (nonatomic) CGFloat contractionFactor;

/**
 *  数组元素类型为 NSValue, 不能为空, 至少一个元素
 *  若为point, 需转换 [NSValue valueWithCGPoint:CGPointMake(x, y)];
 */
- (void)addBezierThroughPoints:(NSArray *)pointArray;
@end
