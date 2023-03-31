//
//  NSDictionary+TBDataAssignment_m.m
//  TBBaseKit
//
//  Created by linbingjie on 2021/1/28.
//

#import "NSDictionary+TBDataAssignment.h"

@implementation NSDictionary (TBDataAssignment)

- (id)tb_safeValueForKey:(NSString *)key {
    if (!key || !key.length) {
        return nil;
    }
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return object;
}
@end


@implementation NSMutableDictionary(TBDataAssignment)

- (void)tb_safeSetObject:(id)object forKey:(id)key
{
    if (!object) {
        return;
    }
    if (!key) {
        return;
    }
    [self setObject:object forKey:key];
}
@end
