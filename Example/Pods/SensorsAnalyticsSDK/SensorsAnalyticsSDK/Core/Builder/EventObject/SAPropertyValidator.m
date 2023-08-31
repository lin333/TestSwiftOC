//
// SAPropertyValidator.m
// SensorsAnalyticsSDK
//
// Created by yuqiang on 2021/4/12.
// Copyright © 2015-2022 Sensors Data Co., Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "SAPropertyValidator.h"
#import "SAConstants+Private.h"
#import "SADateFormatter.h"
#import "SensorsAnalyticsSDK+Private.h"
#import "SALog.h"
#import "NSObject+SAToString.h"

@implementation NSString (SAProperty)

- (void)sensorsdata_isValidPropertyKeyWithError:(NSError *__autoreleasing  _Nullable *)error {
    [SAValidator validKey:self error:error];
}

- (id)sensorsdata_propertyValueWithKey:(NSString *)key error:(NSError *__autoreleasing  _Nullable *)error {
    NSInteger maxLength = kSAPropertyValueMaxLength;
    if ([key isEqualToString:@"app_crashed_reason"]) {
        maxLength = maxLength * 2;
    }
    if (self.length >= maxLength) {
        SALogWarn(@"%@'s length is longer than %ld", self, maxLength);
        NSMutableString *tempString = [NSMutableString stringWithString:[self substringToIndex:maxLength - 1]];
        [tempString appendString:@"$"];
        return [tempString copy];
    }
    return self;
}

@end

@implementation NSNumber (SAProperty)

- (id)sensorsdata_propertyValueWithKey:(NSString *)key error:(NSError *__autoreleasing  _Nullable *)error {
    return [self isEqualToNumber:NSDecimalNumber.notANumber] || [self isEqualToNumber:@(INFINITY)] ? nil : self;
}

@end

@implementation NSDate (SAProperty)

- (id)sensorsdata_propertyValueWithKey:(NSString *)key error:(NSError *__autoreleasing  _Nullable *)error {
    return self;
}

@end

@implementation NSSet (SAProperty)

- (id)sensorsdata_propertyValueWithKey:(NSString *)key error:(NSError *__autoreleasing  _Nullable *)error {
    NSMutableSet *result = [NSMutableSet set];
    for (id element in self) {
        if (![element conformsToProtocol:@protocol(SAPropertyValueProtocol)]) {
            continue;
        }
        id sensorsValue = [(id <SAPropertyValueProtocol>)element sensorsdata_propertyValueWithKey:key error:error];
        sensorsValue = [sensorsValue sensorsdata_toString];
        if (sensorsValue) {
            [result addObject:sensorsValue];
        }
    }
    return [result copy];
}

@end

@implementation NSArray (SAProperty)

- (id)sensorsdata_propertyValueWithKey:(NSString *)key error:(NSError *__autoreleasing  _Nullable *)error {
    NSMutableArray *result = [NSMutableArray array];
    for (id element in self) {
        if (![element conformsToProtocol:@protocol(SAPropertyValueProtocol)]) {
            continue;
        }
        id sensorsValue = [(id <SAPropertyValueProtocol>)element sensorsdata_propertyValueWithKey:key error:error];
        sensorsValue = [sensorsValue sensorsdata_toString];
        if (sensorsValue) {
            [result addObject:sensorsValue];
        }
    }
    return [result copy];
}

@end

@implementation NSNull (SAProperty)

- (id)sensorsdata_propertyValueWithKey:(NSString *)key error:(NSError *__autoreleasing  _Nullable *)error {
    return nil;
}

@end

@implementation NSDictionary (SAProperty)

- (id)sensorsdata_validKey:(NSString *)key value:(id)value error:(NSError *__autoreleasing  _Nullable *)error {
    if (![key conformsToProtocol:@protocol(SAPropertyKeyProtocol)]) {
        *error = SAPropertyError(10004, @"Property Key: %@ must be NSString", key);
        return nil;
    }

    [(id <SAPropertyKeyProtocol>)key sensorsdata_isValidPropertyKeyWithError:error];
    if (*error && (*error).code != SAValidatorErrorOverflow) {
        return nil;
    }

    if (![value conformsToProtocol:@protocol(SAPropertyValueProtocol)]) {
        *error = SAPropertyError(10005, @"%@ property values must be NSString, NSNumber, NSSet, NSArray or NSDate. got: %@ %@", self, [value class], value);
        return nil;
    }

    // value 转换
    return [(id <SAPropertyValueProtocol>)value sensorsdata_propertyValueWithKey:key error:error];
}

@end

@implementation SAPropertyValidator

+ (NSMutableDictionary *)validProperties:(NSDictionary *)properties {
    return [self validProperties:properties validator:properties];
}

+ (NSMutableDictionary *)validProperties:(NSDictionary *)properties validator:(id<SAEventPropertyValidatorProtocol>)validator {
    if (![properties isKindOfClass:[NSDictionary class]] || ![validator conformsToProtocol:@protocol(SAEventPropertyValidatorProtocol)]) {
        return nil;
    }
    
    NSDictionary *newProperties = [NSDictionary dictionaryWithDictionary:properties];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (id key in newProperties) {
        NSError *error = nil;
        id value = [validator sensorsdata_validKey:key value:newProperties[key] error:&error];
        if (error) {
            SALogError(@"%@",error.localizedDescription);
        }
        if (value) {
            result[key] = value;
        }
    }
    return result;
}

@end

