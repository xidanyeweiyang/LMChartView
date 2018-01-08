//
//  LMChartView1.m
//  LMChart
//
//  Created by liuming on 2018/1/8.
//  Copyright © 2018年 U9. All rights reserved.
//

#import "LMChartView1.h"

@interface LMChartView1 () {
    CGContextRef context;
    dispatch_queue_t drawQueue;
}
@property (nonatomic, strong) NSArray *xTitlesArr;
@property (nonatomic, strong) NSArray *yTitlesArr;
@property (nonatomic, strong) NSArray *yValuesArr;
@property (nonatomic, assign) USkinTimeType timeType;
@property (nonatomic, strong) NSArray *defaultYtitlesArr;
@property (nonatomic, strong) NSArray *defaultYvaluesArr;
@property (nonatomic, assign) NSInteger shuXianAccount;

@end

@implementation LMChartView1

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    context = UIGraphicsGetCurrentContext();
    [self drawVerticalLine];
    [self drawHorizontalLine];
    [self drawXArrowWithContext:context];
    [self drawYArrowWithContext:context];
}
#pragma mark - 初始化
-(instancetype)initWithXtitlesArr:(NSArray *)xTitlesArr
                        yTilesArr:(NSArray *)yTitlesArr
                         timeType:(USkinTimeType)timeType{
    if (self = [super init]) {
        _timeType = timeType;
        _xTitlesArr = xTitlesArr;
        _yTitlesArr = yTitlesArr.count == 0 ? self.defaultYtitlesArr : yTitlesArr;
        if (timeType == USkinTimeTypeDay) {
            _shuXianAccount = 24;
        } else if (timeType == USkinTimeTypeWeek) {
            _shuXianAccount = 7;
        } else {
            _shuXianAccount = [self numberOfDaysCurrentMonth];
        }
        //        self.userInteractionEnabled = YES;
        //        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(touchGestureRecognizer:)];
        //        [self addGestureRecognizer:pan];
        //
        //        UILongPressGestureRecognizer * tap =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(touchGestureRecognizer:)];
        //        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - 手势代理
//-(void)touchGestureRecognizer:(UIGestureRecognizer*)pan{
////    CGPoint touchPoint = [pan locationInView:self];
//    if (pan.state ==UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
//
//
//    } else if(pan.state == UIGestureRecognizerStateCancelled||pan.state == UIGestureRecognizerStateEnded){
//
//    }
//}
//- (void)showLinePointValueWithPoint:(CGPoint)point {
//
//}
#pragma mark - 填充数据
-(void)fillDataWithArr:(NSArray *)dataArr {
    _yValuesArr = dataArr.count == 0 ? self.defaultYvaluesArr : dataArr;
//    UIBezierPath *linePath = [self linePathWihtYvalueArr:dataArr];
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.lineWidth = 1.0f;
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.strokeColor = UIColorFromRGB(0xfb8394).CGColor;
//    shapeLayer.path = linePath.CGPath;
//    [self.layer addSublayer:shapeLayer];
    [self setGradientColor];
}
- (void)setGradientColor {
    UIBezierPath *linePath = [self fillPathWihtYvalueArr:self.yValuesArr];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    shapeLayer.strokeColor = UIColorFromRGB(0xfb8394).CGColor;
    shapeLayer.path = linePath.CGPath;
    shapeLayer.lineWidth = 1.0f;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.width, self.height);
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)UIColorFromRGB(0xfb8394).CGColor,(id)Col_0xffffff.CGColor, nil]];
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.borderWidth  = 0.1;
    [gradientLayer setMask:shapeLayer];
    
    [self.layer addSublayer:gradientLayer];
}

