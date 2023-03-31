//
//  TBBaseKitUtil.m
//  TBBaseKit
//
//  Created by zhengzhiwen on 2021/6/7.
//

#import "TBBaseKitUtil.h"
#import "TBLanguageManager.h"
#import "TBBaseUtility.h"
#import "TBNetWorkUtility.h"
#import "TBStringUtility.h"

@implementation TBBaseKitUtil

+ (BOOL)isTestEnvironment {
    NSNumber *environment = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_KEY_SERVER_SETTING];
    if (!environment) {
        environment = @0;
    }
    return environment.integerValue == 0;
}

+ (NSString *)localizedImageName:(NSString *)name {
    NSString *folderName = [TBLanguageManager currentLocalizableFolderName];
    if (folderName) {
        //由于传进来的name不带扩展名和@2x\@3x，此处无法判断图片是否存在
        NSString *localizedName = [NSString stringWithFormat:@"%@/%@", folderName, name];
        return localizedName;
    }
    return name;
}


+ (BOOL)itemDefauleTrueValueForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *item = [defaults objectForKey:key];
    if (item && !item.boolValue) {
        return NO;
    }
    return YES;
}

+ (BOOL)itemDefauleFalseValueForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *item = [defaults objectForKey:key];
    if (item && item.boolValue) {
        return YES;
    }
    return NO;
}

+ (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}

+ (BOOL)isTestFlightInstalled {
    NSURL *URL = [NSURL URLWithString:@"itms-beta://"];
    return [[UIApplication sharedApplication] canOpenURL:URL];
}

+ (BOOL)isSandboxEnvironment {
    // 可参考 GULAppEnvironmentUtil 对各种环境的判断
    NSURL *appStoreReceiptURL = NSBundle.mainBundle.appStoreReceiptURL;
    if (NSBundle.mainBundle.appStoreReceiptURL) {
        if ([appStoreReceiptURL.lastPathComponent isEqualToString:@"sandboxReceipt"]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isTestFlightBuildVersion {
    // Testflight打包脚本会把TBIsTestflight设为true
    BOOL isTestflight = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TBIsTestflight"];
    return [self isSandboxEnvironment] && isTestflight;
}

@end
