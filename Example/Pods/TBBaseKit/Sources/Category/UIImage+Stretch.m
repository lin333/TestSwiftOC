//
//  UIImage+Stretch.m
//  Stock
//
//  Created by liwt on 14/12/18.
//  Copyright (c) 2014年 com.tigerbrokers. All rights reserved.
//

#import "UIImage+Stretch.h"
#import <objc/runtime.h>

static char imageSourceURLKey;

@implementation UIImage (Stretch)

- (UIImage *)stretchableImageByCenter
{
	CGFloat leftCapWidth = floorf(self.size.width / 2);
	if (leftCapWidth == self.size.width / 2)
	{
		leftCapWidth--;
	}
	
	CGFloat topCapHeight = floorf(self.size.height / 2);
	if (topCapHeight == self.size.height / 2)
	{
		topCapHeight--;
	}
	
	return [self stretchableImageWithLeftCapWidth:leftCapWidth 
									 topCapHeight:topCapHeight];
}

- (UIImage *)stretchableImageByHeightCenter
{
	CGFloat topCapHeight = floorf(self.size.height / 2);
	if (topCapHeight == self.size.height / 2)
	{
		topCapHeight--;
	}
	
	return [self stretchableImageWithLeftCapWidth:0
									 topCapHeight:topCapHeight];
}

- (UIImage *)stretchableImageByWidthCenter
{
	CGFloat leftCapWidth = floorf(self.size.width / 2);
	if (leftCapWidth == self.size.width / 2)
	{
		leftCapWidth--;
	}
	
	return [self stretchableImageWithLeftCapWidth:leftCapWidth 
									 topCapHeight:0];
}

- (NSInteger)rightCapWidth
{
	return (NSInteger)self.size.width - (self.leftCapWidth + 1);
}


- (NSInteger)bottomCapHeight
{
	return (NSInteger)self.size.height - (self.topCapHeight + 1);
}

- (UIImage *)imageScale:(CGSize)newSize
{
    // UIGraphicsBeginImageContext iOS17废弃, 如果Size.height 或者width为0会崩溃
    UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:newSize format:format];
    UIImage *scaledImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        
    }];
    return scaledImage;
}

