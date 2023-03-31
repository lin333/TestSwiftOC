//
//  StringUtil.m

#import "TBBaseUtility.h"

// http://www.wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html
static inline BOOL IsEmpty(id thing) {
	return thing == nil ||
	([thing isEqual:[NSNull null]]) ||
	([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
	([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}

@implementation NSString (TBProcess)

- (NSString *)trimmedString
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)htmlDecodedString
{
	NSMutableString *temp = [NSMutableString stringWithString:self];
	
	[temp replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"&apos;" withString:@"'" options:0 range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&nbsp;" withString:@" " options:0 range:NSMakeRange(0, [temp length])];
	
	return [NSString stringWithString:temp];
}

- (NSString *)htmlEncodedString
{
	NSMutableString *temp = [NSMutableString stringWithString:self];
	
	[temp replaceOccurrencesOfString:@"&" withString:@"&amp;" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@">" withString:@"&gt;" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"<" withString:@"&lt;" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"'" withString:@"&apos;" options:0 range:NSMakeRange(0, [temp length])];
	return [NSString stringWithString:temp];
}


- (NSString *)spac32FromString{
    NSMutableString *newStr = [NSMutableString string];
    for (int i=0; i<self.length; i++) {
        NSString *charStr = [self substringWithRange:NSMakeRange(i, 1)];
        char space = [self characterAtIndex:i];
        int codeIndex = space;
        if (codeIndex == 160) {
            [newStr appendString:@" "];
        }else{
            [newStr appendString:charStr];
        }
    }
    return newStr;
}

- (NSString *)stringByDeletingWhitespaceCharacters {
    return [self stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (NSString *)stringValue {
    return self;
}

@end

@implementation NSString  (RangeAvoidance)
- (BOOL) hasSubstring:(NSString*)substring
{
	if(IsEmpty(substring))
		return NO;
	NSRange substringRange = [self rangeOfString:substring];
	return substringRange.location != NSNotFound && substringRange.length > 0;
}

- (NSString*) substringAfterSubstring:(NSString*)substring
{
	if([self hasSubstring:substring])
		return [self substringFromIndex:NSMaxRange([self rangeOfString:substring])];
	return nil;
}

//Note: -isCaseInsensitiveLike should work when avalible!
- (BOOL)isEqualToStringIgnoringCase:(NSString*)otherString
{
    if(!otherString) {
        return NO;
    }
    return NSOrderedSame == [self compare:otherString options:NSCaseInsensitiveSearch | NSWidthInsensitiveSearch];
}
@end


@implementation NSString (IndempotentPercentEscapes)

-(CGRect)txtFrameWith:(UIFont *)font andMaxWidth:(CGFloat)maxW{
    return [self boundingRectWithSize:CGSizeMake(maxW, 10000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
}
-(CGRect)txtFrameWith:(UIFont *)font lineSpacing:(CGFloat)spacing andMaxWidth:(CGFloat)maxW{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = spacing;// 字体的行间距
    return [self boundingRectWithSize:CGSizeMake(maxW, 10000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil] context:nil];
}

-(CGRect)getTextFrame:(UIFont *)font andMaxWidth:(CGFloat)maxW{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    return [self boundingRectWithSize:CGSizeMake(maxW, 10000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil] context:nil];
}

//手机号码验证
- (BOOL) validateMobile
{
    //手机号以13,15,18,17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (NSString *)htmlConDelete{
    if (!self) {
        return self;
    }
    NSMutableString *muString = [NSMutableString stringWithString:self];
    NSString *regexStr = @"<([^>]*)>";
    NSRegularExpression *regexExp = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
    NSArray *matches = [regexExp matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    NSMutableArray *arrMatchStr = [NSMutableArray array];
    NSRange range[10] ={};
    int i = 0;
    
    for (NSTextCheckingResult *result in [matches objectEnumerator]) {
        NSRange matchRange = [result range];
        range[i] = matchRange;
        NSString *matchStr = [muString substringWithRange:matchRange];
        [arrMatchStr addObject:matchStr];
        i++;
    }
    
    for (int i=0; i<arrMatchStr.count; i++) {
        [muString replaceOccurrencesOfString:arrMatchStr[i] withString:@"" options:0 range:NSMakeRange(0, [muString length])];
    }
    return muString;
}

@end

@implementation NSString (OpenAccountCheck)

- (NSString *)stringByRemovingHtmlTag {
    NSString *ret = [self copy];
    NSRange range;
    while ((range = [ret rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        ret = [ret stringByReplacingCharactersInRange:range withString:@""];
    }
    return ret;
}

- (BOOL)tb_isSupportedPasswordChar {
    NSString *pattern = @"^[\\u0021-\\u007E]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)tb_isPureNumber {
    NSString *pattern = @"^[0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)tb_isPureLetter {
    NSString *pattern = @"^[A-Za-z]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)tb_isPureCharacter {
    NSString *pattern = @"^[\\u0021-\\u002F\\u003A-\\u0040\\u005B-\\u0060\\u007B-\\u007E]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)tb_isPureNumberOrLetter {
    NSString *pattern = @"^[A-Za-z0-9.,+-]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)tb_isPureFuturesPrice {
    NSString *patternString = [NSString stringWithFormat:@"^[+-]?[0-9]*[\\%@']?[0-9]*%?$", [NSLocale currentLocale].decimalSeparator];
    
    return [self tb_isLegalObjectWithPattern:patternString];
}

- (BOOL)tb_isLegalObjectWithPattern:(NSString *)pattern {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

@end

@implementation NSString (TBAddition)

+ (NSString *)changeFloatWithFloat:(CGFloat)floatValue
{
    return [NSString changeFloatWithString:[NSString stringWithFormat:@"%f",floatValue]];
}
+ (NSString *)changeFloatWithString:(NSString *)stringFloat
{
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    NSInteger i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0') {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}

- (NSString *)matchResultWithPattern:(NSString *)pattern
{
    NSError *rError;
    
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&rError];
    
    if (rError)
    {
        NSLog(@"%@", rError.userInfo);
        
        return nil;
    }
    
    NSTextCheckingResult *textCheckingResult = [regularExpression firstMatchInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
    
    if (textCheckingResult.numberOfRanges > 0)
    {
        NSRange range = [textCheckingResult rangeAtIndex:0];
        
        if (range.location != NSNotFound && range.length <= self.length)
        {
            return [self substringWithRange:range];
        }
    }
    
    return nil;
}

- (NSString *)tb_toSpelling
{
    if (self.length) {
        NSMutableString *copy = [self mutableCopy];
        @try {
            CFStringTransform((__bridge CFMutableStringRef)copy, NULL, kCFStringTransformMandarinLatin, NO); // 得到带音调的拼音
            CFStringTransform((__bridge CFMutableStringRef)copy, NULL, kCFStringTransformStripDiacritics, NO); // 过滤掉音调 每个汉字之间会用空格分开
            if ([copy length]) {
                [copy replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, copy.length)]; // 过滤掉空格
            }
        } @catch (NSException *exception) {
            copy = [self mutableCopy];
        } @finally {
            return copy;
        }
        
    }
    else {
        return nil;
    }
}

@end
