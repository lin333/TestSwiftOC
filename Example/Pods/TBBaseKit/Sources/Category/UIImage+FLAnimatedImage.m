//
//  UIImage+FLAnimatedImage.m
//  TBBaseKit
//
//  Created by QXQ on 2021/10/13.
//

#import "UIImage+FLAnimatedImage.h"
#import "objc/runtime.h"

@implementation UIImage (FLAnimatedImage)

- (FLAnimatedImage *)sd_FLAnimatedImage {
    return objc_getAssociatedObject(self, @selector(sd_FLAnimatedImage));
}

- (void)setSd_FLAnimatedImage:(FLAnimatedImage *)sd_FLAnimatedImage {
    objc_setAssociatedObject(self, @selector(sd_FLAnimatedImage), sd_FLAnimatedImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
