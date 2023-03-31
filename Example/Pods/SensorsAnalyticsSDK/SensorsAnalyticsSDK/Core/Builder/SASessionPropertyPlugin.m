//
// SASessionPropertyPlugin.m
// SensorsAnalyticsSDK
//
// Created by  储强盛 on 2022/5/5.
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

#import "SASessionPropertyPlugin.h"
#import "SAPropertyPluginManager.h"
#import "SASessionProperty.h"

@interface SASessionPropertyPlugin()

@property (nonatomic, weak) SASessionProperty *sessionProperty;

@end

@implementation SASessionPropertyPlugin

- (instancetype)initWithSessionProperty:(SASessionProperty *)sessionProperty {
    NSAssert(sessionProperty, @"You must initialize sessionProperty");
    if (!sessionProperty) {
        return nil;
    }

    self = [super init];
    if (self) {
        _sessionProperty = sessionProperty;
    }
    return self;
}

- (BOOL)isMatchedWithFilter:(id<SAPropertyPluginEventFilter>)filter {
    return filter.type & SAEventTypeDefault;
}

- (SAPropertyPluginPriority)priority {
    return kSAPropertyPluginPrioritySuper;
}

- (NSDictionary<NSString *,id> *)properties {
    if (!self.filter) {
        return nil;
    }
    NSDictionary *properties = [self.sessionProperty sessionPropertiesWithEventTime:@(self.filter.time)];
    return properties;
}

@end
