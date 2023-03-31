//
// SAConfigOptions+Encrypt.m
// SensorsAnalyticsSDK
//
// Created by wenquan on 2021/6/26.
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

#import "SAConfigOptions+Encrypt.h"

@interface SAConfigOptions ()

@property (atomic, strong, readwrite) NSMutableArray *encryptors;
@property (nonatomic, assign) BOOL enableEncrypt;
@property (nonatomic, copy) void (^saveSecretKey)(SASecretKey * _Nonnull secretKey);
@property (nonatomic, copy) SASecretKey * _Nonnull (^loadSecretKey)(void);

@end

@implementation SAConfigOptions (Encrypt)

- (void)registerEncryptor:(id<SAEncryptProtocol>)encryptor {
    if (![self isValidEncryptor:encryptor]) {
        NSString *format = @"\n You used a custom encryption plugin [ %@ ], but no encryption protocol related methods are implemented. Please correctly implement the related functions of the custom encryption plugin before running the project. \n";
        NSString *message = [NSString stringWithFormat:format, NSStringFromClass(encryptor.class)];
        NSAssert(NO, message);
        return;
    }
    if (!self.encryptors) {
        self.encryptors = [[NSMutableArray alloc] init];
    }
    [self.encryptors addObject:encryptor];
}

- (BOOL)isValidEncryptor:(id<SAEncryptProtocol>)encryptor {
    return ([encryptor respondsToSelector:@selector(symmetricEncryptType)] &&
            [encryptor respondsToSelector:@selector(asymmetricEncryptType)] &&
            [encryptor respondsToSelector:@selector(encryptEvent:)] &&
            [encryptor respondsToSelector:@selector(encryptSymmetricKeyWithPublicKey:)]);
}

@end
