//
// SAPresetPropertyObject.m
// SensorsAnalyticsSDK
//
// Created by yuqiang on 2022/1/7.
// Copyright © 2015-2022 Sensors Data Co., Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "SAPresetPropertyObject.h"
#include <sys/sysctl.h>
#import "SALog.h"
#import "SAJSONUtil.h"
#import "SAConstants+Private.h"

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#elif TARGET_OS_OSX
#import <AppKit/AppKit.h>
#endif

@implementation SAPresetPropertyObject

#pragma mark - device
/// 型号
static NSString * const kSAEventPresetPropertyPluginModel = @"$model";
/// 生产商
static NSString * const kSAEventPresetPropertyPluginManufacturer = @"$manufacturer";
/// 屏幕高
static NSString * const kSAEventPresetPropertyPluginScreenHeight = @"$screen_height";
/// 屏幕宽
static NSString * const kSAEventPresetPropertyPluginScreenWidth = @"$screen_width";

#pragma mark - os
/// 系统
static NSString * const kSAEventPresetPropertyPluginOS = @"$os";
/// 系统版本
static NSString * const kSAEventPresetPropertyPluginOSVersion = @"$os_version";

#pragma mark - app
/// 应用 ID
static NSString * const SAEventPresetPropertyPluginAppID = @"$app_id";
/// 应用名称
static NSString * const kSAEventPresetPropertyPluginAppName = @"$app_name";
/// 时区偏移量
static NSString * const kSAEventPresetPropertyPluginTimezoneOffset = @"$timezone_offset";

#pragma mark - lib
/// SDK 类型
NSString * const kSAEventPresetPropertyPluginLib = @"$lib";

#pragma mark - preset property
- (NSString *)manufacturer {
    return @"Apple";
}

- (NSString *)os {
    return nil;
}

- (NSString *)osVersion {
    return nil;
}

- (NSString *)deviceModel {
    return nil;
}

- (NSString *)lib {
    return nil;
}

- (NSInteger)screenHeight {
    return 0;
}

- (NSInteger)screenWidth {
    return 0;
}

- (NSString *)carrier {
    return nil;
}

- (NSString *)appID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (NSString *)appName {
    NSString *displayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (displayName.length > 0) {
        return displayName;
    }

    NSString *bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    if (bundleName.length > 0) {
        return bundleName;
    }

    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
}

- (NSInteger)timezoneOffset {
    // 计算时区偏移（保持和 JS 获取时区偏移的计算结果一致，这里首先获取分钟数，然后取反）
    NSInteger minutesOffsetGMT = - ([[NSTimeZone defaultTimeZone] secondsFromGMT] / 60);
    return minutesOffsetGMT;
}

- (NSMutableDictionary<NSString *, id> *)properties {
    NSMutableDictionary<NSString *, id> *properties = [NSMutableDictionary dictionary];
    properties[kSAEventPresetPropertyPluginModel] = self.deviceModel;
    properties[kSAEventPresetPropertyPluginManufacturer] = self.manufacturer;
    properties[kSAEventPresetPropertyPluginOS] = self.os;
    properties[kSAEventPresetPropertyPluginOSVersion] = self.osVersion;
    properties[kSAEventPresetPropertyPluginLib] = self.lib;
    properties[SAEventPresetPropertyPluginAppID] = self.appID;
    properties[kSAEventPresetPropertyPluginAppName] = self.appName;
    properties[kSAEventPresetPropertyPluginScreenHeight] = @(self.screenHeight);
    properties[kSAEventPresetPropertyPluginScreenWidth] = @(self.screenWidth);
    properties[kSAEventPresetPropertyPluginTimezoneOffset] = @(self.timezoneOffset);
    return properties;
}

#pragma mark - util
- (NSString *)sysctlByName:(NSString *)name {
    NSString *result = nil;
    @try {
        size_t size;
        sysctlbyname([name UTF8String], NULL, &size, NULL, 0);
        char answer[size];
        sysctlbyname([name UTF8String], answer, &size, NULL, 0);
        if (size) {
            result = @(answer);
        } else {
            SALogError(@"Failed fetch %@ from sysctl.", name);
        }
    } @catch (NSException *exception) {
        SALogError(@"%@: %@", self, exception);
    }
    return result;
}

@end

#if TARGET_OS_IOS
@implementation SAPhonePresetProperty

- (NSString *)deviceModel {
    return [self sysctlByName:@"hw.machine"];
}

- (NSString *)lib {
    return @"iOS";
}

- (NSString *)os {
    return @"iOS";
}

- (NSString *)osVersion {
    return [[UIDevice currentDevice] systemVersion];
}

- (NSInteger)screenHeight {
    return (NSInteger)UIScreen.mainScreen.bounds.size.height;
}

- (NSInteger)screenWidth {
    return (NSInteger)UIScreen.mainScreen.bounds.size.width;
}

@end

@implementation SACatalystPresetProperty

- (NSString *)deviceModel {
    return [self sysctlByName:@"hw.model"];
}

- (NSString *)lib {
    return @"iOS";
}

- (NSString *)os {
    return @"macOS";
}

- (NSString *)osVersion {
    return [self sysctlByName:@"kern.osproductversion"];
}

- (NSInteger)screenHeight {
    return (NSInteger)UIScreen.mainScreen.bounds.size.height;
}

- (NSInteger)screenWidth {
    return (NSInteger)UIScreen.mainScreen.bounds.size.width;
}

@end
#endif

#if TARGET_OS_OSX
@implementation SAMacPresetProperty

- (NSString *)deviceModel {
    return [self sysctlByName:@"hw.model"];
}

- (NSString *)lib {
    return @"macOS";
}

- (NSString *)os {
    return @"macOS";
}

- (NSString *)osVersion {
    NSDictionary *systemVersion = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"];
    return systemVersion[@"ProductVersion"];
}

- (NSInteger)screenHeight {
    return (NSInteger)NSScreen.mainScreen.frame.size.height;
}

- (NSInteger)screenWidth {
    return (NSInteger)NSScreen.mainScreen.frame.size.width;
}

@end
#endif
