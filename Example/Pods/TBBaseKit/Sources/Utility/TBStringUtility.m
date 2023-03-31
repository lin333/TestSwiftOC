//
//  TBStringUtility.m
//  TBBaseKit
//
//  Created by zhengzhiwen on 2021/6/9.
//

#import "TBStringUtility.h"
#import <TBBaseKit/TBBaseUtility.h>
#import <TBBaseKit/TBStringUtility.h>
#import <CommonCrypto/CommonDigest.h>
#import <TBBaseKit/TBPhoneUtility.h>
#import "NSString+TBProcess.h"
#import "TBLanguageManager.h"

@implementation TBStringUtility

+ (BOOL)hasNonEnglishCharacter:(NSString *)text
{
    if (!text || text.length == 0) {
        return NO;
    }
    for (int i = 0; i < text.length; i++) {
        NSRange range = NSMakeRange(i,1);
        NSString *subString = [text substringWithRange:range];
        const char *ctring = [subString UTF8String];
        if (strlen(ctring) != 1) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)getMd5String:(NSString *)input
{
    const char *cStr = [input UTF8String];
    int len = (int)strlen(cStr);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, len, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSInteger)minitesOffset:(NSString *)target
{
    NSRange range = [target rangeOfString:@":"];
    if (range.location == NSNotFound) {
        return 0;
    }
    NSString *prefix = [target substringToIndex:range.location];
    NSInteger hour = [prefix integerValue];
    NSString *postfix = [target substringFromIndex:range.location + 1];
    NSInteger minite = [postfix integerValue];
    return (hour - 9)* 60 + minite - 30;
}

+ (NSInteger)minitesOffsetZero:(NSString *)target
{
    NSRange range = [target rangeOfString:@":"];
    if (range.location == NSNotFound) {
        return 0;
    }
    NSString *prefix = [target substringToIndex:range.location];
    NSInteger hour = [prefix integerValue];
    NSString *postfix = [target substringFromIndex:range.location + 1];
    NSInteger minite = [postfix integerValue];
    return hour * 60 + minite;
}

+ (NSString *)nextMonth:(NSString *)dateString
{
    if (dateString.length != 6) {
        return @"";
    }
    NSString *year = [dateString substringToIndex:4];
    NSString *month = [dateString substringFromIndex:4];
    NSInteger nextMonth = [month integerValue];
    NSInteger nextYear = [year integerValue];
    NSString *nextMonthString = @"01";
    if ([month integerValue] == 12) {
        nextMonthString = @"01";
        nextYear = [year integerValue] + 1;
        return [NSString stringWithFormat:@"%ld%@",(long)nextYear, nextMonthString];
    }else{
        nextMonth = [month integerValue] + 1;
        if (nextMonth>=10) {
            return [NSString stringWithFormat:@"%ld%ld",(long)nextYear, (long)nextMonth];
        }else{
            return [NSString stringWithFormat:@"%ld0%ld", (long)nextYear, (long)nextMonth];
        }
    }
}

+ (NSString *)transferEngMsg2Chn:(NSString *)msg
{
    NSString *marketNotOpenPattern = @"your order will not be placed at the exchange until";
    NSRange range = [msg rangeOfString:marketNotOpenPattern options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        NSString *subString = [msg substringFromIndex:range.location + range.length];
        NSString *US = @"US/Eastern";
        NSRange tmpRange = [subString rangeOfString:US options:NSRegularExpressionSearch];
        if (tmpRange.location != NSNotFound) {
            subString = [subString substringToIndex:tmpRange.location];
        }
        NSString *result = [NSString stringWithFormat:TBResourcesLocalizedString(@"mobile_ios_common_during_nontrading_hours_orders_will", nil), subString];
        return result;
    }
    return msg;
}

+ (NSString*)subStringLength:(NSInteger)length string:(NSString*)string {
    return [self subStringLength:length string:string hasSuff:YES];
    
}

+ (NSString *)subStringLength:(NSInteger)length string:(NSString *)string hasSuff:(BOOL)hasSuff {
    NSMutableString *subsymbolCN = [NSMutableString string];
    int j = 0;
    for (int i = 0; i < string.length; i++) {
        NSRange range=NSMakeRange(i,1);
        NSString *subString=[string substringWithRange:range];
        if (!TextValid(subString)) {
            continue;
        }
        const char *ctring = [subString UTF8String];
        if (strlen(ctring) == 3) {
            // 汉字
            j += 2;
        } else if (strlen(ctring) == 1) {
            // 字母
            j += 1;
        }
        [subsymbolCN appendString:subString];
        if (j >= length) {
            break;
        }
    }
    if (hasSuff) {
        if (string.length > subsymbolCN.length) {
            [subsymbolCN appendString:@"..."];
        }
    }
    return subsymbolCN;
}

+ (int)countTheStrLength:(NSString *)string {
    int j = 0;
    for (int i = 0; i < string.length; i++) {
        NSRange range=NSMakeRange(i,1);
        NSString *subString=[string substringWithRange:range];
        if (!TextValid(subString)) {
            continue;
        }
        const char *ctring = [subString UTF8String];
        if (strlen(ctring) == 3) {
            // 汉字
            j += 2;
        } else if (strlen(ctring) == 1) {
            // 字母
            j += 1;
        }
    }
    
    return j;
}

+ (CGSize)getStringRectWithFont:(NSString *)text withFont:(UIFont *)font
{
    CGSize expectedSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    return expectedSize;
}

+ (NSString *)convertStringFromArray:(NSArray *)array {
    if (!array || [array isEqual:[NSNull null]] || array.count == 0) {
        return @"";
    }else{
        return [array componentsJoinedByString:@","];
    }
}

+ (NSArray *)convertArrayFromString:(NSString *)string {
    return TextValid(string) ? [string componentsSeparatedByString:@","] : @[];
}

+ (BOOL)isCorrectEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:email];
}

+ (NSString *)decimalSeparator {
    NSString *decimalSeparator;
    if (TB_IS_UNDER_IOS10) {
        decimalSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    } else {
        decimalSeparator = [NSLocale currentLocale].decimalSeparator;
    }
    return decimalSeparator;
}

+ (CGFloat)getString:(NSString *)string lineSpacing:(CGFloat)lineSpacing font:(UIFont*)font width:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpacing;
    NSDictionary *dic = @{ NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle };
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return  ceilf(size.height);
}

+ (NSDate *)dateWithString:(NSString *)dateString formatString:(NSString *)formatString timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {

    static NSDateFormatter *parser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parser = [[NSDateFormatter alloc] init];
    });

    parser.dateStyle = NSDateFormatterNoStyle;
    parser.timeStyle = NSDateFormatterNoStyle;
    parser.timeZone = timeZone;
    parser.dateFormat = formatString;
    parser.locale = locale;
    return [parser dateFromString:dateString];
}

+ (BOOL)isInvalidString:(NSString *)string {
    return (!TextValid(string) || [string hasPrefix:@"{"] || [string hasPrefix:@"["] || [string hasSuffix:@"]"] || string.length > 200 || [string containsString:@"<html>"]);
}


@end
