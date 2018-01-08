//
//  ViewController.m
//  LMChart
//
//  Created by liuming on 2018/1/8.
//  Copyright © 2018年 U9. All rights reserved.
//

#import "ViewController.h"
#import "LMChartView1.h"
#import "LMChart2.h"
#import "LMChatView3.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"LMChartsView";
    
    
    NSArray *array = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    
    
    
    LMChartView1 *chart = [[LMChartView1 alloc] initWithXtitlesArr:array yTilesArr:nil timeType:USkinTimeTypeDay];
    chart.backgroundColor = Col_0xffffff;
    NSMutableArray *yValuesArr = @[@"0.1",@"0.11",@"0.2",@"0.23",@"0.54",@"0.5",@"0.46",@"0.37",@"0.68",@"0.9",@"0.51",@"0.11",@"0.12",@"0.13",@"0.14",@"0.15",@"0.16",@"0.17",@"0.18",@"0.19",@"0.32",@"0.21",@"0.12",@"0.02"].mutableCopy;
    chart.frame = CGRectMake(0, 100, self.view.bounds.size.width,  Fix375(212));
    [chart fillDataWithArr:yValuesArr];
    [self.view addSubview:chart];
    
    
    
    LMChart2 *chart2 = [[LMChart2 alloc] initWithXtitlesArr:array yTilesArr:nil timeType:USkinTimeTypeDay];
    chart2.backgroundColor = Col_0xffffff;
    NSMutableArray *yValuesArr2 = @[@"10",@"12",@"20",@"23",@"36",@"50",@"46",@"37",@"56",@"86",@"0.51",@"35",@"55",@"24",@"14",@"15",@"22",@"37",@"44",@"43",@"86",@"53",@"26",@"1"].mutableCopy;
    chart2.frame = CGRectMake(0, CGRectGetMaxY(chart.frame), self.view.bounds.size.width,  Fix375(212));
    [chart2 fillDataWithArr:yValuesArr2];
    [self.view addSubview:chart2];
    
    
    
    
    LMChatView3 *chart3 = [[LMChatView3 alloc] initWithXtitlesArr:array yTilesArr:nil timeType:USkinTimeTypeDay];
    chart3.backgroundColor = Col_0xffffff;
    NSMutableArray *yValuesArr3 = @[@"0.1",@"0.4",@"0.2",@"0.23",@"0.54",@"0.5",@"0.46",@"0.37",@"0.68",@"0.9",@"0.51",@"0.11",@"0.12",@"0.13",@"0.14",@"0.34",@"0.36",@"0.17",@"0.31",@"0.19",@"0",@"0.21",@"0",@"0"].mutableCopy;
    chart3.frame = CGRectMake(0, CGRectGetMaxY(chart2.frame), self.view.bounds.size.width,  Fix375(212));
    [chart3 fillDataWithArr:yValuesArr3];
    [self.view addSubview:chart3];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
