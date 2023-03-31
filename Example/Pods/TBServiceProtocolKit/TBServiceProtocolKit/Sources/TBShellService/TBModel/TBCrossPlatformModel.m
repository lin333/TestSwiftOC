//
//  TBCrossPlatformModel.m
//  Pods
//
//  Created by linbingjie on 2021/7/12.
//

#import "TBCrossPlatformModel.h"

@interface TBCrossPlatformModel ()

@property (nonatomic, copy, readwrite) NSString *action;
@property (nonatomic, copy, readwrite) NSDictionary *params;

@end

@implementation TBCrossPlatformModel

- (instancetype)initWithTargetAction:(nonnull NSString *)action params:(nullable NSDictionary *)params
{
    self = [super init];
    if (self) {
        self.action = action;
        self.params = params;
    }
    return self;
}

@end
