//
//  PopWebViewController.m
//  NeteaseLottery
//
//  Created by wangbo on 11-5-18.
//  Copyright 2011 netease. All rights reserved.
//

#import "PopWebViewController.h"
#import "LDCPWebViewImages.h"
#import "LDCPWebViewUtil.h"
#import "UIBarButtonItem+LDCustom.h"
#import "UINavigationItem+LDAddition.h"
#import "WebViewJsonRPC.h" // JSBridge
#import "LDWebViewProgressView.h"
#import "LDWebViewProgress.h"
#import "UIViewController+LDAddition.h"
#import "UIImage+LDCPWebViewControllerBundle.h"
#import "SCBridgeServeice.h"

#define JSTest

NSString * const kPopWebViewControllerWillAppear    = @"PopWebViewControllerWillAppear";
NSString * const kPopWebViewControllerWillDisAppear = @"PopWebViewControllerWillDisAppear";
NSString * const kPopWebViewControllerWillClose     = @"kPopWebViewControllerWillClose";

static id <PopWebViewControllerHookProtocol> hook;

@interface PopWebViewController ()<LDWebViewProgressDelegate>

@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UIImageView *toolbar;
@property (nonatomic, strong) UIButton *backItem;
@property (nonatomic, strong) UIButton *forwardItem;

@property (nonatomic) NSURL *loginPendingUrl;
@property (nonatomic, strong) NSURL *cachedURL;//缓存过早load的url
@property (nonatomic, strong) UIActivityIndicatorView *indicatorViewInPop;
@property (nonatomic, strong) WebViewJsonRPC *jsBridge;
@property (nonatomic, strong) NSMutableDictionary *businessDict;//存放业务需求数据

//加载webview的进度条控制
@property (nonatomic, strong) LDWebViewProgressView *progressView;
@property (nonatomic, strong) LDWebViewProgress *progressProxy;

@property (nonatomic, copy) NSString *originUrlString;
@property (nonatomic, copy) NSString *currentUrlString;

@end




@implementation PopWebViewController


+ (void)setHook:(id<PopWebViewControllerHookProtocol>)theHook
{
    hook = theHook;
}


#pragma mark - LifeCycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithTitle:nil];
}

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = title;
        _clearBarButtonWhenLoadUrl = YES;
        _hasToolBar = NO;
        _businessDict = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = [LDCPWebViewUtil labelForNavTitle:self.title];
    [self.navigationItem ld_addLeftBarButtonItem:[self leftArrowButtonWithClose]];

#ifdef JSTest
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStyleBordered target:self action:@selector(testFunction)];
#endif
    
    self.webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webview.backgroundColor = [UIColor colorWithRed:0xf4 / 255.0f green:0xf4 / 255.0f blue:0xf4 / 255.0f alpha:1.0f];
    self.webview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.webview.scalesPageToFit = YES;
    [self.view addSubview:self.webview];
    
    self.jsBridge = [[WebViewJsonRPC alloc] init];
    [self.jsBridge connect:self.webview Controller:self];
    
    if (self.hasToolBar) {
        self.webview.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 40);
        self.toolbar = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, CGRectGetWidth(self.view.bounds), 44)];
        self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        self.toolbar.image = [LDCPWebViewImages ToolBarBackgroundImage];
        self.toolbar.userInteractionEnabled = YES;
        [self.view addSubview:self.toolbar];
        
        [self setToolbarView];
    }
    
    //加载webview的进度条
    _progressProxy = [[LDWebViewProgress alloc] init];
    self.webview.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 3.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[LDWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_progressView setProgress:0];
    _progressView.progressBarView.backgroundColor = [UIColor colorWithRed:0xFF / 255.0f green:0x99 / 255.0f blue:0x00 / 255.0f alpha:1];//FF9900
    
   
    if (self.cachedURL) {//载入url缓存
        [self loadURL:self.cachedURL];
    }
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPopWebViewControllerWillAppear object:nil];

    [self.navigationController.navigationBar addSubview:_progressView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self onWebViewShow];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPopWebViewControllerWillDisAppear object:nil];
    
    if ([self.delegate respondsToSelector:@selector(controller:willDisappear:)]) {
        [self.delegate controller:self willDisappear:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self onWebViewHidden];
    
    if ([self.delegate respondsToSelector:@selector(controller:didDisappear:)]) {
        [self.delegate controller:self didDisappear:animated];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self.jsBridge close];
    self.webview.delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Test Function

- (void)testFunction
{
    [self.jsBridge jsEval:@";CPJsApi.account.login();"];
}

#pragma mark - Private Methods

- (void)onWebViewShow
{
    [self.jsBridge triggerEvent:@"hello" withDetail:nil];
}

- (void)hello
{
    NSLog(@"jjjjjjjjjjjj");
}

- (void)onWebViewHidden
{
    [self.jsBridge triggerEvent:@"onWebViewHidden" withDetail:nil];
}

- (void)closeButtonPressed:(id)sender
{
    if (self.customCloseAction) {
        self.customCloseAction();
        return;
    }
    
    [self close];
}

- (void)backWebview:(id)sender
{
    if (self.customGoBackAction) {
        self.customGoBackAction();
        return;
    }
    
    if ([self.webview canGoBack]) {
        [self.webview goBack];
    } else {
        [self closeButtonPressed:sender];
    }
}

- (void)setToolbarView
{
    self.backItem = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backItem.frame = CGRectMake(10, 7, 27.5, 29.5);
    self.backItem.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self.backItem setImage:[LDCPWebViewImages WebPrevImage] forState:UIControlStateNormal];
    [self.backItem setImage:[LDCPWebViewImages WebPrevPressedImage] forState:UIControlStateHighlighted];
    [self.backItem addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar addSubview:self.backItem];
    
    self.forwardItem = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forwardItem.frame = CGRectMake(CGRectGetWidth(self.toolbar.bounds) - 10 - 27.5, 7, 27.5, 29.5);
    self.forwardItem.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.forwardItem setImage:[LDCPWebViewImages WebNextImage] forState:UIControlStateNormal];
    [self.forwardItem setImage:[LDCPWebViewImages WebNextPressedImage] forState:UIControlStateHighlighted];
    [self.forwardItem addTarget:self action:@selector(forwardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar addSubview:self.forwardItem];
}

