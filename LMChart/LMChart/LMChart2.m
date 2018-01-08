//
//  LMChart2.m
//  LMChart
//
//  Created by liuming on 2018/1/8.
//  Copyright © 2018年 U9. All rights reserved.
//

#import "LMChart2.h"

@interface LMChart2 () {
    CGContextRef context;
}
@property (nonatomic, strong) NSArray *xTitlesArr;
@property (nonatomic, strong) NSArray *yTitlesArr;
@property (nonatomic, strong) NSArray *yValuesArr;
@property (nonatomic, assign) USkinTimeType timeType;
@property (nonatomic, strong) NSArray *defaultYtitlesArr;
@property (nonatomic, strong) NSArray *defaultYvaluesArr;
@property (nonatomic, assign) NSInteger shuXianAccount;

@end

@implementation LMChart2
-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    context = UIGraphicsGetCurrentContext();
    [self drawVerticalLine];
    [self drawHorizontalLine];
    [self drawJuXingWithValusesArr:self.yValuesArr];
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
            _shuXianAccount = 25;
        } else if (timeType == USkinTimeTypeWeek) {
            _shuXianAccount = 8;
        } else {
            _shuXianAccount = [self numberOfDaysCurrentMonth] + 1;
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
//    //    CGPoint touchPoint = [pan locationInView:self];
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
    [self setNeedsDisplay];
}
#pragma mark - 画柱状图

- (void)drawJuXingWithValusesArr:(NSArray *)valuesArr {
    CGRect rect = CGRectZero;
    CGFloat x;
    CGFloat y;
    CGFloat w;
    CGFloat h;
    CGFloat lineW = Fix375(1);
    
    NSInteger spaceCount = self.shuXianAccount - 1;
    CGFloat space = HorizontalLineW / spaceCount;
    
    w = space / 2;
    
    for (NSInteger i = 1; i < self.shuXianAccount; i ++) {
        x = LineStartX + (i - 1) * space + (space / 2 - w / 2);
        h = VerticalLineH * [valuesArr[i - 1] floatValue] / 100 ;
        y =  LineStartY + VerticalLineH + lineW / 2 - h;
        rect = CGRectMake(x, y, w, h);
        UIBezierPath *juXingPath = [self juXingPathWithRect:rect];
        [self setGradientLayerWithPath:juXingPath rect:rect];
    }
}
- (void)setGradientLayerWithPath:(UIBezierPath *)path rect:(CGRect)rect {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 1.0f;
    shapeLayer.fillColor = UIColorFromRGB(0xf7ba00).CGColor;
    shapeLayer.strokeColor = UIColorFromRGB(0xf7ba00).CGColor;
    shapeLayer.path = path.CGPath;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)UIColorFromRGB(0xf7ba00).CGColor,(id)Col_0xffffff.CGColor, nil]];
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.borderWidth  = 0.1;
    [gradientLayer setMask:shapeLayer];
    
    [self.layer addSublayer:gradientLayer];
    
}
- (UIBezierPath *)juXingPathWithRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    return path;
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
        
        lineW = Fix375(1);
        lineColor = UIColorFromRGB(0xf5f5f5);
        startY = LineStartY;
        endY = LineStartY + VerticalLineH + lineW / 2;
        
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
            textColor = UIColorFromRGB(0xf7ba00);
        } else {
            textColor = Col_0x999999;
        }
        
        NSString *xTitleStr = self.xTitlesArr[i - 1];
        NSDictionary *attDic = @{NSFontAttributeName : [UIFont systemFontOfSize:Fix375(9)],
                                 NSForegroundColorAttributeName:textColor};
        CGSize xTitleStrSize = [xTitleStr sizeWithAttributes:attDic];
        
        textW = xTitleStrSize.width;
        textH = xTitleStrSize.height;
        textY = LineStartY + VerticalLineH + Fix375(5);
        
        CGFloat textSpace;
        if (self.timeType == USkinTimeTypeMonth) {
            textSpace =  HorizontalLineW / (self.xTitlesArr.count - 1);
            textX = LineStartX + (i - 1) * textSpace - textW * 0.5;
        } else {
            textSpace =  HorizontalLineW / (self.xTitlesArr.count);
            textX = LineStartX + (i - 1) * textSpace  + textSpace * 0.5 - textW * 0.5;
        }
        
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
    CGFloat textSpace =   HorizontalLineW /(self.xTitlesArr.count - 1);
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
        
        lineW = Fix375(1);
        lineColor = UIColorFromRGB(0xf5f5f5);
        startX = LineStartX - lineW / 2;
        endX = LineStartX + HorizontalLineW;
        
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
    
    NSString *danwei = @"(岁)";
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

#pragma mark - 画线统一封装
- (void)drawLineWithContext:(CGContextRef)context startPoint:(CGPoint)startPoint
                   endPoint:(CGPoint)endPoint
                  lineColor:(UIColor *)lineColor
                  lineWidth:(CGFloat)lineWidth {
    
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    
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
