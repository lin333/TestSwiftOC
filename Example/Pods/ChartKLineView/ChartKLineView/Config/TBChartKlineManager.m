//
//  TBChartKlineManager.m
//  ChartKLineView
//
//  Created by linbingjie on 2023/2/1.
//

#import "TBChartKlineManager.h"
#import <TBBaseKit/TBBaseKit.h>

@implementation TBChartKlineManager

+ (NSInteger)fetchIndicatorAtIndex:(NSInteger)index key:(NSString *)key {
    return [TBService(TBShellProjectService) tb_indicatorAtIndex:index key:key];
}

+ (NSArray *)fetchindicators:(NSString *)key {
    return [TBService(TBShellProjectService) tb_indicators:key];
}

@end
