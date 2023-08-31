//
//  TBLanguageManager.m
//  Stock
//
//  Created by ChenXin on 16/11/29.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

#import <TBBaseKit/TBServiceManager.h>
#import <TBServiceProtocolKit/TBSwiftComponentService.h>

#import "TBLanguageManager.h"
#import "TBPhoneUtility.h"
#import "TBBuildConfigureManager.h"
#import "TBAppManager.h"
#import "TBMissLanguageManager.h"

#define UserDefaultsAppCurrentLanguageTypeKey @"appCurrentLanguageType"
NSString *const hasLanguageTypeEnumValueRevertedKey = @"hasLanguageTypeEnumValueReverted";

NSString *const NOTIFICATION_KEY_LANGUAGE_DID_CHANGE = @"appLanguageDidChange";

@interface TBLanguageManager ()

@end

@implementation TBLanguageManager

/*
 TradeUP逻辑与TigerTrade不一致，需要特殊处理
 */

+ (NSUInteger)languageSelectedIndex {
    return [TBService(TBSwiftComponentService) swiftService_languageSelectedIndex];
//    return [TBSwiftLanguageManager sharedInstance].currentSelectedIndex;
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSUInteger selectedIndex = [ud integerForKey:UserDefaultsAppCurrentLanguageTypeKey];
//    if (selectedIndex >= [self allLanguagesTypeCount]) {
//        selectedIndex = 0;
//    }
//    return selectedIndex;
}

//+ (TBLanguageType)systemLanguageType {
//    TBLanguageType languageType = TBLanguageTypeDefault;
//
//    NSString *systemLan = [TBPhoneUtility iOSSystemLanguage];
//    if ([systemLan hasPrefix:@"zh-Hans"]) {
//        languageType = TBLanguageTypeZhHans;
//    }
//    else if (!TBIsTradeUP && [systemLan hasPrefix:@"zh-Hant"]) { // TradeUP没有繁体
//        languageType = TBLanguageTypeZhHant;
//    }
//    else {
//        languageType = TBLanguageTypeEnglish;
//    }
//    return languageType;
//}

+ (void)setLanguageSelectedIndex:(NSUInteger)selectedIndex {
    [TBService(TBSwiftComponentService) swiftService_setLanguageSelectedIndex:selectedIndex];
//    [[TBSwiftLanguageManager sharedInstance] setSelected:selectedIndex];
//    if (selectedIndex >= [self allLanguagesTypeCount]) {
//        return;
//    }
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud setInteger:selectedIndex forKey:UserDefaultsAppCurrentLanguageTypeKey];
//    [ud synchronize];
//    [self currentLocalizableFolderName];
    
}

+ (NSInteger)allLanguagesTypeCount {
    return [self allLanguages].count;
}

+ (NSArray *)allLanguages {
    return [TBService(TBSwiftComponentService) swiftService_allLanguages];
//    return [TBSwiftLanguageManager sharedInstance].languagesDes;
//    if (TBIsTradeUP) {
//        if ([self currentAppLanguageType] == TBLanguageTypeEnglish) {
//            return [self tradeUPEnglishLanguages];
//        }
//        else {
//            return [self tradeUPChineseLanguages];
//        }
//    }
//    return [self tigerTradeLanguages];
}

//+ (NSArray *)tradeUPEnglishLanguages {
//    return @[@"Use device language", @"English", @"简体中文"];
//}
//
//+ (NSArray *)tradeUPChineseLanguages {
//    return @[@"使用系统语言", @"English", @"简体中文"];
//}
//
//+ (NSArray *)tigerTradeLanguages {
//    return @[@"自动（Auto）", @"简体中文", @"繁體中文", @"English"];
//}

