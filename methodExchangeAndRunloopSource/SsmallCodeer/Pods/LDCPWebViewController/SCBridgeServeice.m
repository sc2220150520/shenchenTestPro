//
//  SCBridgeServeice.m
//  SsmallCodeer
//
//  Created by shen chen on 2017/9/14.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "SCBridgeServeice.h"

@implementation SCBridgeServeice

+ (void)load
{
    @autoreleasepool {
        [[JSBridgeConfig sharedInstance] registerJSApi:@"helloTest" service:@"SCBridgeServeice" selectors:@[@[@(0),@"hello"]] local:YES];
    }
}


- (void)serviceInitialize
{
    [super serviceInitialize];
}

- (void)onConnect:(NSNotification *)notification
{
    [super onConnect:notification];
}

- (void)onClose:(NSNotification *)notification
{
    [super onClose:notification];
}

- (void)onWebViewFinishLoad:(NSNotification *)notification
{
    [super onWebViewFinishLoad:notification];
}

- (void)hello:(NSDictionary *)params Callback:(JsonRPCCallback)cb
{
    NSLog(@"jjjjjjjjjjj");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"shenchen" message:@"helll" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    [alertView show];
}

@end
