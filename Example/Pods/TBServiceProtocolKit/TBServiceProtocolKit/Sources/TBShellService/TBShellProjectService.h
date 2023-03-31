//
//  TBShellProjectService.h
//  Pods
//
//  Created by linbingjie on 2021/4/27.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TBShellProjectService <NSObject>

@required

/// 个性化物料跳转
/// @param link 跳转链接，可能为url也可能只是path
/// @param arriveFrom 用于统计来源
- (void)tb_jumpWithMaterialLink:(NSString *)link arriveFrom:(NSString *)arriveFrom;

// 深度链接跳转
- (void)tb_jumpWithDeepLink:(NSString *)link;

// 埋点方法
- (void)trackAppBehaviorWithModel:(NSString *)model type:(NSString *)type name:(NSString *)name param1:(nullable NSString *)param1 param2:(nullable NSString *)param2;

// 是否需要开通碎股权限
- (BOOL)shouldOpenFracShareTradePermission:(BOOL)buttonSelected;

// 处理应用语言改变
- (void)handleAppContentLanguageSettingChanged;

// 更新个人设置
- (void)uploadPersonalConfigInfo:(void (^)(BOOL success, NSString *message, NSError *error))callBack;

// 上传今日开发日志
- (void)tb_uploadTodayLog:(void (^)(BOOL success, NSString *logFileUrl))completion;

// 开发日志数据
- (id)loggerData;

- (void)tb_uploadPersonalConfigInfo:(void (^)(BOOL success, NSString *message, NSError *error))callBack;

/// 获取服务器配置信息，如用户设置的红涨绿跌等等
/// @isFromLogin 是否来自登录
- (void)fetchPersonalConfigInfoFromLogin:(BOOL)isFromLogin;

- (void)tb_handleSafariOpen:(NSURL *)url;

- (BOOL)tb_isURLCanOpenPageWithParsedUrl:(NSURL *)url;

- (BOOL)tb_isAbleHandleSafariOpen:(NSURL *)webpageURL;

/// 读取持仓本地配置
- (NSArray *)localPortfolioConfigs:(NSString *)accountCode;

- (NSDictionary *)tb_localKLineIndicatorParams;
- (NSInteger)tb_indicatorAtIndex:(NSInteger)index key:(NSString *)key;
- (NSArray *)tb_indicators:(NSString *)key;

- (void)tb_developLog:(NSString *)logStr;

@end

NS_ASSUME_NONNULL_END
