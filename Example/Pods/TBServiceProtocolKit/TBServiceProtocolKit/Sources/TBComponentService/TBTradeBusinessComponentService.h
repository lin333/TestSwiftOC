//
//  TBTradeBusinessComponentService.h
//  Pods
//
//  Created by yangln on 2021/12/2.
//

#ifndef TBTradeBusinessComponentService_h
#define TBTradeBusinessComponentService_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TBTradeBusinessComponentService <NSObject>

/// 刷新资产
- (void)tbTradeBusinessMethod_requestMyAssets;

/**
 * 跳转到入金历史页面
 * @param userInfo 额外信息(预留)
 */
- (void)tbTradeBusiness_goToDepositHistoryPage:(nullable NSDictionary *)userInfo;

/**
 * 跳转到账单
 * @param userInfo 额外信息(预留)
 */
- (void)tbTradeBusiness_goToBillPage:(nullable NSDictionary *)userInfo;

/**
 * 跳转账户转移|转入股票
 * @param userInfo 额外信息(预留)
 */
- (void)tbTradeBusiness_goToAccountTransferPage:(nullable NSDictionary *)userInfo;

/**
 * 跳转到银行账户页
 * @param userInfo 额外信息(预留)
 */
- (void)tbTradeBusiness_goToBankAccountsPage:(nullable NSDictionary *)userInfo;

/**
 * marsco现金账户 跳转到pdt页面
 * @param userInfo 额外信息(预留)
 */
- (void)tbTradeBusiness_goToGFVStatusPage:(nullable NSDictionary *)userInfo;


// 当前交易账户资产字符串（netLiquidation+currency），用于在账户列表显示
- (nonnull NSString *)tbTradeBusiness_currentTradeAccountAssetString;

// 当前交易账户总资产对应的显示币种
- (nonnull NSString *)tbTradeBusiness_currentTradeAccountAssetCurrencyString;

/// 用户支持碎股接口
- (void)tbTradeBusiness_fetchOmnibusUserAbility;

// 显示在底部的合规提示
- (nullable NSString *)tbTradeBusiness_bottomComplianceString;

// 设置交易提醒
- (void)tbTradeBusiness_setupTradeComplianceWithDict:(nonnull NSDictionary *)dataDict;

// 交易tab标题控件
- (nonnull UIView *)tbTradeBusiness_tradeSummaryTitleView;

///  跳转到TradeSummary里的某个子页面
/// @param notification
- (void)tbTradeBusiness_gotoTradeSummaryVCTab:(UIViewController *_Nonnull)selectedViewController
                           notificationObject:(id _Nullable)notificationObject;

- (UIViewController *)tbTradeBusiness_initTBTradeSummaryViewController;

- (void)tbTradeBusiness_showComplianceTipsIfNeeded;

- (void)tbTradeBusiness_setLastInstalledAppVersion:(NSString *)lastStoredAppVersion;

- (void)tbTradeBusiness_initAssetPositionOrderStatusDateManager;

- (void)tbTradeBusiness_fetchCustomerTradeCheck;

/**
 * 跳转到入金页面
 * @param userInfo 额外信息(预留)
 */
- (void)tbTradeBusiness_goToDepositPage:(nullable NSDictionary *)userInfo;

/**
 * 跳转到出金页面
 * @param userInfo 额外信息(预留)
 */
- (void)tbTradeBusiness_goToWithdrawalPage:(nullable NSDictionary *)userInfo;


/// 获取汇率 && OMnibus获取汇率
- (void)tbTradeBusiness_updateExchangeRate;

/// 基金-证券是否合并购买力
- (BOOL)tbTradeBusiness_isCombinedPurchasingPower;

/// 获取持仓通知key
- (NSString *)tbTradeBusiness_getNotificationKey_NOTIFICATION_KEY_POSITION_CHANGED;

// MARK: TBExchangeRateManager
// 查看 ExchangeRateDictionary是否存在，不存在requestExchangeRateWithCompletion
- (void)tbTradeBusiness_validateExchangeRateManagerExchangeRateDictionary;

- (NSString *)tbTradeBusiness_depositUrl;

- (NSString *)tbTradeBusiness_getNotifycationKey_NOTIFICATION_KEY_POSITION_CHANGE_FAILED;

- (BOOL)tbTradeBusiness_verifyCurrencyAssetCash:(NSString *)currency;

- (BOOL)tbTradeBusiness_limitMarginAssetValiteWithCurrency:(NSString *)currency;

/// 盈亏分享
- (void)tbTradeBusiness_sharePNL:(NSNumber *)amount title:(NSString *)title currency:(NSString *)currency;

/// 跳转到股票定投详情页
- (void)tbTradeBusiness_gotoRSPDetailPageWithRspId:(NSNumber *)rspId;

/// 跳转到我的股票定投页
- (void)tbTradeBusiness_gotoRSPMyPlanListPage:(NSInteger)status;

/// 跳转到定投榜单页
- (void)tbTradeBusiness_gotoRSPListPage;

/// 跳转到股票定投首页
- (void)tbTradeBusiness_gotoRSPHomePage:(NSString *)arriveFrom;

