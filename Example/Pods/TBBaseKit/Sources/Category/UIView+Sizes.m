//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#import <QuartzCore/QuartzCore.h>
#import "UIView+Sizes.h"

@implementation UIView (Sizes)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
	return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
	return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
	return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
	return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
	return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
	return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
	return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    //NSLog(@"%f",self.frame.size.height);
	return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
	CGFloat x = 0;
	for (UIView* view = self; view; view = view.superview) {
		x += [view left];
	}
	return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
	CGFloat y = 0;
	for (UIView* view = self; view; view = view.superview) {
		y += [view top];
	}
	return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
	CGFloat x = 0;
	for (UIView* view = self; view; view = view.superview) {
		x += [view left];
		
		if ([view isKindOfClass:[UIScrollView class]]) {
			UIScrollView* scrollView = (UIScrollView*)view;
			x -= scrollView.contentOffset.x;
		}
	}
	
	return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
	CGFloat y = 0;
	for (UIView* view = self; view; view = view.superview) {
		y += [view top];
		
		if ([view isKindOfClass:[UIScrollView class]]) {
			UIScrollView* scrollView = (UIScrollView*)view;
			y -= scrollView.contentOffset.y;
		}
	}
	return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
	return CGRectMake([self screenViewX], [self screenViewY], [self width], [self height]);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
	return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
	return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
	if ([self isKindOfClass:cls])
		return self;
	
	for (UIView* child in self.subviews) {
		UIView* it = [child descendantOrSelfWithClass:cls];
		if (it)
			return it;
	}
	
	return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
	if ([self isKindOfClass:cls]) {
		return self;
	} else if (self.superview) {
		return [self.superview ancestorOrSelfWithClass:cls];
	} else {
		return nil;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)offsetFromView:(UIView*)otherView {
	CGFloat x = 0, y = 0;
	for (UIView* view = self; view && view != otherView; view = view.superview) {
		x += [view left];
		y += [view top];
	}
	return CGPointMake(x, y);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)viewController {
	for (UIView* next = [self superview]; next; next = next.superview) {
		UIResponder* nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController*)nextResponder;
		}
	}
	return nil;
}

- (UIImage *)imageFromView
{
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageFromViewWithLowResolution
{
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.5);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:0.5 orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageFromViewInRect:(CGRect)rect
{
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageFromBlurView
{
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        [self drawViewHierarchyInRect:CGRectMake(0, 0, size.width , size.height ) afterScreenUpdates:YES];
    }
    else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageFromViewWithLowResolutionInRect:(CGRect)rect
{
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.5);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:0.5 orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}



- (CGRect)convertFrameToWindow:(UIWindow *)window
{
    
    UIView *superView = [self superview];;
    
    CGRect frameInSuperView = [self frame];
    while (superView && (superView != window)){
        if ([superView superview])
        {
            frameInSuperView = [superView.superview convertRect:frameInSuperView fromView:superView];
        }
        superView = [superView superview];
    }
    return frameInSuperView;
}

- (CGRect)expandedFrame:(CGRect)originalFrame withOffset:(CGFloat)offset
{
    if (CGRectIsEmpty(originalFrame))
    {
        return CGRectZero;
    }
    return CGRectInset(originalFrame, -offset, -offset);
}

- (CGRect)expandedFrame:(CGRect)originalFrame withVerticalOffset:(CGFloat)offset
{
    if (CGRectIsEmpty(originalFrame))
    {
        return CGRectZero;
    }
    return CGRectInset(originalFrame, 0, -offset);
}

- (CGRect)expandedFrame:(CGRect)originalFrame withHorizontalOffset:(CGFloat)offset
{
    if (CGRectIsEmpty(originalFrame))
    {
        return CGRectZero;
    }
    return CGRectInset(originalFrame, -offset, 0);
}

- (UIView*)viewForAnimation
{
    return nil;
}

- (void)sizeToFitSize:(CGSize)size
{
	CGSize _size = [self sizeThatFits:size];
	_size.width = MIN(size.width, _size.width + 1);
	[self setSize:_size];
}

- (void)tb_sizeToFit
{
	[self sizeToFitSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (void)keyBackColorAnimationWithColors:(NSArray*)colors duration:(CGFloat)duration {
    CAKeyframeAnimation *caAnimation = [CAKeyframeAnimation animation];
    caAnimation.keyPath = @"backgroundColor";
    caAnimation.values = colors;
    caAnimation.duration = duration;
    caAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:caAnimation forKey:nil];
}

+ (UIView *)maskGuideViewWithRect:(CGRect)rect drawCircle:(BOOL)isDrawCircle{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    UIBezierPath *all_path = [UIBezierPath bezierPathWithRect:view.bounds];
    if (isDrawCircle) {
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        [all_path appendPath:path];
    } else {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        [all_path appendPath:path];
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.path = all_path.CGPath;
    view.layer.mask = maskLayer;
    
    return view;
}

+ (void)animationTransformRotationWith:(UIView *)view fromValue:(double)fromValue toValue:(double)toValue {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.fromValue = @(fromValue);
    basicAnimation.toValue = @(toValue);
    basicAnimation.removedOnCompletion = YES;
    basicAnimation.duration = 0.25;
    basicAnimation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:basicAnimation forKey:nil];
}

- (void)showInWindowWithDuration:(NSTimeInterval)duration animate:(void (^)(void))animate
{
    [self showInWindowWithDuration:duration animate:animate completion:NULL];
}

- (void)showInWindowWithDuration:(NSTimeInterval)duration animate:(void (^)(void))animate completion:(void (^)(BOOL))completion
{
    if (!self.superview) {
        [[UIApplication sharedApplication].delegate.window addSubview:self];
//        [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:self];
    }
    [UIView animateWithDuration:duration animations:animate completion:completion];
}

- (void)hideWithDuration:(NSTimeInterval)duration animate:(void (^)(void))animate
{
    [UIView animateWithDuration:duration animations:animate completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (CGFloat)safeAreaTop
{
    CGFloat safeAreaTop = 0;

    if (@available(iOS 11.0, *)) {
        safeAreaTop = [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
    }
    return safeAreaTop;
}

+ (CGFloat)safeAreaBottom
{
    CGFloat safeAreaBottom = 0;
    
    if (@available(iOS 11.0, *)) {
        safeAreaBottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    return safeAreaBottom;
}

@end
