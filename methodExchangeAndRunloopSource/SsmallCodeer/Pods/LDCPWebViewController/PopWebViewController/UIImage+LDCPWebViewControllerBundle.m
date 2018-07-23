//
//  UIImage+LDCPWebViewControllerBundle.m
//  Pods
//
//  Created by asshole on 16/12/19.
//
//

#import "UIImage+LDCPWebViewControllerBundle.h"
#import "PopWebViewController.h"

@implementation UIImage (LDCPWebViewControllerBundle)

+ (nullable UIImage *)ldCPWebView_imageNamed:(NSString *)name
{
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        static NSBundle *bundle;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            bundle = [NSBundle bundleForClass:[PopWebViewController class]];
        });
        
        return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageNamed:name];
    }
}

@end
