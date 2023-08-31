//
//  TBLanguageManager.h
//  Stock
//
//  Created by ChenXin on 16/11/29.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TBLanguageType) {
    TBLanguageTypeDefault,  //自动
    TBLanguageTypeZhHans,   //简体中文
    TBLanguageTypeZhHant,   //繁体中文
    TBLanguageTypeEnglish,  //英文
    
    TBLanguageTypeVI_VN,       ///< 越南语
    TBLanguageTypeTH_TH,       ///< 泰语
    TBLanguageTypeID_ID,       ///< 印度尼西亚语
    TBLanguageTypeES_ES,       ///< 西班牙语
    TBLanguageTypePT_PT,       ///< 葡萄牙语
};

#define TBLocalizedString(key, comment) \
        [TBLanguageManager resourcesLocalizedString:(key) withComment:(comment)]
#define TBLocalizedStringFromTable(key, tbl, comment) \
        [TBLanguageManager localizedString:(key) table:(tbl) withComment:(comment)]
#define TBLocalizedStringFromTableInBundle(key, bundleOrNil, tbl, comment) \
        [TBLanguageManager localizedString:(key) bundle:(bundleOrNil) table:(tbl) withComment:(comment)]

// TBBaseKit bundle中的本地化字符串，其他组件可以参考以下写法自行定义
// 目前只有社区在用，DEPRECATED
#define TBBaseKitLocalizedString(key, comment) \
        [TBLanguageManager resourcesLocalizedString:key withComment:comment]

// 从TBResources读取localizedString，目前仅在组件内使用该方式获取多语言，暂时不用，等TBResources里没有问题时接入
#define TBResourcesLocalizedString(key, comment) \
        [TBLanguageManager resourcesLocalizedString:(key) withComment:(comment)]

// 是否使用上下布局
#define TBUseTopToBottomLayout [TBLanguageManager useTopToBottomLayout]

//设置里应用语言改变时的通知
extern NSString *const NOTIFICATION_KEY_LANGUAGE_DID_CHANGE;

@interface TBLanguageManager : NSObject

/*
 用户在语言设置页选中的选项索引
 注意languageSelectedIndex与currentAppLanguageType的值不一样，currentAppLanguageType不会返回0
 */
+ (NSUInteger)languageSelectedIndex;

/*
 获取手机设置里的语言
 */
//+ (TBLanguageType)systemLanguageType;

+ (void)setLanguageSelectedIndex:(NSUInteger)selectedIndex;

// 所有支持的语言名称
+ (NSArray *)allLanguages;

// 当前设置语言对应的本地化目录名
+ (NSString *)currentLocalizableFolderName;

/*
 获取当前app使用的语言，返回值不会是TBLanguageTypeDefault
 TradeUP使用时需注意返回值只能与枚举值比较，直接当成int使用可能会有问题
 */
+ (TBLanguageType)currentAppLanguageType DEPRECATED_MSG_ATTRIBUTE("use TBSwiftLanguageManager 里方法");
/**
 * 根据language设置index, sys(自动),en_US,zh-Hant,zh_CN
 * @param language 取值[sys(自动),en_US,zh-Hant,zh_CN]
 */
//+ (void)setLanguageSelectedIndexWithLanguage:(NSString *)language;
/**
 * 根据languageType返回language, sys(自动),en_US,zh-Hant,zh_CN
 * @param languageType TBLanguageType类型
 */
//+ (NSString *)languageWithLanguageType:(TBLanguageType)languageType;
/**
 * 返回当前语言:sys,en_US,zh-Hant,zh_CN
 */
//+ (NSString *)currentAppLanguage;

// 根据应用设置语言返回的本地化字符串
+ (NSString *)localizedString:(NSString *)key withComment:(NSString *)comment;
+ (NSString *)localizedString:(NSString *)key table:(NSString *)table withComment:(NSString *)comment;
+ (NSString *)localizedString:(NSString *)key bundle:(NSBundle *)bundle table:(NSString *)table withComment:(NSString *)comment;

//提供给swift使用，swift不能直接调用oc的宏
+ (NSString *)resourcesLocalizedString:(NSString *)key withComment:(NSString *)comment;

/**
 * 判断是否使用上下布局，部分页面中文左右布局，英文上下布局
 */
+ (BOOL)useTopToBottomLayout;


//获取系统语言
+ (BOOL)isChineseSimpleLanguage;

//请求要传的lang参数值
+ (NSString *)currentLangParameter DEPRECATED_MSG_ATTRIBUTE("use [TBSwiftLanguageManager langParam]");

@end
