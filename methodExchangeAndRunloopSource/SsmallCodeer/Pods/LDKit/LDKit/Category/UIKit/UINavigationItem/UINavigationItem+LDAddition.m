//
//  UINavigationItem+LDAddition.m
//  LDKit
//
//  Created by Anchor on 17/3/9.
//  Copyright © 2017年 LDKit. All rights reserved.
//

#import "UINavigationItem+LDAddition.h"

@implementation UINavigationItem (LDAddition)

- (void)ld_addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    // Add a negative spacer on iOS >= 7.0
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -18;
    [self setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
}

- (void)ld_addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    // Add a negative spacer on iOS >= 7.0
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    [self setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil]];
}

// 缩小barButtonItem之间的间隔
- (void)ld_addRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    // Add a negative spacer on iOS >= 7.0
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (UIBarButtonItem *item in rightBarButtonItems) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -20;
        [tmpArray addObject:item];
        [tmpArray addObject:negativeSpacer];
    }
    [self setRightBarButtonItems:[NSArray arrayWithArray:tmpArray]];
}

@end
