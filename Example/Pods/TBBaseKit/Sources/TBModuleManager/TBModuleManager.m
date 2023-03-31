//
//  TBModuleManager.m
//  TBBaseKit
//
//  Created by linbingjie on 2021/3/1.
//

#import "TBModuleManager.h"
#import "TBBaseUtility.h"
#import "TBModuleModel.h"
#import "NSDictionary+TBDataSafeTransform.h"
#import <TBServiceManager.h>
#import <TBServiceProtocolKit/TBUIKitComponentService.h>

static NSString *ModuleNameKey = @"moduleName"; // module name
static NSString *PriorityKey   = @"priority";     // module 优先级
static NSString *InitParamsKey = @"initParams"; // 初始化参数

@interface TBModuleManager ()

@property (nonatomic, strong) NSMutableArray<TBModuleModel *> *modules; // 持有的所有的module
@property (nonatomic, strong) NSMutableDictionary *moduleArray; // 临时存储通过源码注册的modules
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation TBModuleManager

IMPLEMENT_SHARED_INSTANCE(TBModuleManager);

#pragma mark - lifeCycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modules = [NSMutableArray array];
    }
    return self;
}

//须在+load方法中执行注册，否则会影响排序结果
+ (void)registerModuleClass:(NSString *)moduleClass
                     config:(NSDictionary *)initParams
                   priority:(NSInteger)priority
{
    if (!TextValid(moduleClass)) {
        NSAssert(NO, @"moduleclss 不能为nil");
    }
    
    TBModuleModel *model = [[TBModuleModel alloc] init];
    model.moduleNameKey = moduleClass;
    model.priority = @(priority);
    if (initParams.count > 0) {
        model.params = initParams;
    }
    
    [[TBModuleManager sharedInstance].moduleArray setValue:model forKey:moduleClass];
}

- (void)loadModulesWithPlistConfigFilePath:(NSString *)path
{
    NSDictionary *configDic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray<TBModuleModel *> *configArray = [[NSMutableArray alloc] init];

    //plist文件注册
    for (NSString *key in configDic.allKeys) {
        if (![self checkIsValidWithClass:key]) {
            return;
        }
        NSDictionary *properties = configDic[key];
        NSMutableDictionary *module = [[NSMutableDictionary alloc] initWithDictionary:properties];
        
        TBModuleModel *model = [[TBModuleModel alloc] init];
        model.moduleNameKey = key;
        model.priority = [module tbNumberForKey:PriorityKey];
        model.params = [module tbDictionaryForKey:InitParamsKey];
        
        [configArray addObject:model];
    }

    //代码注册
    for (id key in [TBModuleManager sharedInstance].moduleArray) {
        if (![self checkIsValidWithClass:key]) {
            return;
        }
        [configArray addObject:[TBModuleManager sharedInstance].moduleArray[key]];
    }

    NSArray<TBModuleModel *> *modules = [configArray copy];
    ///按照优先级排序
    modules = [modules sortedArrayUsingComparator:^NSComparisonResult(TBModuleModel *obj1, TBModuleModel *obj2) {
        NSNumber *priority1 = obj1.priority;
        if (!priority1) {
            priority1 = @(0);
        }
        NSNumber *priority2 = obj2.priority;
        if (!priority2) {
            priority2 = @(0);
        }

        return [priority2 compare:priority1];
    }];

    NSString *errorMSG = [NSString string];
    for (TBModuleModel *module in modules) {
        // 遍历初始化对象
        NSString *notice = [self loadModuleWithConfig:module];
        if (TextValid(notice)) {
            errorMSG = [errorMSG stringByAppendingString:notice];
        }
    }
    
#ifdef DEBUG
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (TextValid(errorMSG)) {
            [TBService(TBUIKitComponentService) tbUIKit_showHint:errorMSG hide:1.0];
        }
    });
#endif
}


