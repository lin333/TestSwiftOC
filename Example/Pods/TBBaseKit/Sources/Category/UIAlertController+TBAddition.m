//
//  UIAlertController+TBAddition.m
//  Stock
//
//  Created by JustLee on 2019/2/27.
//  Copyright © 2019 com.tigerbrokers. All rights reserved.
//

#import "UIAlertController+TBAddition.h"
#import <objc/runtime.h>

const char * kMessageTextAlignmentKey = (void *)@"TBAlertController.messageTextAlignmentKey";

@implementation UIAlertController (TBAddition)

- (void)viewWillAppear:(BOOL)animated; {
    [super viewWillAppear:animated];
    
    [self getSubview:self.view];
}

- (NSTextAlignment)messageTextAlignment {
    NSNumber *textAlignment = objc_getAssociatedObject(self, &kMessageTextAlignmentKey);
    if (textAlignment) {
        return textAlignment.integerValue;
    };
    
    return NSTextAlignmentCenter;
}

- (void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment {
    objc_setAssociatedObject(self, &kMessageTextAlignmentKey, @(messageTextAlignment), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)getSubview:(UIView *)view {

    NSArray *subviews = [view subviews];
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        if ([subview isMemberOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            if ([label.text isEqualToString:self.message]) {
                label.textAlignment = self.messageTextAlignment;
            }
        } else {
            [self getSubview:subview];
        }
    }
}

@end
