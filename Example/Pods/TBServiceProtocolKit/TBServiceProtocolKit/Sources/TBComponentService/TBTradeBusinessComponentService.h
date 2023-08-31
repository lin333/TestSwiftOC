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

@class TBTradeAPIPositionItemModel;

@protocol TBCouponDelegate;
@protocol TBStockDetailInfoDataSource;

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

- (nonnull UIView *)tbTradeBusiness_tradeSummaryTitleViewWithChangeAccountBlock:(void (^)(void))block;

- (void)tbTradeBusiness_share:(id)shareObject
                     userInfo:(nullable NSDictionary *)userInfo;

- (id)tbTradeBusiness_parentPositionItemModelOfLegContractId:(NSString *)contractId;

- (id)tbTradeBusiness_getIBPortfolioStatBriefItemModelWithDictionary:(NSDictionary *)dict;

- (NSArray *)tbTradeBusiness_sortOrdersWithArray:(NSArray *)orders;

- (void)tbTradeBusiness_updatePositionDataItem:(id)item;

/**
 * 查询组合视图下的用户个股及个股所在多腿持仓
 */
- (void)tbTradeBusiness_getPositionOfSymbol:(NSString *)symbol
                    secType:(nullable NSString *)secType
                     expiry:(nullable NSString *)expiry
                     strike:(nullable NSString *)strike
                      right:(nullable NSString *)right
                     legs:(nullable NSArray<NSDictionary *> *)legs
                    success:(void(^)(NSArray *positions))success
                    failure:(void(^)(NSError *error))failure;

- (void)tbTradeBusiness_getOpenOrders:(nullable NSString *)symbol
              secType:(nullable NSString *)secType
               market:(nullable NSString *)market
            comboType:(nullable NSString *)comboType
            contracts:(nullable NSArray<NSDictionary *> *)contracts
              success:(nullable void (^)(NSArray * _Nullable orders))success
              failure:(nullable void (^)(NSInteger ret, NSString * _Nullable status, NSString * _Nullable message, NSError * _Nullable error))failure;

- (void)tbTradeBusiness_updateCurrentOpenOrders:(NSArray *)symbolArray;

- (void)tbTradeBusiness_fetchTodayOrders:(nullable NSString *)segType
                 secType:(nullable NSString *)secType
                  symbol:(nullable NSString *)symbol
               comboType:(nullable NSString *)comboType
                    legs:(nullable NSArray <NSDictionary *> *)legs
                 success:(void (^)(NSArray * _Nullable))success
                 failure:(nullable void (^)(NSInteger ret, NSString * _Nullable status, NSString * _Nullable message, NSError * _Nullable error))failure;

///  跳转到TradeSummary里的某个子页面
- (void)tbTradeBusiness_gotoTradeSummaryVCTab:(UIViewController *_Nonnull)selectedViewController
                           notificationObject:(id _Nullable)notificationObject;

- (UIViewController *)tbTradeBusiness_initTBTradeSummaryViewController;

- (void)tbTradeBusiness_showComplianceTipsIfNeeded;

- (void)tbTradeBusiness_setLastInstalledAppVersion:(NSString *)lastStoredAppVersion;

- (void)tbTradeBusiness_initAssetPositionOrderStatusDateManager;

- (void)tbTradeBusiness_fetchCustomerTradeCheck;

- (id)tbTradeBusiness_initCheckPlaceOrderManager;

- (void)tbTradeBusiness_checkPlaceOrderManager:(id)manager model:(nullable id)orderModel
                     secInfo:(id)secInfo
                contractInfo:(id)contractInfo
               checkingItems:(NSArray *)checkingTypes
                                    completion:(void(^)(BOOL finished, NSInteger stoppedCheckItem,
                                        NSInteger checkResultAction))completion;

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

/// 订单变化通知key
- (NSString *)tbTradeBusiness_getNotificationKey_NOTIFICATION_KEY_ORDERS_CHANGED;


- (NSArray *)tbTradeBusiness_getOriginSymbolsOfPositions;

// 获取当前账户持仓
- (void)tbTradeBusiness_getPositionsWithSuccess:(nullable void(^)(void))success
                                        failure:(nullable void(^)(NSError *error))failure;


