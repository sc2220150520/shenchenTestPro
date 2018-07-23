//
//  LDCPWebViewImages.m
//  NeteaseLottery
//
//  Created by SongLi on 14-11-1.
//  Copyright (c) 2014年 netease. All rights reserved.
//

#import "LDCPWebViewImages.h"
#import "LDCPWebViewUtil.h"
#import "UIImage+LDCPWebViewControllerBundle.h"

#define BoundleResource(imageName) [webView_ResourceBundle stringByAppendingString:imageName]

static NSString *webView_ResourceBundle = @"LDCPWebViewController.bundle/";

@implementation LDCPWebViewImages

+ (UIImage *)WebPrevImage
{
    return [UIImage ldCPWebView_imageNamed:BoundleResource(@"WebPrev")];
}

+ (UIImage *)WebPrevPressedImage
{
    return [UIImage ldCPWebView_imageNamed:BoundleResource(@"WebPrevPressed")];
}

+ (UIImage *)WebNextImage
{
    return [UIImage ldCPWebView_imageNamed:BoundleResource(@"WebNext")];
}

+ (UIImage *)WebNextPressedImage
{
    return [UIImage ldCPWebView_imageNamed:BoundleResource(@"WebNextPressed")];
}

+ (UIImage *)ToolBarBackgroundImage
{
    return [UIImage ldCPWebView_imageNamed:BoundleResource(@"ToolBarBackground")];
}

@end
