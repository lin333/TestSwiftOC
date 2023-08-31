//
//  UIImage+FCCategory.m
//  FCCategoryOCKit
//
//  Created by 石富才 on 2020/3/5.
//

#import "UIImage+FCCategory.h"

@implementation UIImage (FCCategory)

/**
 图片拼接
 @param images 图片集合
 @param joinType 拼接方式；FCImageJoinTypeVertical，垂直拼接；FCImageJoinTypeHorizontal，水平拼接；FCImageJoinTypeVertical ｜FCImageJoinTypeCenter，垂直居中拼接；FCImageJoinTypeHorizontal ｜FCImageJoinTypeCenter，水平居中拼接。
 */
+ (UIImage *)fc_joinImages:(NSArray<UIImage *> *)images joinType:(FCImageJoinType)joinType{
    return [self fc_joinImages:images joinType:joinType lineSpace:0];
}

/**
 图片拼接
 @param images 图片集合
 @param joinType 拼接方式；
 @param lineSpace 图片之间的间距
 */
+ (UIImage *)fc_joinImages:(NSArray<UIImage *> *)images joinType:(FCImageJoinType)joinType lineSpace:(CGFloat)lineSpace{
    CGFloat maxW = 0;//最大图片的宽度
    CGFloat allW = 0;//总宽度
    CGFloat maxH = 0;//最大图片的高度
    CGFloat allH = 0;//总高度
    lineSpace *= UIScreen.mainScreen.scale;
    NSMutableArray *mArr = NSMutableArray.array;
    for (UIImage *img in images) {
        if ([img isKindOfClass:UIImage.class]) {
            maxW = MAX(maxW, img.size.width);
            allW += maxW;
            //
            maxH = MAX(maxH, img.size.height);
            allH += maxH;
            [mArr addObject:img];
        }
    }
    if (mArr.count > 1) {
        allW += (mArr.count - 1) * lineSpace;
        allH += (mArr.count - 1) * lineSpace;
    }
    if (joinType & FCImageJoinTypeCenter && joinType & FCImageJoinTypeHorizontal) {//水平居中
        if (mArr.count > 0) {
            return [self _horizontalType:FCImageJoinTypeCenter images:images maxHeight:maxH allWidth:allW lineSpace:lineSpace];
        }
    }else if (joinType & FCImageJoinTypeCenter && joinType & FCImageJoinTypeVertical){//垂直居中
        if (mArr.count > 0) {
            return [self _verticalType:FCImageJoinTypeCenter images:images maxWidth:maxW allHeight:allH lineSpace:lineSpace];
        }
    }else if (joinType & FCImageJoinTypeHorizontal && joinType & FCImageJoinTypeBottom){//水平底部对齐
        if (mArr.count > 0) {
            return [self _horizontalType:FCImageJoinTypeBottom images:images maxHeight:maxH allWidth:allW lineSpace:lineSpace];
        }
    }else if (joinType & FCImageJoinTypeHorizontal && joinType & FCImageJoinTypeTop){//水平顶部对齐
        if (mArr.count > 0) {
            return [self _horizontalType:FCImageJoinTypeTop images:images maxHeight:maxH allWidth:allW lineSpace:lineSpace];
        }
    }else if (joinType & FCImageJoinTypeVertical && joinType & FCImageJoinTypeRight){//垂直右对齐
        if (mArr.count > 0) {
            return [self _verticalType:FCImageJoinTypeRight images:images maxWidth:maxW allHeight:allH lineSpace:lineSpace];
        }
    }else if (joinType & FCImageJoinTypeVertical && joinType & FCImageJoinTypeLeft){//垂直左对齐
        if (mArr.count > 0) {
            return [self _verticalType:FCImageJoinTypeLeft images:images maxWidth:maxW allHeight:allH lineSpace:lineSpace];
        }
    }else if (joinType & FCImageJoinTypeHorizontal){//水平居中
        if (mArr.count > 0) {
            return [self _horizontalType:FCImageJoinTypeCenter images:images maxHeight:maxH allWidth:allW lineSpace:lineSpace];
        }
    }else if (joinType & FCImageJoinTypeVertical){//垂直居中
        if (mArr.count > 0) {
            return [self _verticalType:FCImageJoinTypeCenter images:images maxWidth:maxW allHeight:allH lineSpace:lineSpace];
        }
    }else{
        
    }
    return nil;
}