- (void)addModuleObject:(id<TBModuleDelegate> __nonnull)moduleObject
                 params:(NSDictionary * __nullable)params
               priority:(NSNumber * __nullable)priority
{
    if (!priority) {
        priority = @(0);
    }
    
    TBModuleModel *model = [[TBModuleModel alloc] init];
    model.moduleNameKey = NSStringFromClass([moduleObject class]);
    model.priority = priority;
    model.params = params;
    model.targetObject = moduleObject;
    
    NSArray<TBModuleModel *> *modules = [self.modules copy];
    
    if ([model.targetObject respondsToSelector:@selector(loadModuleWithParams:)]) {
        BOOL result = [model.targetObject loadModuleWithParams:params];
        if (!result) {
            NSString *assertMSG = [NSString stringWithFormat:@"%@ 需要能响应loadModuleWithParams", model.moduleNameKey];
            NSAssert(NO, assertMSG);
            return;
        }
    }

    __block NSUInteger index = 0;
    [[modules.reverseObjectEnumerator allObjects] enumerateObjectsUsingBlock:^(TBModuleModel * _Nonnull modelModule, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!modelModule.priority) {
            modelModule.priority = @(0);
        }
        
        if (priority.intValue <= modelModule.priority.doubleValue) {
            *stop = YES;
            index = idx;
        }
    }];

    index = modules.count - index;
    [self.lock lock];
    [self.modules insertObject:model atIndex:index];
    [self.lock unlock];
}

- (void)removeModuleObject:(id<TBModuleDelegate> __nonnull)moduleObject {
    NSArray *arrTmp = [self.modules copy];
    [arrTmp enumerateObjectsUsingBlock:^(TBModuleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.targetObject == moduleObject) {
            *stop = YES;
            [self.lock lock];
            [self.modules removeObject:obj];
            [self.lock unlock];
        }
    }];
}

/// 初始化对象
/// @param config 目标对象
- (NSString *)loadModuleWithConfig:(TBModuleModel *)config {
    NSString *errorMsg = @"";
    
    NSString *moduleName = config.moduleNameKey;
    NSDictionary *params = config.params;
    Class moduleClass = [self moduleClassWithModuleName:moduleName];
    if (moduleClass && [moduleClass conformsToProtocol:@protocol(TBModuleDelegate)]) {
        id<TBModuleDelegate> module;
        if ([[moduleClass class] respondsToSelector:@selector(moduleSingleton)] && [[moduleClass class] moduleSingleton])
        {
            if ([[moduleClass class] respondsToSelector:@selector(sharedInstance)]){
                module = [[moduleClass class] sharedInstance];
            }
            else {
                module = [moduleClass new];
            }
        }
        else {
            module = [moduleClass new];
        }
        
        config.targetObject = module;
        
        if ([module respondsToSelector:@selector(loadModuleWithParams:)]) {
            BOOL result = [module loadModuleWithParams:params];
            if (result) {
                [self.lock lock];
                [self.modules addObject:config];
                [self.lock unlock];
            }
        }
        else {
            ///不实现loadModuleWithParams:方法，则认为该模块不需要初始化，可直接加入module
            [self.lock lock];
            [self.modules addObject:config];
            [self.lock unlock];
        }
        return nil;
    }
    else {
        NSString *str = [NSString stringWithFormat:@"未发现[%@]的模块定义\n", moduleName];
//        NSAssert(NO, str);
        return [errorMsg stringByAppendingString:str];
    }
}

/// string 转class
/// @param moduleName string name
- (Class)moduleClassWithModuleName:(NSString *)moduleName {
    if (!moduleName) {
        //http://stackoverflow.com/a/5909310/2544997
        NSAssert(NO, @"moduleName 为nil");
        return Nil;
    }
    
    if (NSClassFromString(moduleName)) {
        return NSClassFromString(moduleName);
    }
    
    return NSClassFromString(moduleName);
}

/// 判断module名字是否符合规范
/// @param cls cls
- (BOOL)checkIsValidWithClass:(NSString *)cls
{
    if ([cls hasPrefix:@"TB"] && [cls hasSuffix:@"LifeCycleModule"]) {
        return YES;
    }
    else {
#ifdef DEBUG
        NSAssert(false, @"\n\n\n！！！'%@' is wrong, 'TB+Custom+lifeCycleModule' is required ！！！\n\n\n！",cls);
#endif
        return NO;
    }
}

#pragma mark - getter && setter
- (NSArray<TBModuleModel *> *)allModules {
    return self.modules;
}

- (NSMutableDictionary *)moduleArray
{
    [self.lock lock];
    if (!_moduleArray) {
        _moduleArray = [NSMutableDictionary dictionary];
    }
    [self.lock unlock];
    return _moduleArray;
}