- (BOOL)tbTradeBusiness_hasStockPositionForSymbol:(NSString *)symbol;

- (void)tbTradeBusiness_getPositionOfSymbol:(NSString *)symbol
                                    secType:(NSString *)secType
                                     market:(nullable NSString *)market
                                    success:(void(^)(id position))success
                                    failure:(void(^)(NSError *error))failure;

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

/*
 * @param market 指定定投市场 可选
 * @param userInfo 额外信息(预留)
 */
- (void)tbTradeBusiness_gotoRSPListPage:(NSString *)arriveFrom market:(nullable NSString *)market userInfo:(nullable NSDictionary *)userInfo;

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

/// 获取对应标的定投回报数据
- (void)tbTradeBusiness_fetchRspReturnValueWithSymbol:(NSString *)symbol
                                               market:(NSString *)market
                                           completion:(void(^)(id responseObject))completion;

/// 添加 omnibus 需要的参数
- (NSDictionary *)tbTradeBusiness_generateParameters:(NSDictionary *)parameters;

/// 获取 omnibus 相关 host
- (NSString *)tbTradeBusiness_omnibusServerHost;

/// 判断当前账号是否是OMNIBUS Cash账号
- (BOOL)tbTradeBusiness_assetAccountTypeIsOmnibusCash;

@optional
/// 浮窗显示用户账号切换VC
- (void)tbTradeBusiness_floatingShowAccountSwitchControllerWithCallBack:(nullable void(^)(void))callBack;

/**
 * 获取浮点数的小数部分的精度，精确到小数点后6位以上
 */
- (NSInteger)tbTradeBusiness_decimalPrecision:(double)minTick;

/**
 * 判断价格是否满足最小变动单位要求
 */
- (BOOL)tbTradeBusiness_isValidStockScale:(NSNumber *)scale
                                 forPrice:(NSNumber *)price;

- (void)tbTradeBusiness_getAssetSuccess:(void (^)(id asset))success
                                failure:(void (^)(NSInteger ret, NSString *status, NSString *message, NSError *error))failure;

- (NSString *)tbTradeBusiness_getAssetCapability;

/// 条件订单符合：≤，≥，≠，=，<，>
- (NSString *)tbTradeBusiness_conditionDesSymbolFromConditionType:(NSString *)type
                                                      operatorStr:(NSString *)operatorStr;

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

- (BOOL)tbTradeBusiness_shouldShowCorporateActionAlert:(id)corporateActionDataModel;

/// 是否显示期货资金划转弹窗
- (BOOL)tbTradeBusiness_showTransferFundsAlert;

/// 是否显示数字货币资金划转弹窗
- (BOOL)tbTradeBusiness_showTransferDigitalAlert;

- (NSInteger)tbTradeBusiness_assetDataManagerGetAccountType;

- (BOOL)tbTradeBusiness_isDigitalAssetEmpty;

- (NSString *)tbTradeBusiness_assetDataManagerGetAccountTypeString;

/**
 待成交订单提醒
 */
- (void)tbTradeBusiness_showUnfilledOrdersAlertComplete:(nullable void(^)(void)) buttonBlock;


- (void)tbTradeBusiness_showConfirmViewWithTitle:(NSString *)title
                                         content:(id)content
                                     cancelTitle:(nullable NSString *)cancelTitle
                                    confirmTitle:(NSString *)confirmTitle
                                         confirm:(nullable dispatch_block_t)confirmBlock
                                          cancel:(nullable dispatch_block_t)cancelBlock;


/// 判断marsco账号 是否是处在非交易时间
- (BOOL)tbTradeBusiness_judgeMarscoTradingStatusINNonTradingHours:(NSInteger)tradingStatus;

/// 含贷款价值总权益
- (NSString *)tbTradeBusiness_totalRightsWithDeptIndexIntroduction;


/*
 资金不足，提示去划转资金
 */
- (void)tbTradeBusiness_transferFundFromSecType:(NSString *)secType
                                  continueBlock:(void (^)(void))continueBlock;

