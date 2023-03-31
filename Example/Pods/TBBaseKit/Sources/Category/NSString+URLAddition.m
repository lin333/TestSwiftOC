//
//  NSString+URLAddition.m
//  TBBaseKit
//
//  Created by zhengzhiwen on 2021/6/9.
//

#import "NSString+URLAddition.h"
#import "TBBaseUtility.h"
#import "TBNetWorkUtility.h"

@implementation NSString (URLAddition)

- (NSString *)tb_stringByAddingParameterKey:(NSString *)key value:(NSString *)value {
    if (!TextValid(key) || !TextValid(value) || !TextValid(self)) {
        return self;
    }
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:self];
    // 避免参数重复添加
    NSArray *queryItems = components.queryItems != nil ? components.queryItems : [NSArray array];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSURLQueryItem *item in queryItems) {
        if ([item.name isEqualToString:key]) {
            continue;
        }
        [items addObject:item];
    }
    
    NSURLQueryItem *newItem = [NSURLQueryItem queryItemWithName:key value:value];
    [items addObject:newItem];
    [components setQueryItems:items];

    NSString *result = components.string;
    
    if (!TextValid(result)) {// 避免为空
        NSRange range = [self rangeOfString:@"?"];
        if (range.location == NSNotFound) {
            NSRange rangOfHashTag = [self rangeOfString:@"#"];
            NSString *resultStr = nil;
            if (rangOfHashTag.location == NSNotFound) {
                resultStr = [self stringByAppendingFormat:@"?%@=%@", key, value];
            } else {
                NSMutableString *mutStr = [self mutableCopy];
                [mutStr insertString:[NSString stringWithFormat:@"?%@=%@", key, value] atIndex:rangOfHashTag.location];
                resultStr = [mutStr copy];
            }
            return resultStr;
        } else {
            NSString *keyVaStr = [NSString stringWithFormat:@"%@=%@", key, value];
            NSMutableString *resultString = [self mutableCopy];
            if (range.location == self.length - 1) {
                [resultString stringByAppendingString:keyVaStr];
            } else {
                [resultString insertString:[keyVaStr stringByAppendingString:@"&"] atIndex:range.location+1];
            }
            return [resultString copy];
        }
    }
    return result;
}

- (NSString *)tb_stringByAddingInviteCodeIfNeeded:(NSString *)inviteCode {
    if (!TextValid(self) || !TextValid(inviteCode)) {
        return self;
    }
    
    NSString *inviteCodeParameterKey = @"invite";
    NSDictionary *parameters = [TBNetWorkUtility getURLParameters:self];
    if (parameters[inviteCodeParameterKey]) {
        return self;
    } else {
        return [self tb_stringByAddingParameterKey:inviteCodeParameterKey value:inviteCode];
    }
}

- (NSString *)tb_stringByAddingShareUtmSource:(NSString *)utmSource {
    if (!TextValid(self) || !TextValid(utmSource)) {
        return self;
    }
    
    NSString *utmSourceParameterKey = @"utm_source";
    NSDictionary *parameters = [TBNetWorkUtility getURLParameters:self];
    if (parameters[utmSourceParameterKey]) {
        return self;
    } else {
        return [self tb_stringByAddingParameterKey:utmSourceParameterKey value:utmSource];
    }
}

- (NSString *)tb_stringByAddingShareTypeIfNeeded:(NSString *)shareType {
    if (!TextValid(self) || !TextValid(shareType)) {
        return self;
    }
    NSString *shareTypeParameterKey = @"share";
    NSDictionary *parameters = [TBNetWorkUtility getURLParameters:self];
    if (parameters[shareTypeParameterKey]) {
            if (parameters[@"utm_medium"]) {
                // 更新utm_medium，可能为H5传过来的默认值
                NSString *string = [self stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"utm_medium=%@", parameters[@"utm_medium"]] withString:@""];
                if (![parameters[shareTypeParameterKey] isEqualToString:shareType]) {
                    string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"share=%@", parameters[shareTypeParameterKey]] withString:@""];
                    string = [string tb_stringByAddingParameterKey:shareTypeParameterKey value:shareType];
                }
                return [string tb_stringByAddingParameterKey:@"utm_medium" value:shareType];
            }
            return [self tb_stringByAddingParameterKey:@"utm_medium" value:shareType];
        } else {
            if (parameters[@"utm_medium"]) {
                // 更新utm_medium，可能为H5传过来的默认值
                NSString *string = [[self stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"utm_medium=%@", parameters[@"utm_medium"]] withString:@""] tb_stringByAddingParameterKey:@"utm_medium" value:shareType];
                return [string tb_stringByAddingParameterKey:shareTypeParameterKey value:shareType];
            }
            return [[self tb_stringByAddingParameterKey:shareTypeParameterKey value:shareType] tb_stringByAddingParameterKey:@"utm_medium" value:shareType];

    }
}

- (NSString *)tb_stringByAddingFeatureTypeIfNeeded:(NSString *)feature {
    if (!TextValid(self) || !TextValid(feature)) {
        return self;
    }
    NSString *featureParameterKey = @"feature";
    NSDictionary *parameters = [TBNetWorkUtility getURLParameters:self];
    if (parameters[featureParameterKey]) {
        return self;
    } else {
        return [self tb_stringByAddingParameterKey:featureParameterKey value:feature];
    }
}

- (BOOL)isURL {
    if(self.length < 1)
        return NO;
    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:self];
}

- (NSArray*)getURLFromStr {
    NSError *error;
    //可以识别url的正则表达式
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
    options:NSRegularExpressionCaseInsensitive
    error:&error];

    NSArray *arrayOfAllMatches = [regex matchesInString:self
    options:0
    range:NSMakeRange(0, [self length])];

    //NSString *subStr;
    NSMutableArray *arr=[[NSMutableArray alloc] init];

    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString* substringForMatch;
        substringForMatch = [self substringWithRange:match.range];
        [arr addObject:substringForMatch];
    }
    return arr;
}
@end
