//
//  TBBaseKitUtil.h
//  TBBaseKit
//
//  Created by zhengzhiwen on 2021/6/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *USER_DEFAULT_KEY_SERVER_SETTING = @"serverSetting"; // 服务器设置: 0 测试, 2 线上

@interface TBBaseKitUtil : NSObject

/// 返回当前是测试/线上环境. YES 测试, NO 线上.
+ (BOOL)isTestEnvironment;

//本地化图片名称，需要保证本地化目录下存在对应的图片
+ (NSString *)localizedImageName:(NSString *)name;
+ (BOOL)itemDefauleTrueValueForKey:(NSString *)key;
+ (BOOL)itemDefauleFalseValueForKey:(NSString *)key;

+ (UIImage *)imageWithView:(UIView *)view;
/// 是否安装TestFlight
+ (BOOL)isTestFlightInstalled;
/// 是否是沙盒环境.
+ (BOOL)isSandboxEnvironment;
/// 是否是TestFlight构建版本，用于区分内测包还是正式包
+ (BOOL)isTestFlightBuildVersion;

@end

NS_ASSUME_NONNULL_END
