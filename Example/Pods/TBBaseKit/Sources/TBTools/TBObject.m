//
//  TBObject.m
//  Stock
//
//  Created by liwt on 14/12/18.
//  Copyright (c) 2014年 com.tigerbrokers. All rights reserved.
//

#import "TBObject.h"

@interface TBObject ()
{
    __strong NSDictionary *_dictionary;
}

@end

@implementation TBObject

- (id)initWithDictionary:(NSDictionary *)inDic
{
    if (self = [super init]) {
        [self updateWithDictionary:inDic];
    }
    return  self;
}

- (NSDictionary *)dictionary
{
    return _dictionary;
}

+ (NSMutableArray *)arrayWithDictionaryArray:(NSArray *)inArray
{
    if (! [inArray isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:inArray.count];
    if ([inArray isKindOfClass:[NSArray class]]) {
        for (int i=0; i<inArray.count; i++) {
            [results addObject:[[[self class] alloc] initWithDictionary:inArray[i]]];
        }
    }
    return results;

}

- (void)updateWithDictionary:(NSDictionary *)inDic
{
    if (! [inDic isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    
    if ([self autoSetValues]) {
        
        if ([inDic isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:inDic];
        }
        
    }else{
        
        NSArray *keys = [self keys];
        if (keys.count) {
            for (int i=0; i<keys.count; i++) {
                NSString *key = keys[i];
                [self setValue:[inDic objectForKey:key] forKey:key];
            }
        }
    }
    //
    _dictionary = inDic;

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // kill NSUndefinedKeyException

}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

- (void)setNilValueForKey:(NSString *)key
{
    
}

- (BOOL)autoSetValues
{
    return NO;
}

- (NSMutableDictionary *)dictionaryValue
{
    NSArray* keys = [self keys];
    if (keys.count) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:keys.count];
        for (NSString *key in keys) {
            id value = [self valueForKey:key];
            if (value) {
                [dic setObject:value forKey:key];
            }
        }
        return dic;
    }else{
        return nil;
    }
}

+ (NSMutableArray *)dictionaryArrayWithObjectArray:(NSArray *)inArray
{
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:inArray.count];
    for (TBObject *obj in inArray) {
        NSDictionary *dic = [obj dictionaryValue];
        if (dic) {
            [results addObject:dic];
        }
    }
    return results;
}



@end
