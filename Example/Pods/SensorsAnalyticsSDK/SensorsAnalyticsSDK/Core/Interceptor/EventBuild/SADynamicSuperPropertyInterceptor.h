//
// SADynamicSuperPropertyInterceptor.h
// SensorsAnalyticsSDK
//
// Created by 张敏超🍎 on 2022/4/6.
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

#import <Foundation/Foundation.h>
#import "SAInterceptor.h"

NS_ASSUME_NONNULL_BEGIN

/// 动态公共属性拦截器
///
/// 动态公共属性需要在 serialQueue 队列外获取，如果外部已采集并进入队列，就不再采集
@interface SADynamicSuperPropertyInterceptor : SAInterceptor

@end

NS_ASSUME_NONNULL_END