static NSString *currentFolderName = @"";
+ (NSString *)currentLocalizableFolderName {
    return [TBService(TBSwiftComponentService) swiftService_currentLocalizableFolderName];
//    return [TBSwiftLanguageManager sharedInstance].folderName;
//    NSString *folderName = @"en";
//    TBLanguageType currentLanguageType = [self currentAppLanguageType];
//    switch (currentLanguageType) {
//        case TBLanguageTypeZhHans:
//            folderName = @"zh-Hans";
//            break;
//        case TBLanguageTypeZhHant:
//            folderName = @"zh-Hant";
//            break;
//        case TBLanguageTypeEnglish: {
//            NSString *sysLan = [TBPhoneUtility iOSSystemLanguage];
//            folderName = @"en";
//            NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@.lproj", sysLan];
//            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//                folderName = sysLan;
//            }
//        }
//            break;
//        default:
//            break;
//    }
//    currentFolderName = [folderName stringByAppendingString:@".lproj"];
//    return currentFolderName;
}

// 用户选择跟随设备语言时的语言类型
+ (TBLanguageType)defaultLanguageType {
    static TBLanguageType languageType = TBLanguageTypeDefault;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 系统语言应用运行期间不会变，只取一次
        NSString *systemLan = [TBPhoneUtility iOSSystemLanguage];
        if ([systemLan hasPrefix:@"zh-Hans"]) {
            languageType = TBLanguageTypeZhHans;
        }
        else if (!TBIsTradeUP && [systemLan hasPrefix:@"zh-Hant"]) { // TradeUP没有繁体
            languageType = TBLanguageTypeZhHant;
        }
        else if (!TBIsTradeUP && [systemLan hasPrefix:@"vi"]) {// 同上，TradeUP 不支持下面五种语言
            languageType = TBLanguageTypeVI_VN;
        }
        else if (!TBIsTradeUP && [systemLan hasPrefix:@"th"]) {
            languageType = TBLanguageTypeTH_TH;
        }
        else if (!TBIsTradeUP && [systemLan hasPrefix:@"id"]) {
            languageType = TBLanguageTypeID_ID;
        }
        else if (!TBIsTradeUP && [systemLan hasPrefix:@"es"]) {
            languageType = TBLanguageTypeES_ES;
        }
        else if (!TBIsTradeUP && [systemLan hasPrefix:@"pt"]) {
            languageType = TBLanguageTypePT_PT;
        }
        else {
            languageType = TBLanguageTypeEnglish;
        }
    });
    return languageType;
}

+ (TBLanguageType)currentAppLanguageType
{
    NSUInteger currentType = [TBService(TBSwiftComponentService) swiftService_languageCurrentType];
    
    if (currentType == 0) {
        return [self defaultLanguageType];
    }
    else if (TBIsTradeUP) {
        // 英文对应3，中文对应1
        if (currentType == 1) {
            return TBLanguageTypeZhHans;
        }
        else {
            return TBLanguageTypeEnglish;
        }
    }
    else {
        return currentType;
    }
}

//+ (void)setLanguageSelectedIndexWithLanguage:(NSString *)language {
//    /*tigertrade显示语言设置页显示顺序为自动 简体中文 繁体中文 英文
//     *tradeup显示语言设置页显示顺序为自动 英文 简体中文
//     */
//    NSDictionary *tigerTradeTypeIndexDic = @{@"sys" : @(0), @"zh_CN" : @(1), @"zh-Hant" : @(2), @"en_US" : @(3)};
//    NSDictionary *tradeUPTypeIndexDic = @{ @"sys" : @(0), @"en_US" : @(1), @"zh_CN" : @(2)};
//    NSInteger selectedIndex = TBLanguageTypeDefault;
//    if (TBIsTradeUP) {
//        selectedIndex = [tradeUPTypeIndexDic[language] integerValue];
//    }
//    else {
//        selectedIndex = [tigerTradeTypeIndexDic[language] integerValue];
//    }
//    return [[self class] setLanguageSelectedIndex:selectedIndex];
//}

//+ (NSString *)currentAppLanguage {
//    TBLanguageType languageType = TBLanguageTypeDefault;
//
//    NSUInteger selectedIndex = [self languageSelectedIndex];
//    if (selectedIndex == 0) {
//        languageType = TBLanguageTypeDefault;
//    }
//    else if (TBIsTradeUP) {
//        // TradeUP英文对应1，中文对应2
//        if (selectedIndex == 1) {
//            languageType = TBLanguageTypeEnglish;
//        }
//        else {
//            languageType = TBLanguageTypeZhHans;
//        }
//    }
//    else {
//        languageType = selectedIndex;
//    }
//    return [self languageWithLanguageType:languageType];
//}

