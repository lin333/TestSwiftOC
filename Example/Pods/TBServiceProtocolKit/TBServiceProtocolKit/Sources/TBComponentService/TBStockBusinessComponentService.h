//
//  TBStockBusinessComponentService.h
//  TBServiceProtocolKit
//
//  Created by linbingjie on 2021/12/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TBStockBusinessComponentService <NSObject>

/// 点击行情 tab 事件
- (void)tbStockBusiness_quoteTabTapAction;

/// 获取自选分组
/// @param callBack 回调
- (void)tbStockBusiness_fetchWatchListGroupsWithCallBack:(nullable void(^)(void))callBack;

/// 清空股票别名
- (void)tbStockBusiness_clearAlias;

/// mini 走势图，支持股票，期权，期货，数据源和自选的一致
/// @param symbol symbol
/// @param symbol market
/// @param secType secType description
/// @param color color
/// @param needPreCloseLine 是否需要昨收线
- (UIView *)tbStockBusiness_thumbnailKlineViewWithSymbol:(NSString *)symbol market:(NSString *)market secType:(NSString *)secType color:(UIColor *)color needPreCloseLine:(BOOL)needPreCloseLine;

/// 跳转新股申购
/// @param market 市场 US/HK
/// @param tabType 列表类型，详见TBIPOsTabType
- (void)tbStockBusiness_jumpIPOWithMarket:(nullable NSString *)market tabType:(NSInteger)tabType;

//判断股票是否存在于自选列表中
//
- (BOOL)tbStockBusiness_isStockInWatchList:(NSString *)symbol;

// 添加或移除自选
- (void)tbStockBusiness_addOrRemoveWatchListWithSymbol:(NSString *)symbol name:(NSString *)name market:(NSString *)market secType:(NSString *)secType shouldSelect:(BOOL)shouldSelect completion:(void (^)(BOOL selected))completion;

/// 判断是否是H5 IPO？
- (BOOL)tbStockBusiness_isIPOPurchaseH5;

/// 处理IPO Action
/// @param actionType
- (void)tbStockBusiness_handleIPOsActionType:(NSInteger)actionType;

/// 自选股数量
- (NSInteger)tbStockBusiness_loadCacheWatchListStocksCount;

/// 删除自选股cache
- (void)tbStockBusiness_removeGroupCache;

// 添加自选埋点
- (void)tbStockBusiness_addWatchListSaTrack:(BOOL)isAdd actPage:(NSString *)actPage symbol:(NSString *)symbol market:(NSString *)market secType:(NSString *)secType;

- (void)tbStockBusiness_stockRightAlertShowAlert;

/// 初始化TBQuoteTabViewController
- (UIViewController *)tbStockBusiness_initTBQuoteTabViewController;

/// 初始化TBDiscoverRootController
- (UIViewController *)tbStockBusiness_initTBDiscoverRootController;

/// TBTabBarIndexQuote时候触发quotevc跳转逻辑
/// @param quoteTab 目标quotetab
/// @param path 路径
- (void)tbStockBusiness_quoteTabGotoMarketTab:(UIViewController *)quoteTab
                            path:(NSString *)path;

/// 直接push跳转指定市场页
/// @param quoteTab 目标quotetab
/// @param path 路径
- (void)tbStockBusiness_gotoMarketPageWithPath:(NSString *)path
               fromViewController:(UIViewController *)fromViewController;

- (void)tbStockBusiness_gotoDiscoverSubPageVC:(UIViewController *)selectedVC
                           index:(NSInteger)index;

- (void)tbStockBusiness_fetchIsEnableHKStockLevel0;

/// 跳转IPO页面
/// @param tabType tab类型
/// @param userInfo userinfo
- (void)tbStockBusiness_gotoIPOPage:(NSInteger)tabType userInfo:(nullable NSDictionary *)userInfo;

- (void)tbStockBusiness_fetchAllStockPriceAlert;

- (void)tbStockBusiness_showOptionPermissionAlert;

/// 拉取股票别名
- (void)tbStockBusiness_fetchStockAlias;

- (void)tbStockBusiness_stockDetailHKStockLevelSwitch:(void (^)(BOOL))sucess;

@optional

- (id)tbStockBusiness_getTopRecommendCellItemWithDict:(NSDictionary *)dict;
- (id)tbStockBusiness_getTopRecommendCellItemWithDict:(NSDictionary *)dict showClose:(BOOL)showClose;

- (NSString *)tbStockBusiness_getAliasWithSymbol:(NSString *)symbol;

- (CGFloat)tbStockBusiness_getSplitWidth;

- (CGFloat)tbStockBusiness_getNameWidthWithThumbnail;

- (void)tbStockBusiness_addStocksToWatchList:(NSArray *)stocks
                        groupId:(NSInteger)groupId
                      successed:(void(^)(void))successed
                         failed:(void(^)(NSError * _Nullable error))failed;

