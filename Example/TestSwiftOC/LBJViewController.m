//
//  LBJViewController.m
//  TestSwiftOC
//
//  Created by linbingjie on 11/01/2022.
//  Copyright (c) 2022 linbingjie. All rights reserved.
//

#import "LBJViewController.h"
#import <TestSwiftOC/LBJOC.h>

@interface LBJViewController ()

@end

@implementation LBJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [LBJOC loglog];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

// xcodebuild GCC_PREPROCESSOR_DEFINITIONS='$(inherited)'  ARCHS='arm64' OTHER_CFLAGS='-fembed-bitcode -Qunused-arguments' CONFIGURATION_BUILD_DIR=build-arm64 clean build -configuration Debug -target TestSwiftOC-Example
