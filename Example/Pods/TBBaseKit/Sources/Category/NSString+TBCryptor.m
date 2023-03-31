//
//  NSString+TBCryptor.m
//  TigerToken
//
//  Created by chenxin on 2018/8/2.
//  Copyright © 2018年 TigerBrokers. All rights reserved.
//

#import "NSString+TBCryptor.h"
#import "AESCipher.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (TBCryptor)

- (NSString *)cryptKey {
    return @"com.tigerbrokers";
}

- (NSString *)tb_encryptString:(BOOL)useECB {
    NSString *key = [self cryptKey];
    return aesEncryptString(self, key, useECB);
}

- (NSString *)tb_decryptString:(BOOL)useECB {
    NSString *key = [self cryptKey];
    return aesDecryptString(self, key, useECB);
}

- (NSString *)tb_encryptStringWithECB {
    NSString *key = [self cryptKey];
    return aesEncryptString(self, key, YES);
}

- (NSString *)tb_decryptStringWithECB {
    NSString *key = [self cryptKey];
    return aesDecryptString(self, key, YES);
}

- (NSString *)tb_encryptStringNOECB {
    NSString *key = [self cryptKey];
    return aesEncryptString(self, key, NO);
}

- (NSString *)tb_decryptStringNOECB {
    NSString *key = [self cryptKey];
    return aesDecryptString(self, key, NO);
}

/**
 *  AES加密
 *
 *  @param keyString 加密密钥
 *  @param iv        初始化向量(8个字节)
 *
 *  @return 返回加密后的base64编码字符串
 */
- (NSString *)tb_aesEncryptString:(NSString *)keyString iv:(NSData *)iv {
   // 设置秘钥
   NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
   uint8_t cKey[kCCKeySizeAES128];
   bzero(cKey, sizeof(cKey));
   [keyData getBytes:cKey length:kCCKeySizeAES128];
   
   // 设置iv
   uint8_t cIv[kCCBlockSizeAES128];
   bzero(cIv, kCCBlockSizeAES128);
   int option = 0;
   if (iv) {
       [iv getBytes:cIv length:kCCBlockSizeAES128];
       option = kCCOptionPKCS7Padding;
   } else {
       option = kCCOptionPKCS7Padding | kCCOptionECBMode;
   }
   
   // 设置输出缓冲区
   NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
   size_t bufferSize = [data length] + kCCBlockSizeAES128;
   void *buffer = malloc(bufferSize);
   
   // 开始加密
   size_t encryptedSize = 0;
   
   /**
    @constant   kCCAlgorithmAES     高级加密标准，128位(默认)
    @constant   kCCAlgorithmDES     数据加密标准
    */
   CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                         kCCAlgorithmAES,
                                         option,
                                         cKey,
                                         kCCKeySizeAES128,
                                         cIv,
                                         [data bytes],
                                         [data length],
                                         buffer,
                                         bufferSize,
                                         &encryptedSize);
   
   NSData *result = nil;
   if (cryptStatus == kCCSuccess) {
       result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
   }
   else {
       free(buffer);
   }
   
   return [result base64EncodedStringWithOptions:0];
}

/**
 *  AES解密
 *
 *  @param keyString 解密密钥
 *  @param iv        初始化向量(8个字节)
 *
 *  @return 返回解密后的字符串
 */
- (NSString *)tb_aesDecryptString:(NSString *)keyString iv:(NSData *)iv {
   // 设置秘钥
   NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
   uint8_t cKey[kCCKeySizeAES128];
   bzero(cKey, sizeof(cKey));
   [keyData getBytes:cKey length:kCCKeySizeAES128];
   
   // 设置iv
   uint8_t cIv[kCCBlockSizeAES128];
   bzero(cIv, kCCBlockSizeAES128);
   int option = 0;
   if (iv) {
       [iv getBytes:cIv length:kCCBlockSizeAES128];
       option = kCCOptionPKCS7Padding;
   } else {
       option = kCCOptionPKCS7Padding | kCCOptionECBMode;
   }
   
   // 设置输出缓冲区，options参数很多地方是直接写0，但是在实际过程中可能出现回车的字符串导致解不出来
   NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
   
   size_t bufferSize = [data length] + kCCBlockSizeAES128;
   void *buffer = malloc(bufferSize);
   
   // 开始解密
   size_t decryptedSize = 0;
   CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                         kCCAlgorithmAES128,
                                         option,
                                         cKey,
                                         kCCKeySizeAES128,
                                         cIv,
                                         [data bytes],
                                         [data length],
                                         buffer,
                                         bufferSize,
                                         &decryptedSize);
   
   NSData *result = nil;
   if (cryptStatus == kCCSuccess) {
       result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
   } else {
       free(buffer);
   }
   
   return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}
@end