/** 去掉iOS7.0之下的代码逻辑。（返回和关闭按钮的逻辑需要重新整理了） */
- (UIBarButtonItem *)leftArrowButtonWithClose
{
    UIImage *image = [UIImage ldCPWebView_imageNamed:@"LDCPWebViewController.bundle/NavChevron"];
    UIImage *hightLightImage = [UIImage ldCPWebView_imageNamed:@"LDCPWebViewController.bundle/NavChevronGray"];
    NSString *title = @"";
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithImage:image highlightImage:hightLightImage title:title target:self action:@selector(closeButtonPressed:)];

    return leftBarItem;
}
/** 去掉iOS7.0之下的代码逻辑。（返回和关闭按钮的逻辑需要重新整理了） */
- (UIBarButtonItem *)leftArrowButtonWithBackWeb
{
    UIImage *image = [UIImage ldCPWebView_imageNamed:@"LDCPWebViewController.bundle/NavChevron"];
    UIImage *hightLightImage = [UIImage ldCPWebView_imageNamed:@"LDCPWebViewController.bundle/NavChevronGray"];
    NSString *title = @"";
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:image highlightImage:hightLightImage title:title target:self action:@selector(backWebview:)];
    
    return leftBarItem;
}

- (UIBarButtonItem *)leftCloseButton
{
    return [[UIBarButtonItem alloc] initWithTitle:@"关闭" target:self action:@selector(closeButtonPressed:)];
}

- (void)createActityIndicatorViewInPop
{
    [self removeActityIndicatorViewInPop];
    _indicatorViewInPop = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorViewInPop.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
    _indicatorViewInPop.hidesWhenStopped = YES;
    [self.view addSubview:_indicatorViewInPop];
    [_indicatorViewInPop startAnimating];
}

- (void)removeActityIndicatorViewInPop
{
    if (_indicatorViewInPop) {
        [_indicatorViewInPop stopAnimating];
        [_indicatorViewInPop removeFromSuperview];
        _indicatorViewInPop = nil;
    }
}


#pragma mark - Public Methods

- (void)loadMainBundleFile:(NSString *)filename
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    [self loadLocalFile:filePath];
}

- (void)loadLocalFile:(NSString *)filepath
{
    if (filepath == nil) {
        return;
    }
    [self loadURL:[NSURL fileURLWithPath:filepath]];
}

- (void)loadURLFromString:(NSString *)urlString
{
    if (urlString.length == 0) {
        return;
    }
    [self loadURL:[NSURL URLWithString:urlString]];
}

- (void)loadURL:(NSURL *)url
{
    if (self.isViewLoaded) { //如果view已经被load, 直接打开url, 并清除url缓存. 否则缓存url, 待viewDidLoad最后调用
        NSURLRequest *res = [NSURLRequest requestWithURL:url];
        [self.webview loadRequest:res];
        if (self.cachedURL) {
            self.cachedURL = nil;
        }
        self.originUrlString = [url absoluteString];
    } else {
        self.cachedURL = url;
    }
}

- (UINavigationController *)parentNavController
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];
    return navController;
}

- (NSString *)runJavaScriptString:(NSString *)script
{
    return [self.webview stringByEvaluatingJavaScriptFromString:script];
}

- (void)setBusinessValue:(id)value forKey:(NSString *)key
{
    [self.businessDict setValue:value forKey:key];
}

