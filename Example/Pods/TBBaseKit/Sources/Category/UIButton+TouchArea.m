//
//  UIButton+TouchArea.m
//  Stock
//
//  Created by zhengzhiwen on 2021/2/3.
//  Copyright © 2021 com.tigerbrokers. All rights reserved.
//

#import "UIButton+TouchArea.h"
#import <objc/runtime.h>

static char *touchAreah;

@implementation UIButton (TouchArea)

- (UIEdgeInsets)touchArea
{
    NSValue *value = objc_getAssociatedObject(self, &touchAreah);
    if ([value isKindOfClass:[NSValue class]]) {
        return  [value UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}

- (void)setTouchArea:(UIEdgeInsets)area
{
    objc_setAssociatedObject(self, &touchAreah, [NSValue valueWithUIEdgeInsets:area], OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIEdgeInsets dt = self.touchArea;
    CGRect area = CGRectMake(self.bounds.origin.x - dt.left, self.bounds.origin.y - dt.top, self.bounds.size.width + dt.left + dt.right, self.bounds.size.height + dt.top + dt.bottom);
    if (CGRectEqualToRect(self.bounds, area) || !self.userInteractionEnabled || self.hidden || self.alpha < 0.01) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(area, point) ? self : nil;
}

@end
