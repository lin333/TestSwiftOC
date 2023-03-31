//
//  NSDictionary+TBDataSafeTransform.m
//  StockGlobal
//
//  Created by linbingjie on 2019/11/27.
//  Copyright © 2019 com.tigerbrokers. All rights reserved.
//

#import "NSDictionary+TBDataSafeTransform.h"
#import "TBContainerConvertor.h"

@implementation NSDictionary (TBDataSafeTransform)

- (NSString *)tbStringForKey:(id)key {
    return [TBContainerConvertor tbStringWithDictionary:self forKey:key];
}

- (NSNumber *)tbNumberForKey:(id)key {
    return [TBContainerConvertor tbNumberWithDictionary:self forKey:key];
}

- (NSDictionary *)tbDictionaryForKey:(id)key {
    return [TBContainerConvertor tbDictWithDictionary:self forkey:key];
}

- (NSArray *)tbArrayForKey:(id)key {
    return  [TBContainerConvertor tbArrayWithDictionary:self forkey:key];
}

@end
