//
//  NSTimer+TBTimer.m
//  Stock
//
//  Created by luopengfei on 2018/8/15.
//  Copyright © 2018年 com.tigerbrokers. All rights reserved.
//

#import "NSTimer+TBTimer.h"
#import <objc/runtime.h>

@implementation NSTimer (TBTimer)
const char *__TBTimerOpeningAssociatedKey = (void *)@"com.tigerbrokers.__TBTimerOpeningAssociatedKey";

- (void)setOpen:(BOOL)open
{
    objc_setAssociatedObject(self, __TBTimerOpeningAssociatedKey, @(open), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isOpen
{
    return [objc_getAssociatedObject(self, __TBTimerOpeningAssociatedKey) boolValue];
}

- (void)pause
{
    if (self.isValid) {
        [self setFireDate:[NSDate distantFuture]];
        self.open = NO;
    }
}

- (void)resume
{
    if (self.isValid) {
        [self setFireDate:[NSDate date]];
        self.open = YES;
    }
}

- (void)resumeWithDelay:(NSTimeInterval)delay {
    if (self.isValid) {
        self.open = YES;
        [self setFireDate:[[NSDate date] dateByAddingTimeInterval:delay]];
    }
}

+ (NSTimer *)tb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer * _Nonnull))block
{
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(tb_blockInvoke:) userInfo:[block copy] repeats:YES];
}

+ (NSTimer *)tb_scheduledWithFireDate:(NSDate *)date timeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer * _Nonnull))block {
    return [[NSTimer alloc] initWithFireDate:date interval:interval target:self selector:@selector(tb_blockInvoke:) userInfo:[block copy] repeats:YES];
}

+ (void)tb_blockInvoke:(NSTimer *)timer
{
    void (^block)(NSTimer *timer) =timer.userInfo;
    if (block && timer.isValid) {
        block(timer);
    }
}
@end