- (UIImage *)imageRotate:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    if (rect.size.width == 0 || rect.size.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), self.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectZero;
    rect.size = size;
    if (rect.size.width == 0 || rect.size.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius {
    CGRect contentRect = CGRectZero;
    contentRect.size = size;
    if (size.width == 0 || size.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    [self generatePathWithContext:context rect:contentRect radius:radius];
    CGContextFillPath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithText:(NSString *)text {
    // font
    UIFont *font = [UIFont systemFontOfSize:6];
    NSDictionary *dict = @{
                           NSFontAttributeName: font,
                           NSForegroundColorAttributeName: [UIColor whiteColor]
                           };
    CGSize textSize = [text sizeWithAttributes:dict];
    
    // 绘制上下文
    if (self.size.width == 0 || self.size.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    CGRect re = CGRectMake((self.size.width - textSize.width)/2.f, self.size.height - textSize.height-2, textSize.width, textSize.height);
    
    [text drawInRect:re withAttributes:dict];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
    
    
}

+ (UIImage *)circelBorderImageWithBackGroundColor:(UIColor *)backGroundColor
                                       imageColor:(UIColor *)imageColor
                                      borderColor:(UIColor *)borderColor
                                      contentSize:(CGSize)contentSize
                                        imageSize:(CGSize)imageSize
                                    contentRadius:(CGFloat)contentRadius
                                      imageRadius:(CGFloat)imageRadius
{
    if (contentSize.width == 0 || contentSize.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(contentSize, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawBaseBorderImageWithBackGroundColor:backGroundColor borderColor:borderColor contentSize:contentSize borderWidth:1 radius:contentRadius context:context];
    
    ///绘制中间图片
    CGRect imageRect = CGRectMake((contentSize.width - imageSize.width) / 2, (contentSize.height - imageSize.height) / 2, imageSize.width, imageSize.height);
    CGContextSetFillColorWithColor(context, imageColor.CGColor);
    ///绘制圆角矩形
    [self generatePathWithContext:context rect:imageRect radius:imageRadius];
    CGContextFillPath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)lineWidthIconWithBackGroundColor:(UIColor *)backGroundColor itemColor:(UIColor *)itemColor borderColor:(UIColor *)borderColor contentSize:(CGSize)contentSize itemHeight:(CGFloat)itemHeight radius:(CGFloat)radius {
    if (contentSize.width == 0 || contentSize.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(contentSize, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawBaseBorderImageWithBackGroundColor:backGroundColor borderColor:borderColor contentSize:contentSize borderWidth:1 radius:radius context:context];
    
    ///画出线宽icon
    CGRect iconRect = CGRectMake(contentSize.width * 0.25, (contentSize.height - itemHeight) / 2.f, contentSize.width * 0.5, itemHeight);
    CGContextSetFillColorWithColor(context, itemColor.CGColor);
    CGContextFillRect(context, iconRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)lineStyleIconWithBakcGroundColor:(UIColor *)backGroundColor borderColor:(UIColor *)borderColor lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth contentSize:(CGSize)contentSize radius:(CGFloat)radius dashEnable:(BOOL)dashEnable leftArrowEnable:(BOOL)leftArrowEnable rightArrowEnable:(BOOL)rightArrowEnable {
    CGRect contentRect = CGRectZero;
    contentRect.size = contentSize;
    if (contentSize.width == 0 || contentSize.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(contentSize, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawBaseBorderImageWithBackGroundColor:backGroundColor borderColor:borderColor contentSize:contentSize borderWidth:1 radius:radius context:context];

    ///这里的箭头边长统一为15
    CGFloat arrowWidth = 15.f;
    CGPoint beginPoint = CGPointMake(contentSize.width * 0.2, contentSize.height / 2.f);
    CGPoint endPoint = CGPointMake(contentSize.width * 0.8, contentSize.height / 2.f);
    
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    
    CGFloat distanceX = sqrt(pow(arrowWidth, 2.f) - pow(arrowWidth / 2.f, 2.f));
    CGFloat distanceY = arrowWidth / 2.f;
    
    if (leftArrowEnable) {
        CGContextMoveToPoint(context, beginPoint.x + distanceX, beginPoint.y - distanceY);
        CGContextAddLineToPoint(context, beginPoint.x, beginPoint.y);
        CGContextAddLineToPoint(context, beginPoint.x + distanceX, beginPoint.y + distanceY);

        CGContextStrokePath(context);
    }
    
    if (rightArrowEnable) {
        CGContextMoveToPoint(context, endPoint.x - distanceX, endPoint.y - distanceY);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextAddLineToPoint(context, endPoint.x - distanceX, endPoint.y + distanceY);

        CGContextStrokePath(context);
    }
    
    CGPoint lines[] = { beginPoint, endPoint };
    if (dashEnable) {
        CGFloat lengths[] = {5, 5};
        CGContextSetLineDash(context, 0, lengths, 2);
    }
    CGContextAddLines(context, lines, 2);
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)drawBaseBorderImageWithBackGroundColor:(UIColor *)backGroundColor borderColor:(UIColor *)borderColor contentSize:(CGSize)contentSize borderWidth:(CGFloat)borderWidth radius:(CGFloat)radius context:(CGContextRef)context {
    CGRect contentRect = CGRectZero;
    contentRect.size = contentSize;
        
    //背景色
    CGContextSetFillColorWithColor(context, backGroundColor.CGColor);
    [self generatePathWithContext:context rect:contentRect radius:radius];
    CGContextFillPath(context);
    
    ///画一个边框
    CGRect borderRect = CGRectMake(borderWidth/2.f, borderWidth/2.f, contentSize.width-borderWidth, contentSize.height-borderWidth);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    [self generatePathWithContext:context rect:borderRect radius:radius];
    CGContextStrokePath(context);
}

+ (void)generatePathWithContext:(CGContextRef)context rect:(CGRect)rect radius:(CGFloat)radius {
    
    CGContextBeginPath(context);
    CGPoint imgPoint1 = rect.origin;
    CGPoint imgPoint2 = CGPointMake(rect.origin.x + rect.size.width, imgPoint1.y);
    CGPoint imgPoint3 = CGPointMake(imgPoint2.x, rect.origin.y + rect.size.height);
    CGPoint imgPoint4 = CGPointMake(imgPoint1.x, imgPoint3.y);
    
    CGContextMoveToPoint(context, imgPoint1.x + radius, imgPoint1.y);
    CGContextAddArcToPoint(context, imgPoint2.x, imgPoint2.y, imgPoint3.x, imgPoint3.y - radius, radius);//右上角
    CGContextAddArcToPoint(context, imgPoint3.x, imgPoint3.y, imgPoint4.x - radius, imgPoint4.y, radius);//右下角
    CGContextAddArcToPoint(context, imgPoint4.x, imgPoint4.y, imgPoint1.x, imgPoint1.y - radius, radius);//左下角
    CGContextAddArcToPoint(context, imgPoint1.x, imgPoint1.y, imgPoint1.x + radius, imgPoint1.y, radius);//左上角
    
    CGContextClosePath(context);
}


+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors imgSize:(CGSize)imgSize {
    NSMutableArray *array = [NSMutableArray array];
    for (UIColor *c in colors) {
        [array addObject:(id)c.CGColor];
    }
    if (imgSize.width == 0 || imgSize.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)array, NULL);
    CGPoint start;
    CGPoint end;
    start = CGPointMake(0.0, 0.0);
    end = CGPointMake(imgSize.width, 0.0);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)borderIconWithBackGroundColor:(UIColor *)backGroundColor borderColor:(UIColor *)borderColor contentSize:(CGSize)contentSize radius:(CGFloat)radius {
    if (contentSize.width == 0 || contentSize.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(contentSize, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawBaseBorderImageWithBackGroundColor:backGroundColor borderColor:borderColor contentSize:contentSize borderWidth:1 radius:radius context:context];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageWithMaxSide:(CGFloat)maxSide
{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    UIImage* scaledImage = self;
    
    if(width > maxSide || height > maxSide){
        if(width > height){
            height = maxSide * height / width;
            width = maxSide;
        }else{
            width = maxSide * width / height;
            height = maxSide;
        }
        
        if (width == 0 || height == 0) {
            return nil;
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        
        // 绘制改变大小的图片
        [self drawInRect:CGRectMake(0, 0, width, height)];
        
        // 从当前context中创建一个改变大小后的图片
        scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
    }
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)imageWithCornerRadius:(float)cornerRadius
{
    UIImage *original = self;
    CGRect frame = CGRectMake(0, 0, original.size.width, original.size.height);
    // 开始一个Image的上下文
    if (original.size.width == 0 || original.size.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(original.size, NO, [UIScreen mainScreen].scale);
    // 添加圆角
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:cornerRadius] addClip];
    // 绘制图片
    [original drawInRect:frame];
    // 接受绘制成功的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)rotationToUp
{
    if (UIImageOrientationUp == self.imageOrientation) {
        return self;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    UIImage *aImage = self;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha
{
    if (self.size.width == 0 || self.size.height == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)compressQualityWithMaxLength:(NSInteger)maxLength
{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength){
        return [[UIImage alloc] initWithData:data];
    }
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return [[UIImage alloc] initWithData:data];
}

- (nullable NSURL *)sorceURL
{
    return objc_getAssociatedObject(self, &imageSourceURLKey);
}

- (void)setSorceURL:(NSURL *)sorceURL
{
    objc_setAssociatedObject(self, &imageSourceURLKey, sorceURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIImage *)qrCodeImageWithString:(NSString *)text size:(CGSize)size
{
    if(![text isKindOfClass:[NSString class]] || text.length == 0){
        return nil;
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData * data = [text dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    [filter setValue:@"L" forKeyPath:@"inputCorrectionLevel"];
    CIImage * outputImage = [filter outputImage];

    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGSize)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *img = [UIImage imageWithCGImage:scaledImage];
    CFRelease(scaledImage);
    return img;
}

- (UIImage*)subImageWithRect:(CGRect)rect
{
    CGFloat scale = self.scale;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale));
    UIImage *subImage = [UIImage imageWithCGImage:subImageRef];
    CFRelease(subImageRef);
    return subImage;
}

+ (UIImage *)combinedImagefromArray:(NSArray *)imageArray width:(CGFloat)width {
    CGFloat sizeH = 0;
    CGFloat sizeW = width;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    for (UIImage *img in imageArray) {
        CGFloat imgHeight = sizeW * CGImageGetHeight(img.CGImage) / CGImageGetWidth(img.CGImage);
        sizeH += imgHeight;
    }
    if (sizeW == 0 || sizeH == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sizeW, sizeH), YES, screenScale);
    CGFloat location_y = 0;
    for (int i = 0 ; i < imageArray.count; i++) {
        UIImage *image = imageArray[i];
        CGFloat img_w = CGImageGetWidth(image.CGImage);
        CGFloat img_h = CGImageGetHeight(image.CGImage);
        CGFloat newHeight = sizeW * img_h / img_w;
        
        [image drawInRect:CGRectMake(0, location_y, sizeW, newHeight)];
        
        location_y += newHeight;
    }
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

@end
