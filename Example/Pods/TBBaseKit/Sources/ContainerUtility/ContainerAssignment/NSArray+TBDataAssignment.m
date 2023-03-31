//
//  NSArray+TBDataAssignment.m
//  TBBaseKit
//
//  Created by linbingjie on 2021/1/28.
//

#import "NSArray+TBDataAssignment.h"

@implementation NSArray (TBDataAssignment)

- (id)tb_safeObjectAtIndex:(NSUInteger)index {
    if (self.count == 0 || index > self.count - 1 || index < 0) {
        return nil;
    }
    return [self objectAtIndex:index];
}

- (NSArray *)tb_safeSubarrayWithRange:(NSRange)range {
    if (range.location >= self.count) {
        return nil;
    }
    if (range.location + range.length >= self.count) {
        return [self subarrayWithRange:NSMakeRange(range.location, self.count - range.location)];
    }
    return [self subarrayWithRange:range];
}

- (NSUInteger)tb_safeIndexOfObject:(id)object {
    if (!object || ![self containsObject:object]) {
        return 0;
    }
    return [self indexOfObject:object];
}

@end

@implementation NSMutableArray (TBDataAssignment)
- (void)tb_safeAddObject:(id)anObject
{
    if (anObject) {
        [self addObject:anObject];
    } else {
        
    }
}

- (void)tb_safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (self.count == 0 || index > self.count - 1) {
        return;
    }
    [self removeObjectAtIndex:index];
}

- (void)tb_safeRemoveObject:(id)anObject
{
    if (!anObject) {
        return;
    }
    [self removeObject:anObject];
}

- (void)tb_safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject == nil) {
        return;
    }
    if (self.count == 0 || index > self.count - 1) {
        [self addObject:anObject];
        return;
    }
    [self insertObject:anObject atIndex:index];
}

- (void)tb_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (anObject == nil) {
        return;
    }
    if (self.count == 0 || index > self.count - 1) {
        return;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
}

- (void)tb_safeAddObjectsFromArray:(NSArray *)array
{
    if (!array) {
        return;
    }
    [self addObjectsFromArray:array];
}

- (void)tb_safeRemoveObjectsInArray:(NSArray *)array
{
    if (!array) {
        return;
    }
    [self removeObjectsInArray:array];
}
@end