- (void)tbTradeBusiness_gotoRSPCreatePage:(NSString *)symbol
                                  secType:(NSString *)secType
                                   market:(NSString *)market                               
                               arriveFrom:(NSString *)arriveFrom;

/// 取消定投
- (void)tbTradeBusiness_cancelRSPWithRspId:(NSNumber *)rspId;

- (void)tbTradeBusiness_gotoRSPCalculatorPage:(NSString *)symbol
                                      secType:(NSString *)secType
                                       market:(NSString *)market
                                   arriveFrom:(NSString *)arriveFrom;

- (BOOL)tbTradeBusiness_gotoRSPRelevantPage:(NSString *)path
                                   userInfo:(NSDictionary *)userInfo;

/// 添加 omnibus 需要的参数
- (NSDictionary *)tbTradeBusiness_generateParameters:(NSDictionary *)parameters;

/// 获取 omnibus 相关 host
- (NSString *)tbTradeBusiness_omnibusServerHost;

/// 判断当前账号是否是OMNIBUS Cash账号
- (BOOL)tbTradeBusiness_assetAccountTypeIsOmnibusCash;

@optional
/// 浮窗显示用户账号切换VC
- (void)tbTradeBusiness_floatingShowAccountSwitchControllerWithCallBack:(nullable void(^)(void))callBack;

- (NSDictionary *_Nullable)tbTradeBusiness_convertPnLShareInfoModelToDict:(id _Nullable )model;

- (NSDictionary *_Nullable)tbTradeBusiness_convertStockDetailPositionCellItemToDict:(id _Nullable)cellItem;

- (NSNumber *_Nullable)tbTradeBusiness_getAssetManagerCurrentNetLiquidation;

- (NSDictionary * _Nullable)tbTradeBusiness_getPositionPnLShareInfoWithStockDetailPositionCellItem:(id _Nullable)cellItem;

- (NSDictionary * _Nullable)tbTradeBusiness_convertToDictionaryTradeAPIPositionItemModel:(id _Nullable)model;

- (id _Nullable )tbTradeBusiness_getTradeAPIOrderItemModelWithOrderId:(double)orderId
                                            isTigerVault:(BOOL)flag;

- (NSNumber *_Nullable)tbTradeBusiness_getUnrealPnlPercentBasedOnCostTypeWithModel:(id _Nullable)model;

- (NSNumber *_Nullable)tbTradeBusiness_getAverageCostBasedOnCostTypeWithModel:(id _Nullable)model;

- (NSString *_Nullable)tbTradeBusiness_getPositionTableCellAverageCostWithModel:(id _Nullable)model;

- (NSString *_Nullable)tbTradeBusiness_getPositionTableCellLatestPriceWithModel:(id _Nullable)model;

- (NSString *_Nullable)tbTradeBusiness_getPositionTableCellPnlRateWithModel:(id _Nullable)model;

- (UIColor *_Nullable)tbTradeBusiness_getPositionTableCellPnlColorWithModel:(id _Nullable)model;

- (void)tbTradeBusiness_tigerPayRequestOrderInfoWithOrderId:(NSString *)orderId
                                     withBlock:(void(^)(NSError * _Nullable error, id _Nullable orderInfo))block;
- (NSDictionary *_Nullable)tbTradeBusiness_convertToDictionaryTigerPayOrderInfoWithModel:(id)model;

- (NSDictionary *)tbTradeBusiness_cachedPositionCostTypeAndIndicatorsSettings;

- (NSArray *_Nullable)tbTradeBusiness_positionDataManagerGetAllPositions;

- (NSArray *_Nullable)tbTradeBusiness_positionDataManagerGetStockPositions;

- (NSArray *_Nullable)tbTradeBusiness_positionDataManagerGetOptionsPositions;

- (NSArray *_Nullable)tbTradeBusiness_positionDataManagerGetOtherPositions;

- (NSNumber *)tbTradeBusiness_exchangeCurrencyIfNeed:(NSString *)fromCurrency
                                          toCurrency:(NSString *)toCurrency
                                               amout:(NSNumber *)amount;

- (nonnull UIViewController *)tbTradeBusiness_couponListVCWithCoupons:(nullable NSArray *)coupons
                                                     exclusiveCoupons:(nullable NSArray *)exclusiveCoupons
                                                   recommendedCoupons:(nullable NSArray *)recommendedCoupons
                                                     couponParameters:(NSDictionary *)couponParameters
                                               lifetimeCommissionFree:(BOOL)lifetimeCommissionFree
                                                          dataService:dataService
                                                       couponCategory:(nullable NSString *)couponCategory
                                                 didChangeCouponBlock:(void(^)(NSArray *selectedCoupons))didChangeCouponBlock;

- (void)tbTradeBusiness_showFloatingPanelWithCouponSummaryVC:(UIViewController *)vc
                                                      baseVC:(UIViewController *)baseVC;

- (BOOL)tbTradeBusiness_portfolioPageIsLite;

/// 是否需要重新加载持仓页
- (BOOL)tbTradeBusiness_shouldReloadPortfolioPage;

@end

NS_ASSUME_NONNULL_END

#endif /* TBTradeBusinessComponentService_h */
