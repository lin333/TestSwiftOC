//
//  TBMissLanguageManager.m
//  TBBaseKit
//
//  Created by 骆鹏飞 on 2022/2/24.
//

#import "TBMissLanguageManager.h"

@interface TBMissLanguageManager ()

/// <#注释#>
//@property (nonatomic, copy, class, readonly) NSArray *ignoreKeys;

/// <#注释#>
//@property (nonatomic, strong, class, readonly) NSMutableDictionary *keysMap;

@end

@implementation TBMissLanguageManager

+ (BOOL)addMissingLanguageKey:(NSString *)key {
    if ([self.ignoreKeys containsObject:key]) {
        return NO;
    }
    if (nil == self.keysMap[key]) {
        [self.keysMap setValue:@1 forKey:key];
        return YES;
    }
    return NO;
}

+ (NSArray *)missingLanguageKeys {
    return self.keysMap.allKeys;
}

static NSMutableDictionary *_keysMap;
+ (NSMutableDictionary *)keysMap {
    if (!_keysMap) {
        _keysMap = [@{} mutableCopy];
    }
    return _keysMap;
}

+ (NSArray *)ignoreKeys {
    return @[
        /* 不用提示的key */
        @"mobile_ios_account_cancel",
        @"mobile_ios_account_quit",
        @"(> 20%)",
        @"(0 - 10%)",
        @"(10% - 30%)",
        @"(5% - 20%)",
        @"(0 - 5%)",
        @"%",
        @"Any",
        @"MAXAF",
        @"MINAF",
        @"WR1",
        @"WR2",
        @"mobile_ios_common_vol",
        @"成交量",
        @"Vol",
        @"MACD", @"KDJ", @"RSI",@"WR",@"ROC",@"ARBR", @"OBV", @"DMI",@"ATR",@"TRIX",@"BIAS", @"DMA", @"PCNT", @"DKX", @"CCI", @"MFI", @"EMV", @"UDL", @"VRSI", @"SKDJ" , @"XS", @"MTM", @"ADTM", @"CR", @"WVAD", @"BBIBOLL",
        @"MA", @"BOLL", @"EMA", @"BBI", @"ENE", @"PBX", @"MIKE", @"ALLIGAT", @"VMA", @"LMA", @"HMA", @"SAR",@"VOL",
    ];
}


@end
