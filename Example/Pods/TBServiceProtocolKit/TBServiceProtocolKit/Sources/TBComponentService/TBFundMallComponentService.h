//
//  TBFundMallComponentService.h
//  Pods
//
//  Created by chenxin on 2022/5/26.
//

#ifndef TBFundMallComponentService_h
#define TBFundMallComponentService_h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TBFundMallComponentService <NSObject>

// 无持仓视图
- (UIView *)tbFund_positionEmptyView;

// 开通基金超市账户
- (void)tbFund_openFundMallAccount;

// 获取基金超市持仓
- (void)tbFund_fetchFundMallPosition:(void(^)(id result))success failure:(void(^)(NSString *message))failure;

// 是否有资产
- (BOOL)tbFund_hasAssetWithModel:(id)model;

// 基金超市账户主币种
- (NSString *)tbFund_mainCurrencyWithModel:(id)model;

// 累计收益
- (NSNumber *)tbFund_accumulatedInterestWithModel:(id)model;

// 资产cellItem
- (id)tbFund_assetCellItemWithBlock:(void(^)(UIButton *currencyBtn))block;

// 处理持仓cellItem
- (NSArray *)tbFund_positionCellItemsWithModel:(id)model;

// 更新资产cell
- (void)tbFund_updateAssetCellItem:(id)cellItem model:(id)model currency:(NSString *)currency;

// 处理cell点击
- (void)tbFund_handleActionWithCellItem:(id)item info:(id)info listVC:(id)listVC;


@optional

- (void)tbFund_openPurchasePageV2:(NSString *)symbol
                         name:(NSString *)fundName
                       amount:(nullable NSString *)amount
                        isRsp:(NSInteger)isRsp;

- (void)tbFund_gotoFundPositionPage;

- (NSDictionary *)tbFund_convertToDictionaryWithFundDetailItem:(id)item;

- (NSDictionary *)tbFund_convertToDictionaryWithFundReturnItem:(id)item;

- (void)tbFund_setLabel:(UILabel *)label number:(CGFloat)number hundredTimes:(BOOL)hundredTimes showPercent:(BOOL)showPercent factionDigits:(NSInteger)factionDigits;

- (void)tbFund_fetchFundDetail:(NSDictionary *)params
                   success:(void(^_Nullable)(_Nullable id result))success
                   failure:(void(^_Nullable)(NSString * _Nullable message))failure;


@end

NS_ASSUME_NONNULL_END

#endif /* TBFundMallComponentService_h */
