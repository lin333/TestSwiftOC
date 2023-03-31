//
//  TBHelper.m
//  Stock
//
//  Created by JustLee on 2019/5/21.
//  Copyright © 2019 com.tigerbrokers. All rights reserved.
//

#import "NSMutableAttributedString+TBHelper.h"

@implementation NSMutableAttributedString (TBHelper)

+ (NSMutableAttributedString *)attributeStringWithSource:(NSArray *)source
{
    return [self attributeStringWithSource:source imageBoundsCreator:nil];
}

+ (NSMutableAttributedString *)attributeStringWithSource:(NSArray *)source imageBoundsCreator:(CGRect (^)(UIImage *, NSInteger))boundsCreator
{
    return [self attributeStringWithSource:source imageBoundsCreator:boundsCreator attributes:nil];
}

+ (NSMutableAttributedString *)attributeStringWithSource:(NSArray *)source
                                      imageBoundsCreator:(CGRect (^)(UIImage *, NSInteger))boundsCreator
                                              attributes:(NSDictionary *)attributes
{
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] init];
    
    if (source && [source isKindOfClass:[NSArray class]] && source.count > 0)
    {
        for (NSInteger i = 0; i < source.count; i ++)
        {
            id param = source[i];
            
            if ([param isKindOfClass:[NSString class]])
            {
                [mutableAttributeString appendAttributedString:[[NSAttributedString alloc] initWithString:param]];
            }
            else if ([param isKindOfClass:[UIImage class]])
            {
                UIImage *tipImage = (UIImage *)param;
                NSData *imgData = UIImageJPEGRepresentation(tipImage, 1);
                NSTextAttachment *imageAttatchment = [[NSTextAttachment alloc] initWithData:imgData ofType:@"png"];
                imageAttatchment.image = tipImage;
                
                if (boundsCreator)
                {
                    imageAttatchment.bounds = boundsCreator(tipImage, i);
                }
                else
                {
                    imageAttatchment.bounds = CGRectMake(0, 0, tipImage.size.width, tipImage.size.height);
                }
                
                NSAttributedString *attatchAttriString = [NSAttributedString attributedStringWithAttachment:imageAttatchment];
                
                [mutableAttributeString appendAttributedString:attatchAttriString];
            }
            else if ([param isKindOfClass:[NSAttributedString class]])
            {
                [mutableAttributeString appendAttributedString:param];
            }
        }
    }
    
    if (mutableAttributeString.length > 0)
    {
        if (attributes)
        {
            [mutableAttributeString addAttributes:attributes range:NSMakeRange(0, mutableAttributeString.length)];
        }
        
        return mutableAttributeString;
    }
    else
    {
        return nil;
    }
}

@end
