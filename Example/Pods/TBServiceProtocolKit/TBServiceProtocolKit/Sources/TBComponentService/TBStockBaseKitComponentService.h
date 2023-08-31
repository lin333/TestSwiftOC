//
//  TBStockBaseKitComponentService.h
//  Pods
//
//  Created by 秦晓强 on 2023/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TBStockBaseKitComponentService <NSObject>

- (NSString *)tbStockBaseKit_getStockSymbolWithSecInfo:(id)secInfo;

- (NSString *)tbStockBaseKit_getStockMarketWithSecInfo:(id)secInfo;

- (NSString *)tbStockBaseKit_getStockSecTypeWithSecInfo:(id)secInfo;

- (NSNumber *)tbStockBaseKit_getstockRealTimeLatestPriceWithSecInfo:(id)secInfo;

- (NSString *)tbStockBaseKit_getFuturesQuotesDisplayTypeWithSecInfo:(id)secInfo;

- (NSString *)tbStockBaseKit_getDisplayStringFromNumber:(NSNumber *)number
                                                secInfo:(id)secInfo;

- (NSNumber *)tbStockBaseKit_priceNumberWithDisplayString:(NSString *)displayString
                                                  secInfo:(id)secInfo;

/// 跳转到形态选股解释说明页
- (void)tbStockBaseKit_gotoCandleSelectedIntroWebView;


@end
NS_ASSUME_NONNULL_END
