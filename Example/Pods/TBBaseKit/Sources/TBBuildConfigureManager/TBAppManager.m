//
//  TBAppManager.m
//  Stock
//
//  Created by chenxin on 2021/11/19.
//  Copyright © 2021 com.tigerbrokers. All rights reserved.
//

#import "TBAppManager.h"
#import <TBBaseKit/TBBaseUtility.h>

// 测试包切换App时缓存的App类型
#define kTBDebugAppTypeKey @"TBDebugAppType"

@implementation TBAppManager

static TBAppType _appType;
+ (TBAppType)appType {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
        if ([bundleId isEqualToString:BUNDLEID_TIGERTRADELITE_APPSTORE]
            || [bundleId isEqualToString:BUNDLEID_TIGERTRADELITE_INHOUSE]) {
            _appType = TBAppTypeTigerTradeLite;
        }
        else if ([bundleId isEqualToString:BUNDLEID_TBMS_APPSTORE]) {
            _appType = TBAppTypeTigerTradeMS;
        }
        else if ([bundleId isEqualToString:BUNDLEID_TRADEUP_APPSTORE]
            || [bundleId isEqualToString:BUNDLEID_TRADEUP_INHOUSE]) {
            _appType = TBAppTypeTradeUP;
        }
        else {
            _appType = TBAppTypeTigerTrade;
        }
        if (HAS_TEST_ENV) {
            NSNumber *debugAppType = [[NSUserDefaults standardUserDefaults] objectForKey:kTBDebugAppTypeKey];
            if (debugAppType) {
                _appType = [debugAppType integerValue];
            }
        }
    });
    return _appType;
}

+ (void)setDebugAppType:(TBAppType)appType {
    _appType = appType;
    [[NSUserDefaults standardUserDefaults] setObject:@(appType) forKey:kTBDebugAppTypeKey];
}

+ (BOOL)isTigerTrade {
    return [self appType] == TBAppTypeTigerTrade;
}

+ (BOOL)isTigerTradeLite {
    return [self appType] == TBAppTypeTigerTradeLite;
}

+ (BOOL)isTigerTradeMS {
    return [self appType] == TBAppTypeTigerTradeMS;
}

+ (BOOL)isTradeUP {
    return [self appType] == TBAppTypeTradeUP;
}

+ (BOOL)isTigerTradeHD {
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    return [bundleId isEqualToString:BUNDLEID_TIGERTRADEHD_APPSTORE];
}

+ (NSString *)appName {
    if ([self isTigerTradeLite]) {
        return @"TigerTradeLite";
    }
    else if ([self isTradeUP]) {
        return @"TradeUP";
    }
    else if ([self isTigerTradeHD]) {
        return @"TigerTradeHD";
    }
    else if ([self isTigerTradeMS]) {
        return @"TigerTrade";
    }
    else {
        return @"TigerTrade";
    }
}

+ (NSString *)appDisplayName {
    if ([self isTigerTradeLite]) {
        return @"Tiger Trade";
    }
    else if ([self isTradeUP]) {
        return @"TradeUP";
    }
    else if ([self isTigerTradeHD]) {
        return @"Tiger Trade HD";
    }
    else if ([self isTigerTradeMS]) {
        return @"Tiger Trade";
    }
    else {
        return @"Tiger Trade";
    }
}

+ (NSString *)appId {
    if ([self isTigerTradeLite]) {
        return @"1485993365";
    }
    else if ([self isTradeUP]) {
        return @"1492602577";
    }
    else if ([self isTigerTradeHD]) {
        return @"1546956538";
    }
    else if ([self isTigerTradeMS]) {
        return @"1158759153";
    }
    else {
        return @"1023600494";
    }
}

+ (BOOL)isMainProjectBuild {
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    BOOL isMain =
    [bundleId isEqualToString:BUNDLEID_TIGERTRADE_INHOUSE] ||
    [bundleId isEqualToString:BUNDLEID_TIGERTRADE_APPSTORE] ||
    [bundleId isEqualToString:BUNDLEID_TIGERTRADELITE_INHOUSE] ||
    [bundleId isEqualToString:BUNDLEID_TIGERTRADELITE_APPSTORE] ||
    [bundleId isEqualToString:BUNDLEID_TRADEUP_INHOUSE] ||
    [bundleId isEqualToString:BUNDLEID_TRADEUP_APPSTORE] ||
    [bundleId isEqualToString:BUNDLEID_TBMS_APPSTORE] ||
    [bundleId isEqualToString:BUNDLEID_TIGERTRADEHD_APPSTORE];
    return isMain;
}


+ (void)onlyTTAndTUPBundleAssert:(NSString *)assertMessage {
   if (TextValid(assertMessage)) {
       if ([TBAppManager isTigerTradeLite] ||
           [TBAppManager isTigerTrade] ||
           [TBAppManager isTradeUP])
       {
           NSAssert(NO, assertMessage);
       }
       else {
           NSLog(@"❎❎❎❎ Assert:%@ ❎❎❎❎", assertMessage);
       }
   }
}

@end
