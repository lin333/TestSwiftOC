//
//  TBServiceManager.m
//  TBBaseKit
//
//  Created by linbingjie on 2021/3/4.
//

#import "TBServiceManager.h"
#import <objc/runtime.h>
#import "TBServiceBaseProtocol.h"
#import "TBBuildConfigureManager.h"

static const NSString *kService = @"service";
static const NSString *kImpl = @"implementation";

@interface TBServiceManager()

@property (nonatomic, strong) NSMutableDictionary *allServicesDict;
@property (nonatomic, strong) NSRecursiveLock *lock;

@property (nonatomic, copy) NSString *strMissingProtocol;

/// 判断是否处在校验protocol在impl中是否实现的阶段
/// 默认为NO
/// 仅在dev中触发逻辑
@property (nonatomic, assign) BOOL isJudgeingProtocolMethodISImplementation;

@end

@implementation TBServiceManager

+ (instancetype)sharedInstance
{
    static id sharedManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.strMissingProtocol = @"";
        self.isJudgeingProtocolMethodISImplementation = NO;
    }
    return self;
}

- (void)loadServiceWithPlistConfigFilePath:(NSString *)plistPath {
    if (plistPath.length <= 0 || !plistPath) {
        NSAssert(NO, @"需要输入一个正确的path");
    }
    
    NSArray *serviceList = [[NSArray alloc] initWithContentsOfFile:plistPath];
    if(serviceList.count == 0){
        NSAssert(NO, @"plist 内部数据为空");
        return;
    }
    
    self.isJudgeingProtocolMethodISImplementation = NO;

    [self.lock lock];
    
    for (NSDictionary *dict in serviceList) {
        self.isJudgeingProtocolMethodISImplementation = YES;
        NSString *protocolKey = [dict objectForKey:kService];
        NSString *protocolImplClass = [dict objectForKey:kImpl];
        if (protocolKey.length > 0 && protocolImplClass.length > 0) {
            [self.allServicesDict addEntriesFromDictionary:@{protocolKey:protocolImplClass}];
        }
        else {
            if (self.enableException) {
                @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"plist register failed. service:%@, impl:%@", protocolKey, protocolImplClass] userInfo:nil];
            }
        }
        
        if (TBONLYDebug) {
            
            [self dev_judgeProtocolMethodISImplementation:NSClassFromString(protocolImplClass)
                                                 protocol:NSProtocolFromString(protocolKey)];
        }
    }
    [self.lock unlock];

    self.isJudgeingProtocolMethodISImplementation = NO;
    
    if (TBONLYDebug) {
        if (TextValid(self.strMissingProtocol)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未实现的protocol（声明为require的）" message:self.strMissingProtocol preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *actionCopy = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    //取消处理
                    if (TextValid(self.strMissingProtocol)) {
                        [UIPasteboard generalPasteboard].string = self.strMissingProtocol;
                    }
                }];

                [alert addAction:actionCopy];
                UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
                [viewController presentViewController:alert animated:NO completion:nil];
            });
        }
    }
}

- (void)registerService:(Protocol *)service implClass:(Class)implClass
{
    NSParameterAssert(service != nil);
    NSParameterAssert(implClass != nil);
    
    // impClass 是否遵循了 Protocol 协议
    if (![implClass conformsToProtocol:service]) {
        if (self.enableException) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ module does not comply with %@ protocol", NSStringFromClass(implClass), NSStringFromProtocol(service)] userInfo:nil];
        }
        return;
    }
    
    // Protocol 协议是否已经注册过了
    if ([self checkValidService:service]) {
        if (self.enableException) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ protocol has been registed", NSStringFromProtocol(service)] userInfo:nil];
        }
        return;
    }
    
    NSString *key = NSStringFromProtocol(service);
    NSString *value = NSStringFromClass(implClass);
    
    if (key.length > 0 && value.length > 0) {
        [self.lock lock];
        [self.allServicesDict addEntriesFromDictionary:@{key:value}];
        [self.lock unlock];
    }
}