- (UIBezierPath *)linePathWihtYvalueArr:(NSArray *)yValueArr {
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < yValueArr.count; i++) {
        CGPoint onePoint = [self linePointWithYvalue:[yValueArr[i] floatValue] index:i];
        if (i == 0) {
            [path moveToPoint:onePoint];
        } else {
            [path addLineToPoint:onePoint];
        }
    }
    return path;
}
- (UIBezierPath *)fillPathWihtYvalueArr:(NSArray *)yValueArr {
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.contractionFactor = 0.8;
    
    NSMutableArray *pointArray = [NSMutableArray array];
    for (NSInteger i = 0; i < yValueArr.count; i++) {
        CGPoint onePoint = [self linePointWithYvalue:[yValueArr[i] floatValue] index:i];
        if (i == 0) {
            [path moveToPoint:onePoint];
        } else {
            NSValue *val = [NSValue valueWithCGPoint:onePoint];
            [pointArray addObject:val];
//            [path addLineToPoint:onePoint];
        }
    }
    
    [path addBezierThroughPoints:pointArray];

    CGPoint endPoint1 = CGPointMake(LineStartX + HorizontalLineW, LineStartY + VerticalLineH);
    CGPoint endPoint2 = CGPointMake(LineStartX,LineStartY + VerticalLineH);
    [path addLineToPoint:endPoint1];
    [path addLineToPoint:endPoint2];
    [path addLineToPoint:[self linePointWithYvalue:[self.yValuesArr[0] floatValue]index:0]];
    
    return path;
}

- (CGPoint)linePointWithYvalue:(CGFloat)yValue index:(NSInteger)index {
    NSInteger spaceCount = self.shuXianAccount - 1;
    CGFloat space = HorizontalLineW / spaceCount;
    CGPoint point = CGPointZero;
    CGFloat y = LineStartY + VerticalLineH - (VerticalLineH * yValue ) ;
    CGFloat x = LineStartX + index * space;
    
    point = CGPointMake(x, y);
    return point;
}

