//
//  UIAlertController+LDAddition.h
//  LDKit
//
//  Created by wp on 2018/3/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//设置button的action
typedef void (^LDAlertActionBlock)(NSInteger buttonIndex, UIAlertAction *action, UIAlertController *alertSelf);

//添加button
typedef void(^LDAlertAppearanceProcess)(UIAlertController *alertMaker);

//设置button的title
typedef UIAlertController * _Nonnull (^LDAlertActionTitle)(NSString *title);


@interface UIAlertController (LDAddition)

//添加 UIAlertActionStyleDefault 类型的button
- (LDAlertActionTitle)addActionDefaultTitle;

//添加 UIAlertActionStyleCancel 类型的button
- (LDAlertActionTitle)addActionCancelTitle;

//添加 UIAlertActionStyleDestructive 类型的button
- (LDAlertActionTitle)addActionDestructiveTitle;

/**
 Alert
 @param title             title
 @param message           message
 @param appearanceProcess alert配置过程
 @param actionBlock       alert点击响应回调
 */
+ (void)ld_showAlertWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
            appearanceProcess:(LDAlertAppearanceProcess)appearanceProcess
                 actionsBlock:(nullable LDAlertActionBlock)actionBlock;

/**
 Alert
 只有一个button，默认显示“确定”
 @param title             title
 @param message           message
 */
+ (void)ld_showAlertWithTitle:(nullable NSString *)title
                            message:(nullable NSString *)message;




/**
 ActionSheet
 @param title             title
 @param message           message
 @param appearanceProcess actionSheet配置过程
 @param actionBlock       actionSheet点击响应回调
 */
+ (void)ld_showActionSheetWithTitle:(nullable NSString *)title
                            message:(nullable NSString *)message
                  appearanceProcess:(LDAlertAppearanceProcess)appearanceProcess
                       actionsBlock:(nullable LDAlertActionBlock)actionBlock;


@end

NS_ASSUME_NONNULL_END
