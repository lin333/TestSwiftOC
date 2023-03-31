//
//  UIDevice+OrientationDevice.m
//  Stock
//
//  Created by PXJ on 2020/6/2.
//  Copyright © 2020 com.tigerbrokers. All rights reserved.
//

#import "UIDevice+OrientationDevice.h"
#import "TBServiceManager+TBPerformanceService.h"
#import <objc/runtime.h>


@implementation UIDevice (OrientationDevice)
+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (@available(iOS 16, *)) {
        @try {
            UIWindowScene *scene = (UIWindowScene *)UIApplication.sharedApplication.connectedScenes.allObjects.firstObject;
            UIInterfaceOrientationMask orientationMask = [self getOrientationMask:interfaceOrientation];
            UIWindowSceneGeometryPreferencesIOS *geometryPreferences = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:orientationMask];
            
            if (scene && geometryPreferences && [scene respondsToSelector:@selector(requestGeometryUpdateWithPreferences:errorHandler:)]) {
                [scene requestGeometryUpdateWithPreferences:geometryPreferences errorHandler:^(NSError * _Nonnull error) {
                    TB_DEVELOPERLOG(@"屏幕旋转失败：%@", error.localizedDescription);
                }];
            }
            
        } @catch (NSException *exception) {
            TB_DEVELOPERLOG(@"捕获到屏幕旋转异常:%@，原因:%@", exception.name, exception.reason);
        } @finally {
            
        }
    } else {
        NSNumber *resetOrientationTarget = @(UIInterfaceOrientationUnknown);
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        NSNumber *orientationTarget = @(interfaceOrientation);
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

+ (UIInterfaceOrientationMask)getOrientationMask:(UIInterfaceOrientation)interfaceOrientation {
    switch (interfaceOrientation) {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:
            return UIInterfaceOrientationMaskPortrait;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return UIInterfaceOrientationMaskPortraitUpsideDown;
            
        case UIInterfaceOrientationLandscapeLeft:
            return UIInterfaceOrientationMaskLandscapeLeft;
            
        case UIInterfaceOrientationLandscapeRight:
            return UIInterfaceOrientationMaskLandscapeRight;
            
        default:
            return UIInterfaceOrientationMaskPortrait;
    }
}

@end

