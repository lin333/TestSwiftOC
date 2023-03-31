//
//  NSArray+TBDataSafeTransform.m
//  StockGlobal
//
//  Created by linbingjie on 2019/11/27.
//  Copyright © 2019 com.tigerbrokers. All rights reserved.
//

#import "NSArray+TBDataSafeTransform.h"
#import "TBContainerConvertor.h"

@implementation NSArray (TBDataSafeTransform)

- (NSString *)tbStringAtIndex:(NSInteger)index {
    return [TBContainerConvertor tbStringWithArray:self atIndex:index];
}

- (NSNumber *)tbNumberAtIndex:(NSInteger)index {
    return [TBContainerConvertor tbNumberWithArray:self atIndex:index];
}

- (NSDictionary *)tbDictionaryAtIndex:(NSInteger)index {
    return [TBContainerConvertor tbDictWithArray:self atIndex:index];
}

- (NSArray *)tbArrayAtIndex:(NSInteger)index {
    return [TBContainerConvertor tbArrayWithArray:self atIndex:index];
}

@end
