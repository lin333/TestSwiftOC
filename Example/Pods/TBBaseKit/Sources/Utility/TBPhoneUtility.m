//
//  TBPhoneUtility.m
//  TBBaseKit
//
//  Created by linbingjie on 2021/1/28.
//

#import "TBPhoneUtility.h"
#import "TBBaseKitMacro.h"
#import <Photos/PHPhotoLibrary.h>
#import "TBBuildConfigureManager.h"
#import <TBServiceManager.h>
#import <TBServiceProtocolKit/TBUIKitComponentService.h>
#import <Reachability/Reachability.h>


@implementation TBPhoneUtility

+ (NSString *)iOSSystemLanguage {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
    NSString *preferredLang = languages.firstObject;
    return preferredLang;
}

+ (BOOL)isSize4s
{
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    if ((screenHeight == 480 && screenWidth == 320) || (screenHeight == 320 && screenWidth == 480)){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isSize6Plus
{
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    if ((screenHeight == 736 && screenWidth == 414) || (screenHeight == 414 && screenWidth == 736)){
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)isSize6
{
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    if ((screenHeight == 667 && screenWidth == 375) || (screenHeight == 375 && screenWidth == 667)){
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)isSize5s
{
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    if ((screenHeight == 568 && screenWidth == 320) || (screenHeight == 320 && screenWidth == 568)){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isDeviceWidthLargerThan320
{
    return [[UIScreen mainScreen] bounds].size.width > 320;
}

+ (BOOL)NETConnect
{
    return [Reachability reachabilityForInternetConnection].isReachable;
}

+ (BOOL)WIFIConnected
{
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    return netStatus == ReachableViaWiFi;
}

+ (void)callNumbersWithArray:(NSArray *)numberArray presentVC:(UIViewController *)vc
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    for (int i = 0; i < numberArray.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:numberArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",numberArray[i]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
        }];
        [alertVC addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:TBResourcesLocalizedString(@"mobile_comm_common_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelAction];
    [vc presentViewController:alertVC animated:YES completion:nil];
}


+ (BOOL)isAppRunInBackground
{
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    return ((state == UIApplicationStateBackground) || (state == UIApplicationStateInactive));
}

+ (BOOL)isAppRunInForeground
{
    if (![NSThread isMainThread]) {
        
    }
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    return (state == UIApplicationStateActive);
}

// 当前是否横屏
+ (BOOL)isCurrentLandscape {
    return SCREEN_WIDTH > SCREEN_HEIGHT;
}

+ (NSString *)fetchAppVersion {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TBAppStoreVersionString"];
    if (!TextValid(version)) {
#ifdef DEBUG
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TBService(TBUIKitComponentService) tbUIKit_showHint:@"没有设置version号" hide:1.0];
    });
#endif
        return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    return version;
}

+ (void)tradeUPAssert {
    if (TBIsTradeUP) {
        NSAssert(NO, @"tradeup目前没这个逻辑，遇到调用确认一下tradeup逻辑是什么");
    }
}

+ (CGFloat)fetchScreenWidth {
    return ([[UIScreen mainScreen] bounds].size.width);
}

+ (CGFloat)fetchScreenHeight {
    return ([[UIScreen mainScreen] bounds].size.height);
}

+ (BOOL)isDisplayZoomed {
    BOOL isDisplayZoomed = [UIScreen mainScreen].scale != [UIScreen mainScreen].nativeScale;
    return isDisplayZoomed;
}

@end