+ (UIImage *)_horizontalType:(FCImageJoinType)horType images:(NSArray<UIImage *> *)images maxHeight:(CGFloat)maxHeight allWidth:(CGFloat)allWidth lineSpace:(CGFloat)lineSpace{
    UIGraphicsBeginImageContext(CGSizeMake(allWidth, maxHeight));
    CGFloat pointX = 0;
    for (UIImage *img in images) {
        switch (horType) {
            case FCImageJoinTypeCenter:{
                [img drawInRect:CGRectMake(pointX, (maxHeight - img.size.height)*0.5, img.size.width, img.size.height)];
            }break;
            case FCImageJoinTypeBottom:{
                [img drawInRect:CGRectMake(pointX, maxHeight - img.size.height, img.size.width, img.size.height)];
            }break;
            case FCImageJoinTypeTop:{
                [img drawInRect:CGRectMake(pointX, 0, img.size.width, img.size.height)];
            }break;
            default:{
                
            }break;
        }
        pointX += img.size.width + lineSpace;
    }
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();//关闭上下文
    return resultImg;
}
+ (UIImage *)_verticalType:(FCImageJoinType)verType images:(NSArray<UIImage *> *)images maxWidth:(CGFloat)maxWidth allHeight:(CGFloat)allHeight lineSpace:(CGFloat)lineSpace{
    UIGraphicsBeginImageContext(CGSizeMake(maxWidth, allHeight));
    CGFloat pointY = 0;
    for (UIImage *img in images) {
        switch (verType) {
            case FCImageJoinTypeCenter:{
                [img drawInRect:CGRectMake((maxWidth - img.size.width)*0.5, pointY, img.size.width, img.size.height)];
            } break;
            case FCImageJoinTypeRight:{
                [img drawInRect:CGRectMake(maxWidth - img.size.width, pointY, img.size.width, img.size.height)];
            } break;
            case FCImageJoinTypeLeft:{
                [img drawInRect:CGRectMake(0, pointY, img.size.width, img.size.height)];
            } break;
            default:{
                [img drawInRect:CGRectMake((maxWidth - img.size.width)*0.5, pointY, img.size.width, img.size.height)];
            }break;
        }
        pointY += img.size.height + lineSpace;
    }
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();//关闭上下文
    return resultImg;
}

/**
 裁剪图片
 @param rect 裁剪区域
 @param orientation 图片方向
 */
- (UIImage *)fc_cutRect:(CGRect)rect orientation:(UIImageOrientation)orientation{
    CGFloat scale = UIScreen.mainScreen.scale;
    rect.origin.x *= scale;
    rect.origin.y *=  scale;
    rect.size.width *=  scale;
    rect.size.height *= scale;
    
    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:UIScreen.mainScreen.scale orientation:orientation];
    return newImage;
}

/**
 生成二维码图片
 @param qrStr 要生存二维码的字符串
 @param qrSize 二维码大小
 @param centerImage 中间图片
 */
+ (UIImage  *)fc_QRString:(NSString *)qrStr qrSize:(CGFloat)qrSize centerImage:(UIImage *_Nullable)centerImage{
    
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [qrStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *image = [filter outputImage];
    
    UIImage *qrImg = [self fc_createNonInterpolatedUIImageFormCIImage:image withSize:qrSize];
    
    if (centerImage) {
        //5.把中央图片划入二维码里面
        //5.1开启图形上下文
        UIGraphicsBeginImageContext(qrImg.size);
        //5.2将二维码的图片画入
        [qrImg drawInRect:CGRectMake(0, 0, qrImg.size.width, qrImg.size.height)];
        CGFloat centerW=qrImg.size.width*0.3;
        CGFloat centerH=centerW;
        CGFloat centerX=(qrImg.size.width-centerW)*0.5;
        CGFloat centerY=(qrImg.size.height -centerH)*0.5;
        [centerImage drawInRect:CGRectMake(centerX, centerY, centerW, centerH)];
        //5.3获取绘制好的图片
        UIImage *finalImg=UIGraphicsGetImageFromCurrentImageContext();
        //5.4关闭图像上下文
        UIGraphicsEndImageContext();
        return finalImg;
    }
    return qrImg;
}

/**
 CIImage 转 UIImage
 */
+ (UIImage *)fc_createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
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
    return [UIImage imageWithCGImage:scaledImage];
}

@end

