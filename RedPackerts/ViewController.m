//
//  ViewController.m
//  RedPackerts
//
//  Created by DT on 2018/2/2.
//  Copyright © 2018年 dt. All rights reserved.
//

#import "ViewController.h"
#import "RedPackertView.h"
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@property (nonatomic,strong)RedPackertView *touchView;
@end

@implementation ViewController
{
    UIButton *btn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   btn = [[UIButton alloc]initWithFrame:CGRectMake(100,100, 300, 50)];
    [btn setTitle:@"点击倒计时5秒下红包雨" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)startTime
{
    __block int timeout = 5;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if ( timeout <= 0 )
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setTitle:@"" forState:UIControlStateNormal];//可以去掉
                [self touchRedView];
            });
        }
        else
        {
            NSString * titleStr = [NSString stringWithFormat:@"%d",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
            [btn setTitle:titleStr forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)touchRedView
{
    RedPackertView *bgView = [[RedPackertView alloc]initWithFrame:CGRectMake(0, 0, 414, SCREEN_HEIGHT)];
    [self.view addSubview:bgView];
    self.touchView = bgView;
    bgView.ButtonClick = ^(NSInteger num) {
        NSLog(@"点击的第%ld个",num);
    };
    
    [bgView startRedPackerts];
}
@end
