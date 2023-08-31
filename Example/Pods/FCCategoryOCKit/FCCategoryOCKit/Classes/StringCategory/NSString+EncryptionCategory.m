//
//  NSString+EncryptionCategory.m
//  FCCategory
//
//  Created by Ganggang Xie on 2019/3/12.
//

#import "NSString+EncryptionCategory.h"
#import <CommonCrypto/CommonDigest.h>
//
#import "NSString+BaseCategory.h"



//crypto ['krɪptəʊ]  密码
//encryption [ɪn'krɪpʃn] 加密
//digest  [daɪˈdʒest] 文摘
@implementation NSString (EncryptionCategory)

- (NSString *)fc_md5{
    const char *fooData = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    NSMutableString *saveResult = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    return [saveResult uppercaseString];
}


@end
