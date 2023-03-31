//
//  NSData+Extension.m
//  Stock
//
//  Created by WCP on 2018/10/18.
//  Copyright © 2018年 com.tigerbrokers. All rights reserved.
//

#import "NSData+Extension.h"

@implementation NSData (Extension)

- (NSString *)UTF8String
{
    NSString *string = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    return string;
}

- (id)initWithBase64String:(NSString *)base64String
{
    return  [[NSData alloc] initWithBase64EncodedString:base64String options:0];
}

- (NSString *)base64EncodedString
{
    return [self base64EncodedStringWithOptions:0];
}

@end
