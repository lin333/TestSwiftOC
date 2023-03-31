//
//  NSString+TBChinese.m
//  Stock
//
//  Created by Tiger on 2018/12/17.
//  Copyright © 2018年 com.tigerbrokers. All rights reserved.
//

#import "NSString+TBChinese.h"

@implementation NSString (TBChinese)
- (BOOL)tb_isChinese:(TBNSStringChineseType)type {
    NSMutableString *regex = [NSMutableString stringWithString:[self _tb_ChineseRegex:type]];
    if (!regex || !regex.length) return NO;
    
    [regex insertString:@"^" atIndex:0];
    [regex appendString:@"$"];
    return [self _tb_matchesRegex:regex.copy options:0];
}

#pragma mark - Private methods
- (NSString *)_tb_ChineseRegex:(TBNSStringChineseType)type {
    NSMutableString *regex = [NSMutableString stringWithString:@""];
    
    TBNSStringChineseType aType = type ? type : TBNSStringChineseTypeAll;
    if (aType & TBNSStringChineseTypeCharacter) {
        [regex appendString:[self _tb_ChineseCharactersRegex]];
    }
    
    if (aType & TBNSStringChineseTypePunctuation) {
        [regex appendString:[self _tb_ChinesePunctuationsRegex]];
    }
    
    if (aType & TBNSStringChineseTypeRadical) {
        [regex appendString:[self _tb_ChineseRadicalsRegex]];
    }
    
    if (aType & TBNSStringChineseTypeStroke) {
        [regex appendString:[self _tb_ChineseStrokesRegex]];
    }
    
    if (aType & TBNSStringChineseTypeIdeographicDescription) {
        [regex appendString:[self _tb_ChineseIdeographicDescriptionsRegex]];
    }
    
    if (!regex.length) return regex;
    
    [regex insertString:@"[" atIndex:0];
    [regex appendString:@"]"];
    return regex.copy;
}

- (NSString *)_tb_ChineseCharactersRegex {
    /*
     https://zh.wikipedia.org/wiki/%E4%B8%AD%E6%97%A5%E9%9F%93%E7%B5%B1%E4%B8%80%E8%A1%A8%E6%84%8F%E6%96%87%E5%AD%97
     https://zh.wikipedia.org/wiki/Wikipedia:Unicode%E6%89%A9%E5%B1%95%E6%B1%89%E5%AD%97
     https://zh.wikipedia.org/wiki/%E4%B8%AD%E6%97%A5%E9%9F%93%E7%9B%B8%E5%AE%B9%E8%A1%A8%E6%84%8F%E6%96%87%E5%AD%97
     https://zh.wikipedia.org/wiki/%E4%B8%AD%E6%97%A5%E9%9F%93%E7%9B%B8%E5%AE%B9%E8%A1%A8%E6%84%8F%E6%96%87%E5%AD%97%E8%A3%9C%E5%85%85%E5%8D%80
     
     https://en.wikipedia.org/wiki/CJK_Unified_Ideographs_(Unicode_block)
     https://en.wikipedia.org/wiki/CJK_Unified_Ideographs_Extension_A
     https://en.wikipedia.org/wiki/CJK_Unified_Ideographs_Extension_B
     https://en.wikipedia.org/wiki/CJK_Unified_Ideographs_Extension_C
     https://en.wikipedia.org/wiki/CJK_Unified_Ideographs_Extension_D
     https://en.wikipedia.org/wiki/CJK_Unified_Ideographs_Extension_E
     
     https://en.wikipedia.org/wiki/CJK_Compatibility_Ideographs
     https://en.wikipedia.org/wiki/CJK_Compatibility_Ideographs_Supplement
     
     CJK统一汉字 4E00-9FFF
     扩展A区用字 3400-4DBF
     扩展B区用字 20000-2A6DF
     扩展C区用字 2A700-2B73F
     扩展D区用字 2B740-2B81F
     扩展E区用字 2B820-2CEAF
     
     CJK兼容汉字 F900-FAFF
     扩展B区兼容用字 2F800-2FA1F
     */
    static NSString *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *buffer = [NSMutableString stringWithString:@"\u4E00-\u9FFF"]; // CJK统一汉字
        [buffer appendString:@"\u3400-\u4DBF"];                                        // 扩展A区用字
        [buffer appendString:@"\uF900-\uFAFF"];                                        // CJK兼容汉字
        [buffer appendString:@"\\U00020000-\\U0002A6DF"];                              // 扩展B区用字
        [buffer appendString:@"\\U0002A700-\\U0002B73F"];                              // 扩展C区用字
        [buffer appendString:@"\\U0002B740-\\U0002B81F"];                              // 扩展D区用字
        [buffer appendString:@"\\U0002B820-\\U0002CEAF"];                              // 扩展E区用字
        [buffer appendString:@"\\U0002F800-\\U0002FA1F"];                              // 扩展B区兼容用字
        regex = buffer.copy;
    });
    return regex;
}

