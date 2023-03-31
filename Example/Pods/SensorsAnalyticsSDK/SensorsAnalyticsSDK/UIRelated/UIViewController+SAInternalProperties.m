//
// UIViewController+SAInternalProperties.m
// SensorsAnalyticsSDK
//
// Created by 陈玉国 on 2022/8/30.
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

#import "UIViewController+SAInternalProperties.h"
#import "SACommonUtility.h"
#import "UIView+SAElementContent.h"

@implementation UIViewController (SAInternalProperties)

- (NSString *)sensorsdata_screenName {
    return NSStringFromClass(self.class);
}

- (NSString *)sensorsdata_title {
    __block NSString *titleViewContent = nil;
    __block NSString *controllerTitle = nil;
    [SACommonUtility performBlockOnMainThread:^{
        titleViewContent = self.navigationItem.titleView.sensorsdata_elementContent;
        controllerTitle = self.navigationItem.title;
    }];
    if (titleViewContent.length > 0) {
        return titleViewContent;
    }

    if (controllerTitle.length > 0) {
        return controllerTitle;
    }
    return nil;
}

@end