- (id)createService:(Protocol *)service
{
    id implInstance = nil;
    
    if (![self checkValidService:service]) {
        if (self.enableException) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ protocol does not been registed", NSStringFromProtocol(service)] userInfo:nil];
        }
        else {
            if (TBONLYDebug) {
                NSString *strNotice = [NSString stringWithFormat:@"%@ protocol does not been registed", NSStringFromProtocol(service)];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:strNotice message:@"" preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *actionCopy = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    //取消处理
                    if (TextValid(self.strMissingProtocol)) {
                        [UIPasteboard generalPasteboard].string = self.strMissingProtocol;
                    }
                }];
                [alert addAction:actionCopy];
                UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
                [viewController presentViewController:alert animated:NO completion:nil];
            }
        }
    }
    
    Class implClass = [self serviceImplClass:service];
    if ([[implClass class] respondsToSelector:@selector(serviceSingleton)]) {
        if ([[implClass class] serviceSingleton]) {
            if ([[implClass class] respondsToSelector:@selector(sharedInstance)]) {
                implInstance = [[implClass class] sharedInstance];
            }
            else {
                implInstance = [[implClass alloc] init];
            }
            return implInstance;
        }
    }
        
    if (TBDebug && !self.isJudgeingProtocolMethodISImplementation) {
        if ([[implClass alloc] init]) {
        }
        else {
            NSLog(@"❎❎❎❎ %@impl 没有引入，无法调用对应service方法",NSStringFromProtocol(service));
        }
    }
    return [[implClass alloc] init];
}

- (BOOL)serviceRespondToSelector:(Protocol *)service selector:(SEL)aSelector {
    return [self serviceRespondToSelector:service selector:aSelector needAssert:YES];
}

- (BOOL)serviceRespondToSelector:(Protocol *)service selector:(SEL)aSelector needAssert:(BOOL)needAssert {
    BOOL respond = [[self createService:service] respondsToSelector:aSelector];
    if (!respond) {
        NSString *assetMsg = [NSString stringWithFormat:@"the imlementation of service %@ does't implement method %@", NSStringFromProtocol(service), NSStringFromSelector(aSelector)];
        if (needAssert) {
            NSAssert(NO, assetMsg);
        }
    }
    return respond;
}

#pragma mark - private

/// 通过protocol 拿到对应的class
/// @param service protocol
- (Class)serviceImplClass:(Protocol *)service
{
    NSString *serviceImpl = [[self servicesDict] objectForKey:NSStringFromProtocol(service)];
    if (serviceImpl.length > 0) {
        return NSClassFromString(serviceImpl);
    }
    return nil;
}

/// 检查字典中是否已经有目标protocol了
/// @param service 目标protocol
- (BOOL)checkValidService:(Protocol *)service
{
    NSString *serviceImpl = [[self servicesDict] objectForKey:NSStringFromProtocol(service)];
    if (serviceImpl.length > 0) {
        return YES;
    }
    return NO;
}

/// dev 下校验所有的service的protocol是否都实现了，避免没有实现的情况
/// @param protocolImplClass class
/// @param protocolKey protocol
- (void)dev_judgeProtocolMethodISImplementation:(Class)protocolImplClass protocol:(Protocol *)protocolKey {
    if (TBONLYDebug) {
        NSArray *arrProtocol = [self fetchProtocolList:protocolImplClass];

        NSString *strMissing = @"";
        for (int i = 0; i< arrProtocol.count; i++) {
            UInt32 protocolMethodCount = 0;
            struct objc_method_description *desc = protocol_copyMethodDescriptionList(NSProtocolFromString(arrProtocol[i]), true, true, &protocolMethodCount);
            
            for (int j = 0; j < protocolMethodCount; j++) {
                struct objc_method_description temp = desc[j];
                
                if (!temp.name) {
                    continue;
                }
                if (![self serviceRespondToSelector:protocolKey selector:temp.name needAssert:NO]) {
                    strMissing = [strMissing stringByAppendingFormat:@"【imp】:%@, 【missing SEL】:%@ \n", NSStringFromClass(protocolImplClass), NSStringFromSelector(temp.name)];
                }
            }
            free(desc);
        }
        
        
        if (TextValid(strMissing)) {
            self.strMissingProtocol = [self.strMissingProtocol stringByAppendingString:strMissing];
        }
    }
}

/// 获取class中使用的protocol
/// @param targetClass 目标class
- (NSArray *)fetchProtocolList:(Class)targetClass
{
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(targetClass, &count);
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++ )
    {
        Protocol *protocol = protocolList[i];
        const char *protocolName = protocol_getName(protocol);
        [mutableList addObject:[NSString stringWithUTF8String:protocolName]];
    }
    
    free(protocolList);
    
    return [NSArray arrayWithArray:mutableList];
}

#pragma mark - getter setter
- (NSMutableDictionary *)allServicesDict
{
    if (!_allServicesDict) {
        _allServicesDict = [NSMutableDictionary dictionary];
    }
    return _allServicesDict;
}

- (NSRecursiveLock *)lock
{
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

- (NSDictionary *)servicesDict
{
    [self.lock lock];
    NSDictionary *dict = [self.allServicesDict copy];
    [self.lock unlock];
    return dict;
}
@end