- (NSArray *)tbTradeBusiness_getOrdersFromOrderStatusDataManager;

// trade首页资产view显示警告的属性
- (BOOL)tbTradeBusiness_showDayTradesRemainingAlert;

- (void)tbTradeBusiness_SetShowDayTradesRemainingAlertWith:(BOOL)flag;

- (NSNumber *)tbTradeBusiness_getDayTradesRemaining;

- (NSNumber *)tbTradeBusiness_getPositionWithCellItem:(id)item;

- (id)tbTradeBusiness_getPositionModelItemWithCellItem:(id)item;

- (NSString *)tbTradeBusiness_getPositionSymbolWithCellItem:(id)item;

- (NSNumber *)tbTradeBusiness_getPositionIsOddWithCellItem:(id)item;

- (void)tbTradeBusiness_setPositionIsOddWithFlag:(BOOL)flag
                                        cellItem:(id)item;

- (NSString *)tbTradeBusiness_getLocalSymbolWithOrderItemModel:(id)model;

/// 显示不可下单alert
/// 我们目前不支持在市场休市时下单。 请在交易时间重试。
/// @param vcToAlert VC
- (void)tbTradeBusiness_showNonTradingHoursAlert:(UIViewController *)vcToAlert
                                   ContinueBlock:(void (^)(void))continueBlock
                                    failureBlock:(nullable void (^)(void))failureBlock;

- (void)tbTradeBusiness_showCorporateActionAlertIfNeed:(id)model
                                          confirmBlock:(void (^)(void))confirmBlock
                                           cancelBlock:(void (^)(void))cancelBlock;

- (UIColor *_Nullable)tbTradeBusiness_getPositionTableCellPnlColorWithModel:(id _Nullable)model;

- (void)tbTradeBusiness_tigerPayRequestOrderInfoWithOrderId:(NSString *)orderId
                                     withBlock:(void(^)(NSError * _Nullable error, id _Nullable orderInfo))block;
- (NSDictionary *_Nullable)tbTradeBusiness_convertToDictionaryTigerPayOrderInfoWithModel:(id)model;

- (NSDictionary *)tbTradeBusiness_cachedPositionCostTypeAndIndicatorsSettings;

/**
 根据symbol和secType查询是否在持仓
 */
- (BOOL)tbTradeBusiness_isExitInPositionWithSymbol:(NSString *)symbol
                                           secType:(NSString *)secType;

- (NSArray *_Nullable)tbTradeBusiness_positionDataManagerGetAllPositions;

- (NSArray *_Nullable)tbTradeBusiness_positionDataManagerGetStockPositions;

- (NSArray *_Nullable)tbTradeBusiness_positionDataManagerGetOptionsPositions;

- (NSArray *_Nullable)tbTradeBusiness_positionDataManagerGetOtherPositions;

- (NSArray *_Nullable)tbTradeBusiness_positionDataManagerGetFuturesPositions;

- (NSArray *_Nullable)tbTradeBusiness_positionDataManagerGetDigitalPositions;

- (UIViewController *)tbTradeBusiness_cancelVCFromBottom:(id _Nullable)orderItem
                                           futPriceModel:(id _Nullable)futPriceModel
                                        futContractModel:(id _Nullable)futContractModel;

- (UIViewController *)tbTradeBusiness_modifyOrderVCWithSecInfo:(id)secInfo
                                                    orderModel:(id)orderModel;


- (UIViewController *_Nullable)tbTradeBusiness_speedModeVCWithSecInfo:(id)secInfo
                                                           limitPrice:(NSNumber *_Nonnull)limitPrice;

- (UIViewController *_Nullable)tbTradeBusiness_speedModeVCFromLeftWithSecInfo:(id)secInfo
                                                                   limitPrice:(NSNumber *_Nonnull)limitPrice;

/// 配置下单页明细展示：档位/深度 或 明细逐笔
///
- (NSInteger)tbTradeBusiness_contractTicksSelectedIndex:(NSString *)market
                                                secType:(NSString *)secType
                                           exchangeCode:(NSString *)exchangeCode;

/**
 * 价格输入框点击+-号时调用此方法
 */
