//
//  TBAuthBusinessComponentService.h
//  Pods
//
//  Created by linbingjie on 2022/5/18.
//

#ifndef TBAuthBusinessComponentService_h
#define TBAuthBusinessComponentService_h

NS_ASSUME_NONNULL_BEGIN

@protocol TBAuthBusinessComponentService <NSObject>

/// 创建生物识别解锁controller
/// @param type 类型
- (UIViewController *)tbAuth_createTouchUnlockControllerWithType:(NSInteger)type;

/// 获取国家编码
/// @param info 通知info
- (nullable NSString *)tbAuth_countryCodeWithInfo:(NSDictionary *)info;

/// 获取国家名字
/// @param info 通知info
- (nullable NSString *)tbAuth_countryNameWithInfo:(NSDictionary *)info;

- (BOOL)tbAuth_canWechatUniversalLinkWithActivity:(NSUserActivity *)activity;


@optional
- (void)tbAuth_openWechatAndSubscribe;

- (UIViewController *)tbAuth_getAccountSettingViewController;

@end

NS_ASSUME_NONNULL_END

#endif /* TBAuthBusinessComponentService_h */
