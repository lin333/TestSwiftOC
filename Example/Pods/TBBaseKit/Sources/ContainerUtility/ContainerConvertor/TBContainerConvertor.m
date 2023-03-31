//
//  TBContainerConvertor.m
//  StockGlobal
//
//  Created by linbingjie on 2019/11/27.
//  Copyright © 2019 com.tigerbrokers. All rights reserved.
//

#import "TBContainerConvertor.h"
#include <execinfo.h>
#import "NSNumber+TBStringConvertor.h"

static NSInteger const kTBBackTraceNum = 10; // 获取若干个堆栈信息

/// 获取当前调用堆栈
static inline NSString *TBFetchCurrentBackTrace() {
    void *callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSString *message = [NSString string];
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0; i < kTBBackTraceNum; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
        message = [message stringByAppendingFormat:@"\n %@", [NSString stringWithCString:strs[i] encoding:NSUTF8StringEncoding]];
    }
    free(strs);
    return message;
}

/// 通过弹窗提示崩溃
/// 点击直接崩溃，强制开发直接去修改
/// @param message message
static inline void TBBackTrackAlert(NSString *message) {
    if (message.length <= 0) {
        return;
    }
    NSLog(@"【❌】发生容器数据类型错误 【❌】\n %@",message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"容器数据类型错误"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"点击崩溃，前往修改"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         exit(0);
                                                     }];
    [alertController addAction:OKAction];
    
    UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindow.rootViewController = [[UIViewController alloc] init];
    alertWindow.windowLevel = UIWindowLevelAlert + 1;
    [alertWindow makeKeyAndVisible];
    [alertWindow.rootViewController presentViewController:alertController
                                                 animated:YES
                                               completion:nil];
}

static inline id TBContainerConvertorCheckType(id INSTANCE, Class classType) {
    if (!INSTANCE) {
        return nil;
    }
    if(![INSTANCE isKindOfClass:classType]) {
        #if DEBUG
        TBBackTrackAlert(TBFetchCurrentBackTrace());
        #endif
        return nil;
    }
    return INSTANCE;
}

@implementation TBContainerConvertor

#pragma mark - Dictionary
+ (NSString *)tbStringWithDictionary:(NSDictionary *)dict forKey:(id)key {
    NSString *string = TBContainerConvertorCheckType(dict[key], NSString.class);
    if (string) return string;
    NSNumber *number = TBContainerConvertorCheckType(dict[key], NSNumber.class);
    if (number) return [NSString stringWithFormat:@"%@", number];
    return nil;
}

+ (NSString *)tbNonnullStringWithDictionary:(NSDictionary *)dict forKey:(id)key {
    NSString *string = [self tbStringWithDictionary:dict forKey:key];
    return string? string:@"";
}

+ (NSNumber *)tbNumberWithDictionary:(NSDictionary *)dict forKey:(id)key {
    NSNumber *number = TBContainerConvertorCheckType(dict[key], NSNumber.class);
    if (number) return number;
    NSString *string = TBContainerConvertorCheckType(dict[key], NSString.class);
    if (string) return [NSNumber numberWithString:string];
    return nil;
}

+ (NSDictionary *)tbDictWithDictionary:(NSDictionary *)dict forkey:(id)key {
    return TBContainerConvertorCheckType(dict[key], NSDictionary.class);
}

+ (NSArray *)tbArrayWithDictionary:(NSDictionary *)dict forkey:(id)key {
    return TBContainerConvertorCheckType(dict[key], NSArray.class);
}

#pragma mark - Array
+ (NSString *)tbStringWithArray:(NSArray *)array atIndex:(NSInteger)index {
    if (index >= [array count]) {
        return nil;
    }
    
    NSString *string = TBContainerConvertorCheckType(array[index], NSString.class);
    if (string) return string;
    NSNumber *number = TBContainerConvertorCheckType(array[index], NSNumber.class);
    if (number) return [NSString stringWithFormat:@"%@", number];
    return nil;
}

+ (NSNumber *)tbNumberWithArray:(NSArray *)array atIndex:(NSInteger)index {
    if (index >= [array count]) {
        return nil;
    }
    
    NSNumber *number = TBContainerConvertorCheckType(array[index], NSNumber.class);
    if (number) return number;
    NSString *string = TBContainerConvertorCheckType(array[index], NSString.class);
    if (string) return [NSNumber numberWithString:string];
    return nil;
}

+ (NSDictionary *)tbDictWithArray:(NSArray *)array atIndex:(NSInteger)index {
    if (index >= [array count]) {
        return nil;
    }
    return TBContainerConvertorCheckType(array[index], NSDictionary.class);
}

+ (NSArray *)tbArrayWithArray:(NSArray *)array atIndex:(NSInteger)index {
    if (index >= [array count]) {
        return nil;
    }
    return TBContainerConvertorCheckType(array[index], NSArray.class);
}

#pragma mark - judge self type
+ (NSArray *)tbArrayWithObject:(id)array {
    return TBContainerConvertorCheckType(array, NSArray.class);
}

+ (NSDictionary *)tbDictWithObject:(id)dict {
    return TBContainerConvertorCheckType(dict, NSDictionary.class);
}

@end
