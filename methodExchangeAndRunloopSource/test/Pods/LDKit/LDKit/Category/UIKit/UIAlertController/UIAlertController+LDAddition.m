//
//  UIAlertController+LDAddition.m
//  LDKit
//
//  Created by wp on 2018/3/26.
//

#import "UIAlertController+LDAddition.h"
#import <objc/runtime.h>
#import "UIViewController+LDAddition.h"

static char ACTIONS_IDENTIFER;


//配置action
typedef void (^LDAlertActionsConfig)(LDAlertActionBlock actionBlock);


@interface UIAlertController()

@property (nonatomic, strong) NSMutableArray <NSDictionary *>* alertActionArray;

@end

@implementation UIAlertController (LDAddition)

# pragma mark - setter/getter
- (void)setAlertActionArray:(NSMutableArray<NSDictionary *> *)alertActionArray
{
    objc_setAssociatedObject(self, &ACTIONS_IDENTIFER, alertActionArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray <NSDictionary *> *)alertActionArray
{
    return objc_getAssociatedObject(self, &ACTIONS_IDENTIFER);
}

# pragma mark - configuration
- (LDAlertActionsConfig)alertActionsConfig
{
    return ^(LDAlertActionBlock actionBlock) {
        if (self.alertActionArray.count > 0)
        {
            //创建action
            __weak typeof(self)weakSelf = self;
            [self.alertActionArray enumerateObjectsUsingBlock:^(NSDictionary *actionDic, NSUInteger idx, BOOL * _Nonnull stop) {
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:[actionDic valueForKey:@"title"] style:[[actionDic valueForKey:@"style"] integerValue] handler:^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    if (actionBlock) {
                        actionBlock(idx, action, strongSelf);
                    }
                }];
                [self addAction:alertAction];
            }];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    };
}

- (LDAlertActionTitle)addActionDefaultTitle
{
    return ^(NSString *title) {
        NSDictionary *actionDic = @{@"title":title, @"style":@(UIAlertActionStyleDefault)};
        [self.alertActionArray addObject:actionDic];
        return self;
    };
}

- (LDAlertActionTitle)addActionCancelTitle
{
    return ^(NSString *title) {
        NSDictionary *actionDic = @{@"title":title, @"style":@(UIAlertActionStyleCancel)};
        [self.alertActionArray addObject:actionDic];
        return self;
    };
}

- (LDAlertActionTitle)addActionDestructiveTitle
{
    return ^(NSString *title) {
        NSDictionary *actionDic = @{@"title":title, @"style":@(UIAlertActionStyleDestructive)};
        [self.alertActionArray addObject:actionDic];
        return self;
    };
}

+ (void)ld_showAlertWithPreferredStyle:(UIAlertControllerStyle)preferredStyle
                                 title:(NSString *)title
                               message:(NSString *)message
                     appearanceProcess:(LDAlertAppearanceProcess)appearanceProcess
                          actionsBlock:(LDAlertActionBlock)actionBlock
{
    if (appearanceProcess)
    {
        UIAlertController *alertMaker = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
        if (!alertMaker) {
            return ;
        }
        alertMaker.alertActionArray = [[NSMutableArray alloc] initWithCapacity:0];
        //添加需要的button
        appearanceProcess(alertMaker);
        //配置响应
        alertMaker.alertActionsConfig(actionBlock);
        [UIAlertController showAlertController:alertMaker];
    }
}

#pragma mark - Alert
+ (void)ld_showAlertWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
            appearanceProcess:(LDAlertAppearanceProcess)appearanceProcess
                 actionsBlock:(nullable LDAlertActionBlock)actionBlock
{
    [self ld_showAlertWithPreferredStyle:UIAlertControllerStyleAlert title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}

+ (void)ld_showAlertWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message;
{
    [self ld_showAlertWithPreferredStyle:UIAlertControllerStyleAlert title:title message:message appearanceProcess:^(UIAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"确定");
    } actionsBlock:nil];
}

#pragma mark - ActionSheet
+ (void)ld_showActionSheetWithTitle:(NSString *)title
                            message:(NSString *)message
                  appearanceProcess:(LDAlertAppearanceProcess)appearanceProcess
                       actionsBlock:(LDAlertActionBlock)actionBlock
{
    [self ld_showAlertWithPreferredStyle:UIAlertControllerStyleActionSheet title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}

#pragma mark - other
+ (void)showAlertController:(UIAlertController *)alertController
{
    UIViewController *topViewController = [UIViewController ld_topmostViewController];
    if (![topViewController isKindOfClass:[UIAlertController class]]) {
        [topViewController presentViewController:alertController animated:YES completion:nil];
    } else if ([topViewController isKindOfClass:[UIAlertController class]]) {
        NSLog(@"WARNING: you could NOT synchronously present multiple alert on the same view controller.");
    }
}

@end