- (NSRecursiveLock *)lock
{
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

#pragma mark - UIApplicationDelegate's methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BOOL result = YES;
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
//            NSTimeInterval begin = CACurrentMediaTime();
            BOOL returnValue = [module.targetObject application:application didFinishLaunchingWithOptions:launchOptions];
//            NSTimeInterval cost = CACurrentMediaTime() - begin;
            if (!returnValue) {
                result = NO;
            }
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = NO;
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)]) {
            BOOL canOpen = [module.targetObject application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
            if(canOpen) result = YES;
        }
    }
    return result;

}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary *)options
{
    BOOL result = NO;
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:openURL:options:)]) {
            BOOL canOpen = [module.targetObject application:app openURL:url options:options];;
            if(canOpen) {
                result = YES;
            }
        }
    }
    return result;

}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:handleEventsForBackgroundURLSession:completionHandler:)]) {
            [module.targetObject application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(applicationWillResignActive:)]) {
            [module.targetObject applicationWillResignActive:application];
        }
    }
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(applicationDidReceiveMemoryWarning:)]) {
            [module.targetObject applicationDidReceiveMemoryWarning:application];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(applicationDidEnterBackground:)]) {
            [module.targetObject applicationDidEnterBackground:application];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(applicationWillEnterForeground:)]) {
            [module.targetObject applicationWillEnterForeground:application];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(applicationDidBecomeActive:)]) {
            [module.targetObject applicationDidBecomeActive:application];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(applicationWillTerminate:)]) {
            [module.targetObject applicationWillTerminate:application];
        }
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = NO;
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:handleOpenURL:)]) {
            BOOL handled = [module.targetObject application:application handleOpenURL:url];
            if (handled) {
                result = YES;
            }
        }
    }
    return result;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
            [module.targetObject application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        }
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
            [module.targetObject application:application didFailToRegisterForRemoteNotificationsWithError:error];
        }
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:didRegisterUserNotificationSettings:)]) {
            [module.targetObject application:application didRegisterUserNotificationSettings:notificationSettings];
        }
    }
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:performFetchWithCompletionHandler:)]) {
            [module.targetObject application:application performFetchWithCompletionHandler:completionHandler];
        }
    }
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:
                                                              handleActionWithIdentifier:
                                                              forLocalNotification:
                                                              completionHandler:)]) {
            [module.targetObject application:application
     handleActionWithIdentifier:identifier
           forLocalNotification:notification
              completionHandler:completionHandler];
        }
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:handleActionWithIdentifier:forRemoteNotification:completionHandler:)]) {
            [module.targetObject application:application
                                    handleActionWithIdentifier:identifier
                                         forRemoteNotification:userInfo
                                             completionHandler:completionHandler];
        }
    }
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:didReceiveRemoteNotification:)]) {
            [module.targetObject application:application didReceiveRemoteNotification:userInfo];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
            [module.targetObject application:application
                                  didReceiveRemoteNotification:userInfo
                                        fetchCompletionHandler:completionHandler];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:didReceiveLocalNotification:)]) {
            [module.targetObject application:application didReceiveLocalNotification:notification];
        }
    }
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler
{
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:performActionForShortcutItem:completionHandler:)]) {
            [module.targetObject application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
        }
    }
}

- (BOOL)application:(UIApplication *)application  continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    BOOL result = YES;
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:continueUserActivity:restorationHandler:)]) {
          result = [module.targetObject application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier
{
    BOOL result = YES;
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:@selector(application:shouldAllowExtensionPointIdentifier:)]) {
            result = [module.targetObject application:application shouldAllowExtensionPointIdentifier:extensionPointIdentifier];
        }
    }
    return result;
}

#pragma mark - TBCustomModuleDelegate's methods

- (void)tb_ClearCache {
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:_cmd]) {
            [module.targetObject tb_ClearCache];
        }
    }
}

- (void)tb_registerUrlToMap:(id)map {
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:_cmd]) {
            [module.targetObject tb_registerUrlToMap:map];
        }
    }
}


- (void)tb_operationsAfterLoginOrRegister:(TBOperationsModel *)model {
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:_cmd]) {
            [module.targetObject tb_operationsAfterLoginOrRegister:model];
        }
    }
}

/// 清空用户数据
/// @param virtualAccountIncluded 模拟盘是否需要清空
- (void)tb_cleanUserDataIncludingVirtualAccount:(BOOL)virtualAccountIncluded clearAccountData:(BOOL)clearAccountData {
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:_cmd]) {
            [module.targetObject tb_cleanUserDataIncludingVirtualAccount:virtualAccountIncluded clearAccountData:clearAccountData];
        }
    }
}

- (void)tb_logout {
    for (TBModuleModel *module in self.modules) {
        if ([module.targetObject respondsToSelector:_cmd]) {
            [module.targetObject tb_logout];
        }
    }
}

@end
