//
//  ViewController.m
//  TestLib
//
//  Created by shen chen on 2018/6/21.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#import "ViewController.h"
#import "libxx.h"
#import "libyy.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    libyy *yy = [[libyy alloc] init];
    [yy cout];
    libxx *xx = [[libxx alloc] init];
    [xx cout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
