//
//  TBCrossPlatformService.h
//  Pods
//
//  Created by linbingjie on 2021/7/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TBCrossPlatformModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TBCrossPlatformService <NSObject>

@required

#pragma mark - Flutter
/// 跳转Flutter页面,扩展性高，通过param传递参数做特殊处理
/// @param model 页面逻辑
- (nullable id)tb_gotoFlutterPage:(nonnull TBCrossPlatformModel *)model;

// 通过https://laohu8.com/flutter/xxx 形式的链接打开flutter页面
- (void)tb_gotoFlutterPageWithURLString:(NSString *)urlString;

- (void)tb_gotoFlutterMembershipHomeWithIsSvip:(BOOL)isSvip;

// TradeUP使用，打开flutter页面
- (void)tup_gotoFlutterPageWithRouteName:(NSString *)routeName params:(nullable NSDictionary *)params;

- (void)tb_removeFlutterDBCache;

/// TUP IB 跳转入金页面
- (void)tup_ibGotoDepositPage;

/// TUP IB 跳转出金页面
- (void)tup_ibGotoWithdrawalPage;

/// TUP 跳转IPO页面
- (void)tup_gotoIPOPage;

#pragma mark - RN
/// 跳转RN页面  - tb_gotoRNPage 扩展性高，通过param传递参数做特殊处理
/// @param params 页面逻辑
- (nullable id)tb_gotoRNPage:(nonnull TBCrossPlatformModel *)model;
- (void)tb_gotoRNPageWithURLString:(NSString *)urlString fromAD:(BOOL)fromAD;
- (void)tb_gotoRNPageWithURLString:(NSString *)urlString fromAD:(BOOL)fromAD arriveFrom:(NSString *)arriveFrom;
- (void)tb_gotoRNPageWithURLString:(NSString *)urlString fromAD:(BOOL)fromAD arriveFrom:(NSString *)arriveFrom otherParam:(nullable NSDictionary *)otherParamDict;

- (BOOL)tb_canOpenRNLink:(NSString *)rnLink;

/// 通过moduleName和customRNData创建RN视图控制器
/// @param moduleName 模块名称，必须传
/// @param customRNData 特定业务需要传入的数据，可不传
/// @return 实为TBRNViewController类型
- (UIViewController *)tb_rnViewControllerWithModuleName:(NSString *)moduleName
                                           customRNData:(nullable NSDictionary *)customRNData;

/// 通过moduleName、RNData和RNConfig创建RN视图控制器
/// @param moduleName 模块名称，必须传
/// @param RNData 包含page等信息，必须传
/// @param RNConfig 特定业务需要传入的数据，可不传
/// @return 实为TBRNViewController类型
- (UIViewController *)tb_rnViewControllerWithModuleName:(NSString *)moduleName
                                                 RNData:(NSDictionary *)RNData
                                               RNConfig:(nullable NSDictionary *)RNConfig;
/// 提供给帖子详情页使用的RN视频view
/// @param parameters RN视频需要的参数
- (UIView *)tb_rnPostVideoViewWithParameters:(NSDictionary *)parameters;

/// 弹出RN页 isPopover是否半屏
- (void)presentRNPageWithQuery:(NSDictionary *)query isPopover:(BOOL)isPopover;

///   设置RN VC appear属性
- (void)tb_setRNPageIsAppearing:(BOOL)appear withViewController:(UIViewController *)vc;


// 通过query dictionry 创建RN视图控制器
/// @param query  参数字典 必须传
/// @param canScroll，可不传
/// @return 实为TBRNViewController类型
- (UIViewController *)tb_rnViewControllerWithQuery:(NSDictionary *)query
                            subScrollViewCanScroll:(BOOL)canScroll;


- (NSString *)tb_fetchTBRNLiveToSmallScreenNotificationKey;

- (NSString *)tb_fetchTBRNLiveHideSmallScreenNotification;

- (NSString *)tb_fetchTBRNNewsChangeTabNotification;

- (void)tb_setupLivePlayerView:(UIView *)liveView liveId:(NSString *)liveId;

- (void)tb_gotoOpenAccountStartPageWithParams:(nullable NSDictionary *)param;

/**
 * 跳转升级到保证金账户
 * @param userInfo 额外信息(预留)
 */
- (void)tup_goToUpgradeToMarginPage:(nullable NSDictionary *)userInfo;

// 对[TBRNDataManager sharedInstance].disableRNModule进行set get 操作
- (BOOL)tb_fetchDisableRNModule;
- (void)tb_setDisableRNModule:(BOOL)isON;

- (BOOL)tb_fetchRNUseLocalhostBundle;
- (void)setUseLocalhostBundle:(BOOL)isON;


@end

NS_ASSUME_NONNULL_END
