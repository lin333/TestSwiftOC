//
//  TBBuildConfigureManager.m
//  TBBaseKit
//
//  Created by linbingjie on 2021/1/28.
//

#import "TBBuildConfigureManager.h"

@interface TBBuildConfigureManager ()

@property (nonatomic, assign, readwrite) TBBuildConfigStyle buildType;
@property (nonatomic, assign, readwrite) TBProjectType projectType;
@property (nonatomic, copy, readwrite) NSString *keyChainService;

@property (nonatomic, assign) BOOL hasSetUp; // 用本字段获取是否调用setup逻辑了
@end

@implementation TBBuildConfigureManager

IMPLEMENT_SHARED_INSTANCE(TBBuildConfigureManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.buildType = TBBuildConfigStyleRelease;
        self.projectType = TBProjectTypeUnknown;
        self.hasSetUp = NO;
    }
    return self;
}

- (void)setupBuildConfiguration:(TBBuildConfigStyle)buildType {
    self.hasSetUp = YES;
    self.buildType = buildType;
}

- (void)setupProjectConfiguration:(TBProjectType)projectType {
    self.projectType = projectType;
}

- (void)setupKeyChainStoreWithService:(NSString *)service {
    self.keyChainService = service;
}

- (TBBuildConfigStyle)buildType {
    if (!self.hasSetUp) {
        NSAssert(NO, @"尚未初始化，默认为release");
        return TBBuildConfigStyleRelease;
    }
    else {
        return _buildType;
    }
}

- (TBProjectType)projectType {
    if (_projectType == TBProjectTypeUnknown) {
        NSAssert(NO, @"尚未初始化项目类型");
        return _projectType;
    }
    else {
        return _projectType;
    }
}

- (BOOL)isDebugStyle {
    if (self.buildType == TBBuildConfigStyleDebug) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isDebugOrTestStyle {
    
    if (self.buildType == TBBuildConfigStyleDebug || self.buildType == TBBuildConfigStyleTest) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isReleaseStyle {
    if (self.buildType == TBBuildConfigStyleRelease) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
