//
//  libxx.m
//  libxx
//
//  Created by shen chen on 2018/6/21.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#import "libxx.h"
#import "print.h"

@implementation libxx

- (void)cout {
    NSLog(@"xxxx");
    print *a = [[print alloc] init];
    [a print];
    //[a lalal];
}

@end
