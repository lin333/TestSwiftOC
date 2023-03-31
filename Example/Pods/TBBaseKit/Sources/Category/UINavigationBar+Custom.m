//
//  UINavigationBar+Custom.m
//  Stock
//
//  Created by ChenXin on 17/2/9.
//  Copyright © 2017年 com.tigerbrokers. All rights reserved.
//

#import "UINavigationBar+Custom.h"

@implementation UINavigationBar (Custom)

- (void)tb_setNavBarTitleStyle:(UIColor *)tintColor textAttributes:(NSDictionary *)textAttributes
{
    [self setBarTintColor:tintColor];
    [self setTitleTextAttributes:textAttributes];
}

- (void)tb_hidesBottomLine {
    self.shadowImage = [[UIImage alloc] init];
}

@end