- (NSNumber *)tbTradeBusiness_minTick:(NSNumber *)latestPrice
                          contactInfo:(id)contactInfo
                              secInfo:(id)secInfo
                               ranges:(NSArray *_Nullable*_Nullable)ranges
                               isLeft:(BOOL)isLeft;

- (NSNumber *)tbTradeBusiness_minTick:(NSNumber *)price
                          contactInfo:(id)contactInfo
                              secInfo:(id)secInfo
                               ranges:(NSArray *_Nullable*_Nullable)ranges;

- (NSString *)tbTradeBusiness_getAllAccountCertifiUrlWithAiPath;

- (NSString *)tbTradeBusiness_getAllAccountCertifiUrlWithPiPath;

- (NSString *)tbTradeBusiness_getAllAccountCertifiUrlWithWiPath;

- (BOOL)tbTradeBusiness_checkPIAuthCertification;

- (void)tbTradeBusiness_AllAccountHelperHandleAccountAction:(NSInteger)actionType;

- (NSString *)tbTradeBusiness_getOrderStatus:(double)totalCount
                                 filledCount:(double)filledCount
                                 orderStatus:(NSInteger)orderStatus
                                  isMonetary:(BOOL)isMonetary;
- (BOOL)tbTradeBusiness_isAVERAGECostTypeWithSegType:(NSString *)segType;

- (BOOL)tbTradeBusiness_isFIFOCostTypeWithSegType:(NSString *)segType;

/**
 更新 限价价格，仅限于 非期货 限价单
 */
- (void)tbTradeBusiness_updateLimitPriceWithSpeedModeVC:(UIViewController *)vc;

- (void)tbTradeBusiness_speedModeVC:(UIViewController *)vc
                  dismissCompletion:(void (^ __nullable)(void))completion;

- (void)tbTradeBusiness_updateSpeedModeBtnPriceWithVC:(UIViewController *)vc;

- (void)tbTradeBusiness_setLimitPriceWithSpeedModeVC:(UIViewController *)vc
                                          limitPrice:(NSNumber *)price;

- (void)tbTradeBusiness_setSecInfoWithSpeedModeVC:(UIViewController *)vc
                                          secInfo:(id)secInfo;

- (void)tbTradeBusiness_setStockOrderCheckerDataSource:(id)dataSource
                                            vcCallback:(id)callback
                                                    vc:(id)vc;

- (void)tbTradeBusiness_checkingDidEndWithAction:(NSInteger)action;

- (void)tbTradeBusiness_fetchPlaceOrderBuySellMaxAmount:(id)placeOrderModel
                  enableFractionalShare:(BOOL)enableFractionalShare
                         enalbeMonetray:(BOOL)enableMonetray
                                success:(nullable void(^)(id))success
                                failure:(nullable void(^)(id))failure;

/** 获取组合期权的保证金
 *
 */
- (void)tbTradeBusiness_getRiskNavigatorWithParams:(NSDictionary *)params
                                           success:(void(^)(id responseObject))success
                                           failure:(void(^)(NSError *error))failure;

/**
 查询单只合约
 */
- (void)tbTradeBusiness_orderOmnibusContractsSecType:(nullable NSString *)secType
                                              symbol:(nullable NSString *)symbol
                                              expiry:(nullable NSString *)expiry
                                              strike:(nullable NSString *)strike
                                               right:(nullable NSString *)right
                                             success:(void(^)(id itemModel))success
                                             failure:(void(^)(NSString *message, NSError *error))failure;

- (void)tbTradeBusiness_orderOmnibusContractsSecType:(nullable NSString *)secType
                           comboType:(NSString *)comboType
                           contracts:(NSArray <NSDictionary *>*)contracts
                             success:(void(^)(id itemModel))success
                             failure:(void(^)(NSString *message, NSError *error))failure;


- (UIView *)tbTradeBusiness_getOpenAccountGuideAdvantageView;

- (NSString *)tbTradeBusiness_getNotificationKey_NOTIFICATION_KEY_OPEN_VIRTUALACCOUNT_SUCCESS;