//+ (NSString *)languageWithLanguageType:(TBLanguageType)languageType {
//    NSDictionary *languages = @{@(TBLanguageTypeDefault) : @"sys", @(TBLanguageTypeEnglish) : @"en_US", @(TBLanguageTypeZhHant) : @"zh-Hant", @(TBLanguageTypeZhHans) : @"zh_CN"};
//    return languages[@(languageType)];
//}

+ (NSString *)localizedString:(NSString *)key withComment:(NSString *)comment {
    return [self localizedString:key table:nil withComment:comment];
}

+ (NSString *)localizedString:(NSString *)key table:(NSString *)table withComment:(NSString *)comment {
    return [self localizedString:key bundle:nil table:table withComment:comment];
}

+ (NSString *)localizedString:(NSString *)key bundle:(NSBundle *)bundle table:(NSString *)table withComment:(NSString *)comment {
    return [TBService(TBSwiftComponentService) swiftService_languageLocalizedString:key bundle:bundle table:table withComment:comment];
//    return [TBSwiftLanguageManager localized:key comment:comment bundle:bundle table:table];
//    NSString *folderName = TextValid(currentFolderName) ? currentFolderName : [TBLanguageManager currentLocalizableFolderName];
//    NSString *string = nil;
//    if (folderName) {
//        if (!bundle) {
//            bundle = [NSBundle mainBundle];
//        }
//        string = [[NSBundle bundleWithPath:[bundle pathForResource:folderName ofType:nil]] localizedStringForKey:(key) value:@"" table:nil];
//    }
//    else {
//        string = NSLocalizedString(key, comment);
//    }
//    // 特殊情况，不需要替换老虎证券文案，在TBResourcesLocalizedString 和 TBLocalizedString 里加 comment，国内包应该不会出现
//    if ([self shouldReplaceTigerName:comment] && nil != string) {
//        if (TBIsTradeUP || TBAppIsLiteVersion
//            ) {
//            NSString *originalString = [self currentLocalizableTigerString];
//            NSString *targetString = [self targetLocalizableTigerString];
//            if (TextValid(originalString) && TextValid(targetString) && TextValid(string)) {
//                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:originalString options:NSRegularExpressionCaseInsensitive error:nil];
//                NSString *modstring = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0,[string length]) withTemplate: targetString];
//                return modstring;
//            }
//        }
//    }
//    return string;
}

//+ (BOOL)shouldReplaceTigerName:(NSString *)comment {
//    return !TextValid(comment);
//}
//
//+ (NSString *)targetLocalizableTigerString {
//    if (TBIsTradeUP) {
//        return @"TradeUP";
//    }
//    else {
//        NSDictionary *tigerLangDict = @{
//            @"zh_CN": @"老虎国际",
//            @"zh_TW":  @"老虎國際",
//            @"en_US": @"Tiger Trade",
//        };
//        return tigerLangDict[[self currentLangParameter]];
//    }
//}
//
//+ (NSString *)currentLocalizableTigerString {
//    if (TBIsTradeUP) {
//        return @"老虎环球|老虎证券|老虎国际|Tiger Brokers|Tiger Trade|老虎|tiger|Tiger|小虎";
//    }
//    else {
//        NSDictionary *tigerLangDict = @{
//            @"zh_CN": @"老虎证券|TradeUP",
//            @"zh_TW":  @"老虎證券|TradeUP",
//            @"en_US": @"Tiger Brokers|TradeUP",
//        };
//        return tigerLangDict[[self currentLangParameter]];
//    }
//}
//
//+ (BOOL)hasChinese:(NSString *)str {
//    for(int i=0; i< [str length];i++){
//        int a = [str characterAtIndex:i];
//        if( a > 0x4e00 && a < 0x9fff)
//        {
//            return YES;
//        }
//    }
//    return NO;
//}

/// 盘前盘后转换key，有些盘前盘后key为接口返回，比较分散，在这里进行转换。
/// @param key <#key description#>
//+ (NSString *)prePostKey:(NSString *)key {
//    NSDictionary *dict = @{@"盘前": @"mobile_ios_common_pre", @"盘后": @"mobile_ios_common_post_1"};
//    return dict[key] ?: key;
//}

