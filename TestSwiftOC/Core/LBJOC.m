//
//  LBJOC.m
//  Pods-TestSwiftOC_Example
//
//  Created by linbingjie on 2022/11/1.
//

#import "LBJOC.h"

#if __has_include(<TestSwiftOC/TestSwiftOC-Swift.h>)
    #import <TestSwiftOC/TestSwiftOC-Swift.h>
#else
    #import "TestSwiftOC-Swift.h"
#endif
@implementation LBJOC

+ (void)loglog {
    NSLog(@"ssss");
    
    [[GT3Error alloc]init];
//    [[[qqqS alloc] init] printtt];;
    NSLog(@"sdfsdf");
    
}


+ (void)loglog2 {
    NSLog(@"loglogogog2");
}

@end
