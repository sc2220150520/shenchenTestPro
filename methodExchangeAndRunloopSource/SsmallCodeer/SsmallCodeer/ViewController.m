//
//  ViewController.m
//  SsmallCodeer
//
//  Created by shen chen on 2017/9/12.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "ViewController.h"
#import "LDLightAlert.h"
#import "LDMBView.h"
#import "LDMBNormalView.h"
#import "PopWebViewController.h"
#import "DrawPix.h"

@interface ViewController ()<PopWebViewControllerHookProtocol>

@property(nonatomic,strong)UINavigationController *navControl;
@property(nonatomic,strong)PopWebViewController *popWebVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(250, 100, 70, 30);
    button.backgroundColor = [UIColor purpleColor];
    [button setTitle:@"弹窗" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showMessageBox:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    draw_picture(6);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showMessageBox:(id)sender
{
    //[LDLightAlert ld_showMsg:@"hello world" duration:2.0];
    //    LDMBNormalView *tv = [[LDMBNormalView alloc]
    //                          initWithConstructor:^(LDMBNormalViewConstructor * constructor) {
    //                              constructor.title = @"This is a title,hahahhahhahaahhahahahahahhahahahah,xixiixixixixixixixixixi";
    //                              constructor.image = [UIImage imageNamed:@"info_logo_black"];
    //                              constructor.content = @"detaildetaildetaildetail11111111detaildetaildetaildetail2222222222detaildetaildetaildetail33333333333detaildetaildetaildetail444444444detaildetaildetaildetail5555555555detaildetaildetaildetail6666666666detaildetaildetaildetail7777777777detaildetaildetaildetail88888888888888888";
    //                              constructor.checkEnable = YES;
    //                              constructor.hintText = @"以后不再提示以后不再提示以后不再提示以后不再提示以后不再提示以后不再提示以后不再提示以后不再提示";
    //                              //                              constructor.showCheck = YES;
    //                              constructor.showHypelink = YES;
    //                              constructor.linkText = @"点击我跳转咯~~";
    //
    //                              constructor.linkBlock = ^(void) {
    //                                  NSLog(@"超链接跳转咯");
    //                              };;
    //                              constructor.showTextField = YES;
    //                              constructor.textFieldPlaceHolder = @"输入点什么咧";
    //                          }];
    //
    //    LDMBView *ldmbView = [[LDMBView alloc] initWithNormalView:tv confirmTitle:@"YES" cancelTitle:@"Cancel" onDismiss:^(LDMBView *mbView,NSUInteger index,NSString *dismissButton,BOOL showCheck, BOOL checkEnable, BOOL showTextField, NSString * _Nullable text){
    //        NSLog(@"%@",dismissButton);
    //    }];
    //    [ldmbView animateShowWithBeginPosition:LDCPAnimationVerticalPositionTypeTop andDismissPosition:LDCPAnimationVerticalPositionTypeBottom];
    
    self.popWebVC = [[PopWebViewController alloc] initWithTitle:@"hello world"];
    [self.popWebVC loadURL:[NSURL URLWithString:@"http://www.jianshu.com/"]];
    //[self.popWebVC loadMainBundleFile:@"test.html"];
    self.popWebVC.hasToolBar = YES;
    [PopWebViewController setHook:self];
    [self.navigationController pushViewController:self.popWebVC animated:YES];
    
}


- (BOOL)webController:(PopWebViewController *)controller shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webControllerDidFinishLoad:(PopWebViewController *)controller
{
   // [self.popWebVC runJavaScriptString:@"alert(\"My First JavaScript\");"];
}

- (void)webController:(PopWebViewController *)controller didFailLoadWithError:(NSError *)error
{
    
}

@end
