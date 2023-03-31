//
// SAPresetPropertyObject.h
// SensorsAnalyticsSDK
//
// Created by yuqiang on 2022/1/7.
// Copyright © 2022 Sensors Data Co., Ltd. All rights reserved.
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SAPresetPropertyObject : NSObject

- (NSString *)manufacturer;
- (NSString *)os;
- (NSString *)osVersion;
- (NSString *)deviceModel;
- (NSString *)lib;
- (NSInteger)screenHeight;
- (NSInteger)screenWidth;
- (NSString *)carrier;
- (NSString *)appID;
- (NSString *)appName;
- (NSInteger)timezoneOffset;

- (NSMutableDictionary<NSString *, id> *)properties;

@end

#if TARGET_OS_IOS
@interface SAPhonePresetProperty : SAPresetPropertyObject

@end

@interface SACatalystPresetProperty : SAPresetPropertyObject

@end
#endif

#if TARGET_OS_OSX
@interface SAMacPresetProperty : SAPresetPropertyObject

@end
#endif

NS_ASSUME_NONNULL_END