/// 账户切换时，不带虚拟账户信息。（用于IPO列表页，顶部切换账户使用）
- (void)tbTradeBusiness_floatingShowWithoutVirtualAccountWithBlock:(nullable void (^)(NSInteger))changeAccountTypeBlock;

- (BOOL)tbTradeBusiness_updateOrderLimitPrice:(NSNumber *)limitPrice
                                           vc:(UIViewController *)vc;

- (BOOL)tbTradeBusiness_getAccountDescriptionModelSelected:(id)item;
- (BOOL)tbTradeBusiness_getAccountDescriptionModelShowHighlight:(id)item;

- (NSNumber *)tbTradeBusiness_exchangeCurrencyIfNeed:(NSString *)fromCurrency
                                          toCurrency:(NSString *)toCurrency
                                               amout:(NSNumber *)amount;

- (id)tbTradeBusiness_assetDataManagerGetAsset;

- (id)tbTradeBusiness_assetDataManagerGetFuturesAsset;

- (id)tbTradeBusiness_assetDataManagerGetFundAsset;

- (id)tbTradeBusiness_assetDataManagerGetDigitalAsset;

- (void)tbTradeBusiness_handleAccountAction:(NSInteger)actionType
                                  inAccount:(NSInteger)accountType
                                   location:(NSInteger)locationType;

- (NSString *)tbTradeBusiness_tradeTimeAlertWithMarket:(NSString *)market
                                             timestamp:(long long)timestamp
                                              pageType:(NSInteger)pageType
                                             orderType:(NSString *)orderType;

- (NSString *)tbTradeBusiness_getOrderActionTypeDes:(NSString *)action;

- (NSString *)tbTradeBusiness_attachOrderPriceDesForAttachOrderType:(NSString *)attachOrderType;

- (NSString *)tbTradeBusiness_orderTypeDescription:(NSString *)orderType;

- (NSString *)tbTradeBusiness_orderTypeDescription:(NSString *)orderType
                                           subType:(NSString *)subType;

- (BOOL)tbTradeBusiness_canShowRthSettingForMarket:(NSString *)market
                           secType:(NSString *)secType
                         orderType:(NSString *)orderType
                        usOTCOrder:(BOOL)isUsOTCOrder
                       hkGreyOrder:(BOOL)isHkGreyOrder
                    conditionOrder:(BOOL)isConditionOrder
                 composedOrderType:(NSString *)composedOrderType
                      contractTime:(NSTimeInterval)contractTime;

- (NSString *)tbTradeBusiness_stringLineTypeWithType:(NSInteger)lineType;

- (long long)tbTradeBusiness_getEndTime:(long long)start type:(NSInteger)lineType;


- (void)tbTradeBusiness_getStockTradeMark:(nullable NSString *)symbol
                  secType:(nullable NSString *)secType
                   market:(nullable NSString *)market
                    since:(NSInteger)since
                       to:(NSInteger)to
            combineSymbol:(nullable NSString *)combineSymbol
                 group_by:(nullable NSString *)group_by
                  success:(nullable void (^)(NSArray * _Nonnull items))success
                  failure:(nullable void (^)(NSString *message, NSError *error))failure;
/**
 * 获取当前账户的成本类型
 */
- (NSString *)tbTradeBusiness_getCostTypeForCurrentAccount:(NSString *)account;

- (void)tbTradeBusiness_getOpenOrders:(nullable NSString *)symbol
              secType:(nullable NSString *)secType
               market:(nullable NSString *)market
              success:(nullable void (^)(NSArray* _Nullable orders))success
              failure:(nullable void (^)(NSInteger ret, NSString * _Nullable status, NSString * _Nullable message, NSError * _Nullable error))failure;

- (void)tbTradeBusiness_fetchFilledOrders:(nullable NSString *)symbol
                  secType:(NSString *)secType
                  segType:(NSString *)segType
                sinceDate:(nullable NSString *)sinceDate
                   toDate:(nullable NSString *)toDate
                usePrefix:(BOOL)usePrefix
              lastOrderId:(nullable NSNumber *)lastOrderId
                  success:(nullable void (^)(NSArray *orders, BOOL hasMore))success
                  failure:(nullable void (^)(NSInteger ret, NSString * _Nullable status, NSString * _Nullable message, NSError * _Nullable error))failure;