- (id)businessValueForKey:(NSString *)key
{
    return self.businessDict[key];
}

- (void)close
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPopWebViewControllerWillClose object:nil];
    
    if ([self ld_isModalStyle]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Actions

- (void)backButtonPressed:(id)sender
{
    [self.webview goBack];
}

- (void)forwardButtonPressed:(id)sender
{
    [self.webview goForward];
}

- (void)refreshButtonPressed:(id)sender
{
    [self.webview reload];
}

- (void)openButtonPressed:(id)sender
{
    UIActionSheet *acSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"使用Safari打开" otherButtonTitles:nil];
    [acSheet showInView:self.view];
}

#pragma mark Notification

- (void)handleAppDidEnterBackgroundNotification:(NSNotification *)notification
{
    [self onWebViewHidden];
}

- (void)handleAppWillEnterForegroundNotification:(NSNotification *)notification
{
    [self onWebViewShow];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"openurl:%@", request.URL.absoluteString);
    
    if (hook && [hook respondsToSelector:@selector(webController:shouldStartLoadWithRequest:navigationType:)]) {
        // 交由外部逻辑处理业务，若返回NO则直接返回，若返回YES则继续判断
        if (![hook webController:self shouldStartLoadWithRequest:request navigationType:navigationType]) {
            return NO;
        }
    }
    
    //展示加载中转转提示 圈圈的位置需要调节，在baseViewController或重写一个
    //modify by 张延晋  如果url中去掉#号和当前的url相同，为锚点定位，页面只会在本页内跳转，不会刷新，所以不弹出转框
    NSString *curAbsoluteString = self.webview.request.URL.absoluteString;
    NSString *purAbsoluteString = request.URL.absoluteString;
    NSRange curRange = [curAbsoluteString rangeOfString:@"#"];
    NSRange purRange = [purAbsoluteString rangeOfString:@"#"];
    NSString *curString = [curAbsoluteString substringToIndex:curRange.length ? curRange.location :  curAbsoluteString.length];
    NSString *purString = [purAbsoluteString substringToIndex:purRange.length ? purRange.location :  purAbsoluteString.length];
    
    if (![curString isEqualToString:purString]) {
        [self createActityIndicatorViewInPop];
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.currentUrlString = [webView.request.URL absoluteString];
    
    if (self.webview.canGoBack) {
        self.backItem.enabled = YES;
    } else {
        self.backItem.enabled = NO;
    }
    
    if (self.webview.canGoForward) {
        self.forwardItem.enabled = YES;
    } else {
        self.forwardItem.enabled = NO;
    }
    
    //移除加载中转转提示
    [self removeActityIndicatorViewInPop];
    
    self.customGoBackAction = nil;
    self.customCloseAction = nil;
    
    if ((self.navigationItem.leftBarButtonItems.count == 2 && ((UIBarButtonItem *)[self.navigationItem.leftBarButtonItems objectAtIndex:0]).width == -18) && self.webview.canGoBack) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -18;
        [tmpArray addObject:negativeSpacer];
        [tmpArray addObject:[self leftArrowButtonWithBackWeb]];
        [tmpArray addObject:[self leftCloseButton]];
        [self.navigationItem setLeftBarButtonItems:tmpArray];
    } else if (self.navigationItem.leftBarButtonItems.count == 1 && self.webview.canGoBack) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        [tmpArray addObject:[self leftArrowButtonWithBackWeb]];
        [tmpArray addObject:[self leftCloseButton]];
        [self.navigationItem setLeftBarButtonItems:tmpArray];
    }
    
   [self.jsBridge webReady];
    
    if (self.clearBarButtonWhenLoadUrl) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (hook && [hook respondsToSelector:@selector(webControllerDidFinishLoad:)]) {
        [hook webControllerDidFinishLoad:self];
    }
    [self.jsBridge jsEval:@"alert(\"My First JavaScript\");"];
    //NSURL *url =  [NSURL URLWithString:@"jsonrpc://rpccall/hello?"];
    [self.jsBridge jsEval:@";CPJsApi.helloTest.hello();"];
    //[self loadURL:url];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //移除加载中转转提示
    [self removeActityIndicatorViewInPop];
    
    if (hook && [hook respondsToSelector:@selector(webController:didFailLoadWithError:)]) {
        [hook webController:self didFailLoadWithError:error];
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [LDCPWebViewUtil openURL:[self.webview.request URL]];
    }
}


#pragma mark - WebViewJsonRPCProtocol
- (BOOL)isDebugMode
{
    return NO;
}

- (WebViewJsonRPCPermission)getPermission
{
    //权限，默认给WebViewJsonRPCPermissionTrustedPay
    //目前的检测app安装接口和openurl接口权限都为0
    return WebViewJsonRPCPermissionTrustedPay;
}

#pragma mark - LDWebViewProgressDelegate
- (void)webViewProgress:(LDWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

@end
