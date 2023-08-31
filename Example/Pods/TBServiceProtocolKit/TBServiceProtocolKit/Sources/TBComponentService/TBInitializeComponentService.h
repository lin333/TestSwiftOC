//
//  TBInitializeComponentService.h
//  Pods
//
//  Created by linbingjie on 2022/6/7.
//

#ifndef TBInitializeComponentService_h
#define TBInitializeComponentService_h

NS_ASSUME_NONNULL_BEGIN

@protocol TBInitializeComponentService <NSObject>

- (void)tbInitialize_loadTabBar;

- (void)tbInitialize_reloadTradeTab;

- (void)tbInitialize_hideNewbieGiftGuide:(id)tabBarController;


///  以下几个方法是三方handle处理逻辑
/// 注册三方SDK
/// @param application 应用
/// @param launchOptions 启动选项
- (void)tbInitialize_registerThirdPartyAccountWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;
/// 微信是否可以打开universal link
/// @param activity NSUserActivity
- (BOOL)tbInitialize_canWechatUniversalLinkWithActivity:(NSUserActivity *)activity;
/// 微信是否可以打开url
/// @param url NSURL
- (BOOL)tbInitialize_canWecahtOpenUrl:(NSURL *)url;
/// 微博是否可以打开url
/// @param url NSURL
- (BOOL)tbInitialize_canWeiboOpenUrl:(NSURL *)url;
- (void)tbInitialize_openWechatAndSubscribe;





/// 设置jpush角标
/// - Parameter badge: 角标
- (void)tbInitialize_jpushSetBadge:(NSInteger)badge;

/// 注册相关方法调用
- (void)tbInitialize_jpushRegistration:(NSDictionary *)launchOptions
                           productMode:(BOOL)productMode
                            completion:(void(^)(int resCode,NSString *registrationID))completionHandler;


/// 跳到热更新debugvc
- (void)tbInitialize_jumpToPatchDebugVC;


/// 跳转聊天
- (void)tbInitialize_jumpTypeOnlineChat;

// 底部微信引导入金delegate
- (void)tbInitialize_openAccountWeixinGuide;

@end

NS_ASSUME_NONNULL_END

#endif /* TBInitializeComponentService_h */
