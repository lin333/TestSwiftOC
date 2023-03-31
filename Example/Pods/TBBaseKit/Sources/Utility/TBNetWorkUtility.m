//
//  TBNetWorkUtility.m
//  TBBaseKit
//
//  Created by linbingjie on 2021/2/18.
//

#import "TBNetWorkUtility.h"
#import "TBLanguageManager.h"
#import "TBBaseUtility.h"

@implementation TBNetWorkUtility

+ (NSString *)getUrlEncodeString:(NSString *)content
{
    static NSString *abcString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    NSMutableCharacterSet *charSet = [NSMutableCharacterSet characterSetWithCharactersInString:abcString];
    NSString *result = [content stringByAddingPercentEncodingWithAllowedCharacters:charSet];
    return result;
}

+ (NSDictionary*)queryDictionaryUsingEncoding:(NSString *)query encoding:(NSStringEncoding)encoding
{
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0] stringByRemovingPercentEncoding];
            NSString* value = [[kvPair objectAtIndex:1] stringByRemovingPercentEncoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr
{
    
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

//将Dictionary转为URL类型参数
+ (NSString *)covertDictionaryToURLParameters:(NSDictionary *)dictionary
{
    NSMutableString * string = [NSMutableString string];
    if(!dictionary){
        return nil;
    }
    for(NSInteger i = 0;i < dictionary.allKeys.count;i++){
        NSString * key = dictionary.allKeys[i];
        id value = dictionary[key];
        if(i > 0){
            [string appendString:@"&"];
        }
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *values = (NSArray *)value;
            for (int j = 0; j < values.count; j ++) {
                if (j > 0) {
                    [string appendString:@"&"];
                }
                id item = values[j];
                [string appendString:key];
                [string appendString:@"="];
                [string appendString:[NSString stringWithFormat:@"%@",item]];
            }
        } else {
            [string appendString:key];
            [string appendString:@"="];
            [string appendString:[NSString stringWithFormat:@"%@",dictionary[key]]];
        }
    }
    return string;
}

+ (NSString *)getNetWorkingErrorHintText:(NSError *)error {
    if (!error) {
        return @"";
    }
    NSInteger errorCode = error.code;
    NSString *result = @"";
    switch (errorCode) {
        case NSURLErrorTimedOut:
            result = TBResourcesLocalizedString(@"mobile_ios_common_connection_timed_out", nil);
            break;
        case NSURLErrorCannotFindHost:
            result = TBResourcesLocalizedString(@"mobile_ios_common_unable_to_resolve_server_addres", nil);
            break;
        case NSURLErrorCannotConnectToHost:
            result = TBResourcesLocalizedString(@"mobile_ios_common_unable_to_connect_to_serve", nil);
            break;
        case NSURLErrorNotConnectedToInternet:
            result = TBResourcesLocalizedString(@"mobile_ios_common_network_is_not_available_please", nil);
            break;
        default:
            if (error.localizedDescription.length > 0) {
                result = error.localizedDescription;
            }
            else {
                result = TBResourcesLocalizedString(@"mobile_ios_common_service_is_temporarily_unavailable", nil);
            }
            break;
    }
    
    return [NSString stringWithFormat:@"%@ [%ld]", result, errorCode];
}

+ (NSString *)messageFromErrorObject:(NSError *)error errorKey:(NSString *)errorKey {
    NSString * errorMsg = nil;
    NSData *errData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    if (errData) {
        NSDictionary *errDict = [NSJSONSerialization JSONObjectWithData:errData options:NSJSONReadingAllowFragments error:nil];
        if ([errDict isKindOfClass:[NSDictionary class]]) {
            errorMsg = [errDict objectForKey:errorKey];
        }
    } else {
        errorMsg = [self getNetWorkingErrorHintText:error];
    }
    return errorMsg;
}

+ (NSString *)tbutilscovert_toString:(id)obj {
    if (obj && ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]])) {
        return [obj description];
    } else {
        return @"";
    }
}

+ (NSDictionary *)tbutilscovert_toDictionaryOrNil:(id)obj {
    if (![obj isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return obj;
}

+ (NSArray *)tbutilscovert_toArrayOrNil:(id)obj {
    if (![obj isKindOfClass:[NSArray class]]) {
        return nil;
    }
    return obj;
}

+ (NSString *)messageFromErrorObject:(NSError *)error defaultMessage:(nullable NSString *)message
{
    NSString * errorMsg = nil;
    NSData *errData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    if (errData) {
        NSDictionary *errDict = [NSJSONSerialization JSONObjectWithData:errData options:NSJSONReadingAllowFragments error:nil];
        if ([errDict isKindOfClass:[NSDictionary class]]) {
            NSInteger status = [[errDict objectForKey:@"status"] integerValue];
            NSInteger code = [[errDict objectForKey:@"code"] integerValue];
            
            if (status >= 400 || code >= 400)
            {
                errorMsg = [errDict objectForKey:@"message"];
            }
        }
    }else{
        errorMsg = [TBNetWorkUtility getNetWorkingErrorHintText:error];
    }
    
    if (!TextValid(errorMsg)) {
        errorMsg = message;
    }
    return errorMsg;
}


/**
 部分接口返回的状态码不是200，AFNetworking会序列化错误，错误信息需要单独处理
 */
+ (NSString *)failureMsgWithError:(NSError *)error {
    NSString *errorMsg;
    NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    if (errorData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
        if (dict) {
            errorMsg = dict[@"msg"];
        }
        //接口不存在
        if (!TextValid(errorMsg)) {
            errorMsg = dict[@"message"];
        }
    }
    
    if (!TextValid(errorMsg)) {
        errorMsg = [TBNetWorkUtility getNetWorkingErrorHintText:error];
    }
    if (!TextValid(errorMsg)) {
        errorMsg = TBResourcesLocalizedString(@"mobile_ios_common_service_is_temporarily_unavailable", nil);
    }
    return errorMsg;
}

+ (NSString *)getNetWorkingErrorHintMessage:(NSError *)error
{
    if(!error){
        return @"";
    }
    NSInteger errorCode = error.code;
    NSString *result = @"";
    switch (errorCode) {
        case NSURLErrorTimedOut:
            result = TBResourcesLocalizedString(@"mobile_ios_common_connection_timed_out_please_refresh", nil);
            break;
        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorBadServerResponse:
            result = TBResourcesLocalizedString(@"mobile_ios_common_connection_failed_please_refresh_the", nil);
            break;
        case NSURLErrorNotConnectedToInternet:
            result = TBResourcesLocalizedString(@"mobile_ios_common_network_is_not_available_please", nil);
            break;
        default:
            if (error.localizedDescription.length > 0) {
                result = [NSString stringWithFormat:@"%@ [%ld]",error.localizedDescription, (long)error.code];
            }
            else {
                result = [NSString stringWithFormat:@"%@ [%ld]", TBResourcesLocalizedString(@"mobile_ios_common_service_is_temporarily_unavailable", nil), (long)error.code];
            }
            break;
    }
    return result;
}

@end