- (void)tbStockBusiness_fetchStocksDetailInfo:(NSArray *)stockSymbols
                                        brifeMode:(BOOL)brifeMode
                                       isLiteMode:(BOOL)isLiteMode
                                        needDelay:(BOOL)needDelay
                                    refreshOptFut:(BOOL)refreshOptFut successed:(void(^)(id _Nullable result))successed
                                           failed:(void(^)(NSError * _Nullable error))failed;

- (UIView *)tbStockBusiness_getStockDetailNewPostKlineViewWithSymbol:(NSString *)symbol market:(NSString *)market secType:(NSString *)secType items:(NSArray *)items preClose:(CGFloat)preClose;

- (void)tbStockBusiness_setUpKlineViewWithSymbol:(NSString *)symbol market:(NSString *)market secType:(NSString *)secType;

- (void)tbStockBusiness_createKlinePostHandleActionForCell:(id)cell object:(id)item info:(id)info;

- (BOOL)tbStockBusiness_isAllowDetailBottomShowIndexNotification;

- (BOOL)tbStockBusiness_isAllowHangqingAnimationLayer;

- (BOOL)tbStockBusiness_isAllowHangqingSmartSorting;

- (BOOL)tbStockBusiness_isAllowClickLastColumnSwitchDisplayItem;

- (BOOL)tbStockBusiness_isAllowItemBGView;

- (BOOL)tbStockBusiness_isDisplayOptionPosition;

- (BOOL)tbStockBusiness_isAllowItemListMenu;

- (void)tbStockBusiness_setAllowItemBGView:(BOOL)allow;

- (void)tbStockBusiness_setAllowClickLastColumnSwitchDisplayItem:(BOOL)allow;

- (void)tbStockBusiness_setAllowItemListMenu:(BOOL)allow;

- (UIView *)tbStockBusiness_getCreatePostKlineView;

- (NSString *)tbStockBusiness_getWatchlistChangeNotificationKey;

- (NSString *)tbStockBusiness_getStockColorSettingNotificationKey;

- (NSString *)tbStockBusiness_getRefreshViewShowNotificationKey;

- (NSString *)tbStockBusiness_getRefreshViewHideNotificationKey;

- (NSString *)tbStockBusiness_getNotificationKey_NOTIFICATION_KEY_GET_QUOTE_FREE_ARCALV2;

- (NSString *)tbStockBusiness_getNotificationKey_kNOTIFICATION_KEY_GET_FRACTIONAL_SHARE_PERMISSSION;

- (NSString *)tbStockBusiness_getNotificationKey_USER_DEFAULT_ALLOW_BOTTOMSHOWINDEX_NOTIFICATION;

- (NSString *)tbStockBusiness_getNotificationKey_USER_DEFAULT_KEY_HANGQING_ANIMATION_LAYER;

- (NSString *)tbStockBusiness_getNotificationKey_USER_DEFAULT_KEY_HANGQING_SMART_SORTING;

- (NSString *)tbStockBusiness_getNotificationKey_USER_DEFAULT_KEY_OPTION_POSITION_DISPLAY;

- (NSDictionary *)tbStockBusiness_convertWatchlistCellItemToDict:(id)item;

- (id)tbStockBusiness_getWatchlistCellItemWithSymbol:(NSString *)symbol market:(NSString *)market secType:(NSString *)secType;

- (id)tbStockBusiness_getWatchlistParamObjectWithSymbol:(NSString *)symbol market:(NSString *)market secType:(NSString *)secType name:(NSString *)nameCN;

- (NSArray *)tbStockBusiness_getWatchlistSearchCellItemArray;

- (NSArray *)tbStockBusiness_getFastWatchlistArray;

- (NSArray *)tbStockBusiness_loadCacheWatchlistArray;

- (NSString *)tbStockBusiness_getSymbolWithStockDetailCombineVC:(UIViewController *)vc;

- (NSString *)tbStockBusiness_getSymbolWithStockDetailHorizontalVC:(UIViewController *)vc;

- (NSInteger)tbStockBusiness_getFrequencyTypeWithSymbol:(NSString *)symbol;

- (void)tbStockBusiness_updateStockPriceAlertFrequencyToOncePerDayWithSymbol:(NSString *)symbol market:(NSString *)market;

- (void)tbStockBusiness_fetchWatchlistThumbnail:(NSArray *)stocks success:(void(^)(id _Nullable result))successed failed:(void(^)(NSError * _Nullable error))failed;

- (void)tbStockBusiness_deleteStockPriceAlertWithSymbol:(NSString *)symbol;

- (void)tbStockBusiness_deleteFastWatchlistWithSymbol:(NSString *)symbol;

- (void)tbStockBusiness_addFastWatchlistWithDict:(NSDictionary *)dict;

- (void)tbStockBusiness_gotoHKStockQuotePage;

- (void)tbStockBusiness_getIPOCount:(void(^)(BOOL hasNew, NSInteger newIPOCount))completion;

@end

NS_ASSUME_NONNULL_END
