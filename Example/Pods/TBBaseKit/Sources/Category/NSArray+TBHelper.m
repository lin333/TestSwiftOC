//
//  NSArray+FTFHelper.m
//  Future
//
//  Created by JyHu on 2017/2/24.
//  Copyright © 2017年 JyHu. All rights reserved.
//

#import "NSArray+TBHelper.h"

@implementation NSArray (TBHelper)

- (NSArray *)map:(id (^)(id))map
{
    return [self mapI:^id(id obj, NSUInteger ind) {
        return map(obj);
    }];
}

- (NSArray *)mapI:(id (^)(id, NSUInteger))map
{
    NSMutableArray *transferArr = [[NSMutableArray alloc] init];
    if (self) {        
        for (NSInteger i = 0; i < self.count; i ++) {
            id mr = map(self[i], i);
            if (mr) {
                [transferArr addObject:mr];
            }
        }
    }
    
    return transferArr;
}

- (NSArray *)flatMap:(id (^)(id))flatMap
{
    NSMutableArray *res = [NSMutableArray new];
    
    for (id obj in self)
    {
        if (obj)
        {
            id trans = flatMap(obj);
            
            if (trans)
            {
                if ([trans isKindOfClass:[NSArray class]])
                {
                    [res addObjectsFromArray:trans];
                }
                else
                {
                    [res addObject:trans];
                }
            }
        }
    }
    
    return res;
}

- (NSArray *)next:(void (^)(NSArray *))next
{
    next(self);
    return self;
}

+ (NSArray *)mapNumber:(NSUInteger)num map:(id (^)(NSUInteger))map
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < num; i ++) {
        [res addObject:map(i)];
    }
    return res;
}

- (id)checkExistsWithBlock:(BOOL (^)(id))block
{
    for (id obj in self) {
        if (block(obj)) {
            return obj;
        }
    }
    return nil;
}

- (id)reduce:(id (^)(id, id))reduce
{
    if (self.count == 0)
    {
        return nil;
    }
    
    id res = [self firstObject];
    
    if (self.count == 1)
    {
        return res;
    }
    
    for (NSInteger i = 1; i < self.count; i ++)
    {
        res = reduce(res, self[i]);
    }
    
    return res;
}

- (NSArray *)filter:(BOOL (^)(id, NSInteger))filter
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.count; i ++) {
        if (filter(self[i], i)) {
            [res addObject:self[i]];
        }
    }
    return res;
}

+ (NSArray *)randomArrayWithCount:(NSUInteger)count
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSInteger i = 0; i < count; i ++) {
        [arr addObject:@""];
    }
    return arr;
}

- (instancetype)removeObjectsFromIndex:(NSUInteger)index
{
    if (self && self.count > index) {
        return [self subarrayWithRange:NSMakeRange(0, index)];
    }
    return self;
}

- (instancetype)replaceObjectForIndex:(NSUInteger)index withObject:(id)object {
    if (self) {
        NSMutableArray *mutableArr = [self mutableCopy];
        if (self.count > index) {
            [mutableArr removeObjectAtIndex:index];
        }
        if (object) {
            [mutableArr insertObject:object atIndex:index];
        }
        return mutableArr;
    }
    return self;
}

- (instancetype)replaceObjectsFromIndex:(NSUInteger)index withObjects:(NSArray *)objects
{
    if (self) {
        NSMutableArray *mutableArr = [self mutableCopy];
        if (self.count > index) {
            [mutableArr removeObjectsInRange:NSMakeRange(index, self.count - index)];
        }
        if (objects) {
            [mutableArr addObjectsFromArray:objects];
        }
        return mutableArr;
    }
    
    return self;
}

@end
