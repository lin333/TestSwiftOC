//
//  TBBaseModel.m
//  Stock
//
//  Created by 胡金友 on 2018/7/6.
//  Copyright © 2018 com.tigerbrokers. All rights reserved.
//

#import "TBBaseModel.h"
#import <objc/runtime.h>

@implementation TBBaseModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        Class cls = [self class];
        while (cls && cls != [NSObject class]) {
            unsigned int memberCount = 0;
            Ivar *ivar_list = class_copyIvarList(cls, &memberCount);
            for (int i = 0; i<memberCount; i++) {
                Ivar ivar = ivar_list[i];
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
                if ([aDecoder containsValueForKey:key]) {
                    if ([self respondsToSelector:@selector(ignoredPropertyNames)]) {
                        if ([[self ignoredPropertyNames] containsObject:key]) continue;
                    }
                    id value = [aDecoder decodeObjectForKey:key];
                    [self setValue:value forKeyPath:key];
                } else {
                    if ([self respondsToSelector:@selector(defaultValueForUnarchiveUnContainsProperty:ofClass:)]) {
                        id defaultValue = [self defaultValueForUnarchiveUnContainsProperty:key ofClass:cls];
                        if (defaultValue) {
                            [self setValue:defaultValue forKey:key];
                        }
                    }
                }
            }
            free(ivar_list);
            cls = [cls superclass];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    Class cls = self.class;
    while (cls && cls != [NSObject class]) {
        unsigned int memberCount = 0;
        Ivar *ivar_list = class_copyIvarList(cls, &memberCount);
        for (int i = 0; i<memberCount; i++) {
            Ivar ivar = ivar_list[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            if ([self respondsToSelector:@selector(ignoredPropertyNames)]) {
                if ([[self ignoredPropertyNames] containsObject:key]) continue;
            }
            id value = [self valueForKeyPath:key];
            [encoder encodeObject:value forKey:key];
        }
        free(ivar_list);
        cls = [cls superclass];
    }
}

- (NSArray *)ignoredPropertyNames {
    return nil;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"description" : @"desc"};
}

@end
