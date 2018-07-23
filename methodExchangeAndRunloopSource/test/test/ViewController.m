//
//  ViewController.m
//  test
//
//  Created by shen chen on 2017/9/20.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "ViewController.h"
#import "GLMyView.h"
#import "Masonry.h"
#import <PopWebViewController.h>
#import <KMCGeigerCounter.h>
#import <UIColor+LDAddition.h>
#import <NSDate+LDAddition.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSTimer *timer1;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UITableView *showInfoTableView;
@property (nonatomic, strong) NSTimer *timer2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [KMCGeigerCounter sharedGeigerCounter].enabled = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"pic.jpg"] forBarMetrics:UIBarMetricsDefault];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 100, 100)];
    [self.view addSubview:self.view1];
    self.view1.backgroundColor = [UIColor redColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, 40, 40)];
    [self.view addSubview:button];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:self.showInfoTableView];
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    animation.removedOnCompletion = NO;
//    animation.fromValue = @1.0;
//    animation.toValue = @0.0;
//    animation.duration = 1.0;
//    animation.repeatCount = MAXFLOAT;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [self.view1.layer addAnimation:animation forKey:@"animation"];
    
//    NSLog(@"1");//
//
//    dispatch_async(dispatch_get_global_queue(0,0),^{
//        NSLog(@"%@",[NSThread currentThread]);
//        NSLog(@"2");//
//
//        dispatch_sync(dispatch_get_main_queue(),^{
//            NSLog(@"%@",[NSThread currentThread]);
//            NSLog(@"3");//
//
//        });
//
//        NSLog(@"4");//
//
//    });
//
//    NSLog(@"5");//
    
//    dispatch_queue_t queue=dispatch_queue_create("com.demo.serialQueue",DISPATCH_QUEUE_SERIAL);
//    dispatch_sync(queue,^{
//        NSLog(@"%@",[NSThread currentThread]);//1
//        NSLog(@"2");//
//    });
//
//    dispatch_async(queue,^{
//        NSLog(@"%@",[NSThread currentThread]);//3
//        NSLog(@"3");//
//
//    });
//
//    dispatch_async(queue,^{
//        NSLog(@"%@",[NSThread currentThread]);//3
//        NSLog(@"4");//
//
//    });
    
    
//    dispatch_queue_t queue=dispatch_queue_create("com.demo.serialQueue",DISPATCH_QUEUE_SERIAL);
//
//    NSLog(@"1");//
//
//    dispatch_async(queue,^{
//        NSLog(@"2");//
//        NSLog(@"%@",[NSThread currentThread]);
//    });
//
//    dispatch_async(queue,^{
//        NSLog(@"3");//
//        NSLog(@"%@",[NSThread currentThread]);
//    });
//    dispatch_queue_t queue=dispatch_queue_create("com.demo.serialQueue",DISPATCH_QUEUE_SERIAL);
//
//    NSLog(@"1");//
//
//    dispatch_async(queue,^{
//        NSLog(@"%@--a",[NSThread currentThread]);
//
//        dispatch_queue_t queueh=dispatch_queue_create("com.demoo.serialQueueh",DISPATCH_QUEUE_SERIAL);
//
//        dispatch_async(queueh,^{
//            NSLog(@"%@--b",[NSThread currentThread]);
////            dispatch_sync(queue,^{
////                NSLog(@"%@--2",[NSThread currentThread]);//1
////                NSLog(@"6");//
////            });
//            dispatch_async(queue, ^{
//                NSLog(@"%@--c",[NSThread currentThread]);//1
//            });
//
//            //NSLog(@"%@--d",[NSThread currentThread]);
//        });
////        NSLog(@"%@--g",[NSThread currentThread]);
////        dispatch_async(queue, ^{
////            NSLog(@"%@---d",[NSThread currentThread]);//1
////            dispatch_async(queue, ^{
////                NSLog(@"%@----e",[NSThread currentThread]);//1
////            });
////        });
//
//    });
//
//    dispatch_async(queue,^{
//        NSLog(@"%@--f",[NSThread currentThread]);
//    });
    
//    NSLog(@"1");//
//    dispatch_queue_t queue=dispatch_queue_create("com.demo.serialQueue",DISPATCH_QUEUE_SERIAL);
//    dispatch_sync(queue,^{
//
//        NSLog(@"2");//
//
//    });
//
//    NSLog(@"3");//
    
    
//    dispatch_queue_t queuee = dispatch_queue_create("com.demoo.serialQueueh",DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queuee,^{
//        NSLog(@"1");//
//        dispatch_sync(queuee,^{
//
//            NSLog(@"2");//
//
//        });
//        NSLog(@"3");
//    });
   
    
//    dispatch_async(queue,^{
//        NSLog(@"3");//
//    });
    
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timer1Respond) userInfo:nil repeats:YES];
    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timer2Respond) userInfo:nil repeats:YES];
    NSLog(@"%@",CFRunLoopGetMain());
}

- (void)timer1Respond {
    NSInteger count = 0;
    for (NSInteger i = 0;i < 1000000000;i++) {
        count = count + i;
       // NSLog(@"%@",[NSThread currentThread]);
    }
    NSLog(@"----------------%@",self.timer1.fireDate);
    //NSLog(@"%@",[NSDate date]);
    
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)onClick:(id)sender {
    ((UIView *)sender).backgroundColor = [UIColor greenColor];
    NSLog(@"hello");
    NSInteger count = 0;
    for (NSInteger i = 0;i < 1000000000;i++) {
        count = count + i;
    }
}

- (void)timer2Respond {
    //self.view.backgroundColor = [UIColor redColor];
    //NSLog(@"timer2%@",[self.timer2 fireDate]);
    NSInteger count = 0;
    for (NSInteger i = 0;i < 1000000000;i++) {
        count = count + i;
    }
    NSLog(@"----------------timer2 %@",self.timer1.fireDate);
}

-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidAppear:(BOOL)animated
{
     NSLog(@"%@",[self roundFloat:23.6250001]);
}

-(NSDecimalNumber *)roundFloat:(double)price{
    NSString *temp = [NSString stringWithFormat:@"%.7f",price];
    NSDecimalNumber *numResult = [NSDecimalNumber decimalNumberWithString:temp];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       scale:2
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    return [numResult decimalNumberByRoundingAccordingToBehavior:roundUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor ld_colorWithHex:0xF9F9F9];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}


- (UITableView *)showInfoTableView {
    if (_showInfoTableView == nil) {
        _showInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 210, 375, 450) style:UITableViewStylePlain];
        _showInfoTableView.rowHeight = UITableViewAutomaticDimension;
        //_showInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showInfoTableView.backgroundColor = [UIColor whiteColor];
        _showInfoTableView.estimatedRowHeight = 30;
        _showInfoTableView.delegate = self;
        _showInfoTableView.dataSource = self;
    }
    return _showInfoTableView;
}

@end