- (NSString *)_tb_ChinesePunctuationsRegex {
    /*
     http://blog.csdn.net/monitor1394/article/details/7255767
     https://en.wikipedia.org/wiki/CJK_Symbols_and_Punctuation
     https://en.wikipedia.org/wiki/CJK_Compatibility_Forms
     
     CJK标点符号 3000-303F
     中文竖排标点 FE10-FE1F
     CJK兼容符号（竖排变体、下划线、顿号） FE30-FE4F
     中文标点 FE50-FE6F
     全角ASCII、全角中英文标点、半宽片假名、半宽平假名、半宽韩文字母 FF00-FFEF
     */
    static NSString *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *buffer = [NSMutableString stringWithString:@"\u3000-\u303F"]; // CJK标点符号
        [buffer appendString:@"\uFE10-\uFE1F"];                                        // 中文竖排标点
        [buffer appendString:@"\uFE30-\uFE4F"];                                        // CJK兼容符号（竖排变体、下划线、顿号）
        [buffer appendString:@"\uFE50-\uFE6F"];                                        // 中文标点
        [buffer appendString:@"\uFF00-\uFFEF"];                                        // 全角ASCII、全角中英文标点、半宽片假名、半宽平假名、半宽韩文字母
        regex = buffer.copy;
    });
    return regex;
}

- (NSString *)_tb_ChineseRadicalsRegex {
    /*
     https://en.wikipedia.org/wiki/Kangxi_radical
     https://en.wikipedia.org/wiki/CJK_Radicals_Supplement
     
     康熙部首 2F00–2FDF
     部首补充  2E80–2EFF
     */
    static NSString *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *buffer = [NSMutableString stringWithString:@"\u2F00-\u2FDF"]; // 康熙部首
        [buffer appendString:@"\u2E80-\u2EFF"];                                        // 部首补充
        regex = buffer.copy;
    });
    return regex;
}

- (NSString *)_tb_ChineseStrokesRegex {
    /*
     https://en.wikipedia.org/wiki/CJK_Strokes_(Unicode_block)
     
     笔划 31C0–31EF
     */
    static NSString *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *buffer = [NSMutableString stringWithString:@"\u31C0-\u31EF"]; // 笔划
        regex = buffer.copy;
    });
    return regex;
}

- (NSString *)_tb_ChineseIdeographicDescriptionsRegex {
    /*
     https://en.wikipedia.org/wiki/Ideographic_Description_Characters_(Unicode_block)
     
     构字描述符 2FF0–2FFF
     */
    static NSString *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *buffer = [NSMutableString stringWithString:@"\u2FF0-\u2FFF"]; // 构字描述符
        regex = buffer.copy;
    });
    return regex;
}

//- (NSString *)_tb_stringByReplacingRegex:(NSString *)regex options:(NSRegularExpressionOptions)options withString:(NSString *)replacement {
//    /*
//     https://github.com/ibireme/YYCategories/blob/master/YYCategories/Foundation/NSString%2BYYAdd.m
//     */
//    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
//    if (!pattern) return self;
//
//    return [pattern stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:replacement];
//}

- (BOOL)_tb_matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options {
    /*
     https://github.com/ibireme/YYCategories/blob/master/YYCategories/Foundation/NSString%2BYYAdd.m
     */
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:NULL];
    if (!pattern) return NO;
    
    return ([pattern numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0);
}
@end