- (NSDictionary *)tbTradeBusiness_getExchangeRateDictionary;

- (void)tbTradeBusiness_requestExchangeRateWithCompletion:(nullable void (^)(BOOL success))completion;

/**
 * @param coupons 选中的优惠券
 * @param exclusiveCoupons 互斥的优惠券
 * @param recommendedCoupons 推荐的优惠券
 * @param couponParameters 获取当前优惠券列表数据的请求参数
 * @param lifetimeCommissionFree 是否终生免佣标识
 * @param dataService 数据源的协议实现
 * @param couponCategory 优惠券类别 详见TBCouponCategory声明和定义
 * @param didChangeCouponBlock 修改优惠券的回调
 */
- (nonnull UIViewController *)tbTradeBusiness_couponListVCWithCoupons:(nullable NSArray<TBCouponDelegate> *)coupons
                                                     exclusiveCoupons:(nullable NSArray<TBCouponDelegate> *)exclusiveCoupons
                                                   recommendedCoupons:(nullable NSArray<TBCouponDelegate> *)recommendedCoupons
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

/**
 * 交易类未读消息数
 */
- (BOOL)tbTradeBusiness_hasUnreadMessage;

- (void)tbTradeBusiness_closePosition:(TBTradeAPIPositionItemModel *)positionItemModel userInfo:(nullable NSDictionary *)userInfo;

/** 组合期权下单，生成legInfo字典方法
 * @param market 市场（不传默认美股US）
 * @param secType secType(不传默认OPT）
 * @param action 交易方向-买卖
 * @param symbol 期权四要素-symbol
 * @param right 期权四要素-right
 * @param expiry 期权四要素-expiry
 * @param strike 期权四要素-strike
 * @param ratio 比例，可以nil，默认1
 */
- (NSDictionary *)tbTradeBusiness_getMLegInfoWithMarket:(nullable NSString *)market
                                                secType:(nullable NSString *)secType
                                                 action:(NSString *)action
                                                 symbol:(NSString *)symbol
                                                  right:(NSString *)right
                                                 expiry:(NSNumber *)expiry
                                                 strike:(NSString *)strike
                                                  ratio:(nullable NSNumber *)ratio;

/** 进入组合期权下单页
 * @param strategyKey 策略key
 * @param strategyName 策略名称
 * @param legInfos 策略leg信息，字典数组（期权的信息：期权四要素、secType、market等，使用tbTradeBusiness_getMLegInfoWithMarket方法生成）
 * 字典key如下：
    - market
    - secType
    - action
    - symbol
    - right
    - expiry
    - strike
 */
- (void)tbTradeBusiness_gotoMLegPlaceOrderWithStrategyKey:(NSString *)strategyKey withStrategyName:(NSString *)strategyName withLegInfos:(NSArray <NSDictionary *> *)legInfos;

- (void)tbTradeBusiness_placeOrderShowInsufficientFundsAlertIfNeeded:(id<TBStockDetailInfoDataSource>) secInfo continueBlock:(void(^)(BOOL goon))selectedBlock;

/**
 * 首页延迟行情跑马灯点击关闭调用
 */
- (void)tbTradeBusiness_updateDelayQuoteBannerStatus:(BOOL)closed;

/**
 * 存在延迟行情时，首页和持仓首页跑马灯文案
 */
- (NSString *)tbTradeBusiness_delayQuoteBannerText;
/*
 * 判断某个标的是否需要弹出开通碎股权限
 */
- (BOOL)tbTradeBusiness_shouldShowFractionalShareAlert:(NSString *)market
                                              secType:(NSString *)secType
                       contractSupportFractionalShare:(BOOL)contractSupportFractionalShare;

/**
 * 判断当前账户是否需要弹出开通碎股权限
 */
- (BOOL)tbTradeBusiness_shouldShowFractionalShareAlert:(nullable NSDictionary *)userInfo;


@end

NS_ASSUME_NONNULL_END

#endif /* TBTradeBusinessComponentService_h */