#pragma mark - 画竖线
- (void)drawVerticalLine {
    //画竖线
    NSInteger spaceCount = self.shuXianAccount - 1;
    CGFloat space = HorizontalLineW / spaceCount;
    CGFloat startX;
    CGFloat startY;
    CGFloat endX;
    CGFloat endY;
    CGFloat lineW;
    UIColor *lineColor;
    
    for (NSInteger i = 1; i <= self.shuXianAccount; i ++) {
        if (i == 1) {
            lineW = Fix375(2);
            lineColor = UIColorFromRGB(0xfb8394);
            startY = Fix375(7);
            endY = LineStartY + VerticalLineH + lineW / 2;
        } else {
            lineW = Fix375(1);
            lineColor = UIColorFromRGB(0xf5f5f5);
            startY = LineStartY;
            endY = LineStartY + VerticalLineH;
        }
        startX = LineStartX + (i - 1) * space - lineW / 2;
        endX = LineStartX + (i - 1) * space - lineW / 2;
        
        CGPoint startPoint = CGPointMake(startX, startY);
        CGPoint endPoint = CGPointMake(endX, endY);
        
        [self drawLineWithContext:context startPoint:startPoint endPoint:endPoint lineColor:lineColor lineWidth:lineW];
        
    }
    
    //X轴文字
    CGFloat textX;
    CGFloat textY;
    CGFloat textW;
    CGFloat textH;
    
    for (NSInteger i = 1; i <= self.xTitlesArr.count; i++) {
        UIColor *textColor;
        if (i == self.xTitlesArr.count) {
            textColor = UIColorFromRGB(0xfb8394);
        } else {
            textColor = Col_0x999999;
        }
        
        NSString *xTitleStr = self.xTitlesArr[i - 1];
        NSDictionary *attDic = @{NSFontAttributeName : [UIFont systemFontOfSize:Fix375(9)],
                                 NSForegroundColorAttributeName:textColor};
        CGSize xTitleStrSize = [xTitleStr sizeWithAttributes:attDic];
        
        CGFloat textSpace =   HorizontalLineW / (self.xTitlesArr.count - 1);
        
        textX = LineStartX + (i - 1) * textSpace - xTitleStrSize.width / 2;
        textY = LineStartY + VerticalLineH + Fix375(5);
        textW = xTitleStrSize.width;
        textH = xTitleStrSize.height;
        
        CGRect xTitleStrRect = CGRectMake(textX ,textY , textW,textH);
        
        [xTitleStr drawInRect:xTitleStrRect withAttributes:attDic];
    }
    //单位
    NSString *danwei;
    if (self.timeType == USkinTimeTypeDay) {
        danwei = @"(h)";
    } else {
        danwei = @"(d)";
    }
    
    NSDictionary *danweiAttDic = @{NSFontAttributeName : [UIFont systemFontOfSize:Fix375(9)],
                                   NSForegroundColorAttributeName:Col_0x999999};
    CGSize danweiStrSize = [danwei sizeWithAttributes:danweiAttDic];
    CGFloat textSpace = HorizontalLineW / (self.xTitlesArr.count - 1);
    
    textX = LineStartX + (self.xTitlesArr.count - 1) * textSpace - danweiStrSize.width / 2 + Fix375(17);
    textY = LineStartY + VerticalLineH + Fix375(5);
    textW = danweiStrSize.width;
    textH = danweiStrSize.height;
    
    CGRect danweiRect = CGRectMake(textX, textY,textW, textH);
    [danwei drawInRect:danweiRect withAttributes:danweiAttDic];
}
#pragma mark - 画横线
- (void)drawHorizontalLine {
    //画横线
    NSInteger spaceCount = self.yTitlesArr.count - 1;
    CGFloat space = VerticalLineH / spaceCount;
    
    CGFloat startX;
    CGFloat startY;
    CGFloat endX;
    CGFloat endY;
    CGFloat lineW;
    UIColor *lineColor;
    
    CGFloat textX;
    CGFloat textY;
    CGFloat textW;
    CGFloat textH;
    
    for (NSInteger i = 1; i <= self.yTitlesArr.count; i ++) {
        if (i == 1) {
            lineW = Fix375(2);
            lineColor = UIColorFromRGB(0xfb8394);
            endX = LineStartX + HorizontalLineW + Fix375(11);
            startX = LineStartX - lineW / 2;
        } else {
            lineW = Fix375(1);
            lineColor = UIColorFromRGB(0xf5f5f5);
            endX = LineStartX + HorizontalLineW;
            startX = LineStartX;
        }
        
        startY = LineStartY + VerticalLineH - (i - 1) * space + lineW / 2;
        endY = LineStartY + VerticalLineH - (i - 1) * space + lineW / 2;
        
        CGPoint startPoint = CGPointMake(startX, startY);
        CGPoint endPoint = CGPointMake(endX, endY);
        
        [self drawLineWithContext:context startPoint:startPoint endPoint:endPoint lineColor:lineColor lineWidth:lineW];
        // y轴文字
        
        
        NSString *yTitleStr = self.yTitlesArr[i - 1];
        NSDictionary *attDic = @{NSFontAttributeName : [UIFont systemFontOfSize:Fix375(9)],
                                 NSForegroundColorAttributeName:Col_0x999999};
        CGSize yTitleStrSize = [yTitleStr sizeWithAttributes:attDic];
        textX = TitleStartX;
        textY = LineStartY + VerticalLineH - (i - 1) * space - yTitleStrSize.height / 2;
        textW = yTitleStrSize.width;
        textH = yTitleStrSize.height;
        
        CGRect yTitleStrRect = CGRectMake(textX ,textY , textW,textH);
        
        [yTitleStr drawInRect:yTitleStrRect withAttributes:attDic];
    }
    
    NSString *danwei = @"(%)";
    NSDictionary *danweiAttDic = @{NSFontAttributeName : [UIFont systemFontOfSize:Fix375(9)],
                                   NSForegroundColorAttributeName:Col_0x999999};
    CGSize danweiStrSize = [danwei sizeWithAttributes:danweiAttDic];
    
    textX = TitleStartX;
    textY = 0;
    textW = danweiStrSize.width;
    textH = danweiStrSize.height;
    
    CGRect danweiRect = CGRectMake(textX, textY,textW, textH);
    [danwei drawInRect:danweiRect withAttributes:danweiAttDic];
    
}
#pragma mark - 画箭头
- (void)drawXArrowWithContext:(CGContextRef)context{
    UIBezierPath *xArrowPath = [self xArrrowPath];
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetFillColorWithColor(context, UIColorFromRGB(0xfb8394).CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextAddPath(context, xArrowPath.CGPath);
    CGContextDrawPath(context, kCGPathFill);
}
- (void)drawYArrowWithContext:(CGContextRef)context {
    UIBezierPath *xArrowPath = [self yArrrowPath];
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetFillColorWithColor(context, UIColorFromRGB(0xfb8394).CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextAddPath(context, xArrowPath.CGPath);
    CGContextDrawPath(context, kCGPathFill);
}
- (UIBezierPath *)xArrrowPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint topPoint = CGPointMake(LineStartX + HorizontalLineW + Fix375(11) - Fix375(3), LineStartY + VerticalLineH - Fix375(4) + Fix375(1));
    CGPoint centerPoint = CGPointMake(LineStartX + HorizontalLineW + Fix375(11), LineStartY + VerticalLineH + Fix375(1));
    CGPoint bottomPoint = CGPointMake(LineStartX + HorizontalLineW + Fix375(11) - Fix375(3), LineStartY + VerticalLineH + Fix375(4) + Fix375(1));
    CGPoint rightPoint = CGPointMake(LineStartX + HorizontalLineW + Fix375(11) + Fix375(10), LineStartY + VerticalLineH + Fix375(1));
    
    [path moveToPoint:topPoint];
    [path addLineToPoint:centerPoint];
    [path addLineToPoint:bottomPoint];
    [path addLineToPoint:rightPoint];
    [path addLineToPoint:topPoint];
    
    return path;
}
- (UIBezierPath *)yArrrowPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint topPoint = CGPointMake(LineStartX - Fix375(1), 0);
    CGPoint leftPoint = CGPointMake(LineStartX - Fix375(1)  - Fix375(4), Fix375(10));
    CGPoint centerPoint = CGPointMake(LineStartX - Fix375(1) , Fix375(10) - Fix375(3));
    CGPoint rightPoint = CGPointMake(LineStartX - Fix375(1) + Fix375(4),Fix375(10));
    
    [path moveToPoint:topPoint];
    [path addLineToPoint:leftPoint];
    [path addLineToPoint:centerPoint];
    [path addLineToPoint:rightPoint];
    [path addLineToPoint:topPoint];
    
    return path;
}
#pragma mark - 画线统一封装
- (void)drawLineWithContext:(CGContextRef)context startPoint:(CGPoint)startPoint
                   endPoint:(CGPoint)endPoint
                  lineColor:(UIColor *)lineColor
                  lineWidth:(CGFloat)lineWidth {
    
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    //    dispatch_async(, <#^(void)block#>)
    UIBezierPath *linePath = [self linePathWithStartPoint:startPoint endPoint:endPoint];
    
    CGContextAddPath(context, linePath.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
}
- (UIBezierPath *)linePathWithStartPoint:(CGPoint)startPoint
                                endPoint:(CGPoint)endPoint{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    return path;
}
#pragma mark - getter
-(NSArray *)defaultYtitlesArr {
    if (_defaultYtitlesArr == nil) {
        _defaultYtitlesArr = @[@"0",@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100"];
    }
    return _defaultYtitlesArr;
}
-(NSArray *)defaultYvaluesArr {
    if (_defaultYvaluesArr == nil) {
        if (self.timeType == USkinTimeTypeDay) {
            _defaultYvaluesArr = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",
                                   @"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
        } else if (self.timeType == USkinTimeTypeWeek) {
            _defaultYvaluesArr = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
        } else {
            _defaultYvaluesArr = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",
                                   @"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",
                                   @"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
        }
    }
    return _defaultYvaluesArr;
}
@end