+ (NSString *)v80ResourcesLocalizedString:(NSString *)key withComment:(NSString *)comment {
    return [TBService(TBSwiftComponentService) swiftService_languageLocalizedString:key withComment:comment];
//    return  [TBSwiftLanguageManager localized:key comment:comment];
//    NSString *tmpKey = [self prePostKey:key];
//    NSString *value = [TBLanguageManager localizedString:(tmpKey) withComment:(comment)];
//
//    if (HAS_TEST_ENV) {
//        if ((![tmpKey hasPrefix:@"mobile_ios_common"] && ![tmpKey hasPrefix:@"mobile_comm_"]) || [self hasChinese:tmpKey]) {
//            if (TextValid(tmpKey)) {
//                if ([TBMissLanguageManager addMissingLanguageKey:key]) {
//                    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"旧key未替换提示" message:[NSString stringWithFormat:@"%@ 为旧key或不符合规范，需要替换", key] preferredStyle:UIAlertControllerStyleAlert];
//                    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        NSArray *keys = [TBMissLanguageManager missingLanguageKeys];
//                        if (keys.count) {
//                            [UIPasteboard generalPasteboard].string = [keys componentsJoinedByString:@"\n"];
//                        }
//                    }]];
//
//                    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
//                    while (viewController.presentedViewController) {
//                        viewController = viewController.presentedViewController;
//                    }
//                    if ([viewController isKindOfClass:[UINavigationController class]]) {
//                        viewController = [(UINavigationController *)viewController topViewController];
//                    }
//                    [viewController presentViewController:alertCtrl animated:YES completion:nil];
//                }
//            }
//
//        }
//    }
//    return value;
//    if (HAS_TEST_ENV) {
//        //        return value?:[TBLanguageManager localizedString:(key) bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"TBResources" ofType:@"bundle"]] table:nil withComment:(comment)];
//    }
//    return [TBLanguageManager localizedString:(key) bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"TBResources" ofType:@"bundle"]] table:nil withComment:(comment)];
}


+ (NSString *)resourcesLocalizedString:(NSString *)key withComment:(NSString *)comment
{   
    return [TBService(TBSwiftComponentService) swiftService_languageLocalizedString:key withComment:comment];
//    return  [TBSwiftLanguageManager localized:key comment:comment];
}

+ (BOOL)useTopToBottomLayout {
//    if ([TBSwiftLanguageManager isTraditionalChinese] ||
//        [TBSwiftLanguageManager isSimpleChinese]) {
    if ([TBService(TBSwiftComponentService) swiftService_languageIsTraditionalChinese] ||
        [TBService(TBSwiftComponentService) swiftService_languageIsSimpleChinese]) {
        return NO;
    }
    return YES;
//    TBLanguageType type = [self currentAppLanguageType];
//    if (type == TBLanguageTypeZhHans || type == TBLanguageTypeZhHant) {
//        return NO;
//    }
//    else {
//        return YES;
//    }
}

+ (BOOL)isChineseSimpleLanguage{
    return [TBService(TBSwiftComponentService) swiftService_languageIsSysSimpleChinese];
//    return [TBSwiftLanguageManager isSysSimpleChinese];
//    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
//    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
//    NSString *preferredLang = [languages objectAtIndex:0];
//    if ([preferredLang hasPrefix:@"zh-Hans"]) {
//        return YES;
//    }else{
//        return NO;
//    }
}

+ (NSString *)currentLangParameter {
    return [TBService(TBSwiftComponentService) swiftService_currentLangParameter];
//    return [TBSwiftLanguageManager langParam];
//    NSString *lang = nil;
//    TBLanguageType languageType = [TBLanguageManager currentAppLanguageType];
//    switch (languageType) {
//        case TBLanguageTypeZhHans:
//            lang = @"zh_CN";
//            break;
//        case TBLanguageTypeZhHant:
//            lang = @"zh_TW";
//            break;
//        case TBLanguageTypeEnglish:
//            lang = @"en_US";
//            break;
//        default:
//            lang = @"en_US";
//            break;
//    }
//    return lang;
}

@end
