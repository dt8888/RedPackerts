//
//  RedPackertView.m
//  RedPackerts
//
//  Created by DT on 2018/2/2.
//  Copyright © 2018年 dt. All rights reserved.
//

#import "RedPackertView.h"

@implementation RedPackertView
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self==[super initWithFrame:frame])
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickRed:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)startRedPackerts
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1/4.0) target:self selector:@selector(showRain) userInfo:nil repeats:YES];
}

//开始红包雨
- (void)showRain
{
    UIImageView * imageV = [UIImageView new];
    imageV.image = [UIImage imageNamed:@"red"];
    imageV.frame = CGRectMake(0, 0, 32 , 32 );
    
    self.moveLayer = [CALayer new];
    self.moveLayer.bounds = imageV.frame;
    self.moveLayer.anchorPoint = CGPointMake(0, 0);
    self.moveLayer.position = CGPointMake(0, -32 );
    self.moveLayer.contents = (id)imageV.image.CGImage;
    [self.layer addSublayer:self.moveLayer];
    
    [self addAnimation];
}
- (void)addAnimation
{
    CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue * A = [NSValue valueWithCGPoint:CGPointMake(arc4random() % 414, 0)];
    NSValue * B = [NSValue valueWithCGPoint:CGPointMake(arc4random() % 414, SCREEN_HEIGHT)];
    moveAnimation.values = @[A,B];
    moveAnimation.duration = arc4random() % 200 / 100.0 + 3.5;
    moveAnimation.repeatCount = 1;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.moveLayer addAnimation:moveAnimation forKey:nil];
    
    CAKeyframeAnimation * tranAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D r0 = CATransform3DMakeRotation(M_PI/180 * (arc4random() % 360 ) , 0, 0, -1);
    CATransform3D r1 = CATransform3DMakeRotation(M_PI/180 * (arc4random() % 360 ) , 0, 0, -1);
    tranAnimation.values = @[[NSValue valueWithCATransform3D:r0],[NSValue valueWithCATransform3D:r1]];
    tranAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    tranAnimation.duration = arc4random() % 200 / 100.0 + 3.5;
    //为了避免旋转动画完成后再次回到初始状态。
    [tranAnimation setFillMode:kCAFillModeForwards];
    [tranAnimation setRemovedOnCompletion:NO];
    [self.moveLayer addAnimation:tranAnimation forKey:nil];
}
//点击哪一个红包
- (void)clickRed:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
    for (int i = 0 ; i < self.layer.sublayers.count ; i ++)
    {
        CALayer * layer = self.layer.sublayers[i];
        if ([[layer presentationLayer] hitTest:point] != nil)
        {
            NSLog(@"%d",i);
            //点击的第几个
//            if (self.ButtonClick) {
//                self.ButtonClick(i);
//            }
            BOOL hasRedPacketd = !(i % 3) ;
            UIImageView * newPacketIV = [UIImageView new];
            if (hasRedPacketd)
            {
                newPacketIV.image = [UIImage imageNamed:@"rp_yes"];
                newPacketIV.frame = CGRectMake(0, 0, 32, 74);
            }
            else
            {
                newPacketIV.image = [UIImage imageNamed:@"rp_no"];
                newPacketIV.frame = CGRectMake(0, 0, 32, 76.5);
            }
            layer.contents = (id)newPacketIV.image.CGImage;
            UIView * alertView = [UIView new];
            alertView.layer.cornerRadius = 5;
            alertView.frame = CGRectMake(point.x - 50, point.y, 100, 30);
            [self addSubview:alertView];
            
            UILabel * label = [UILabel new];
            label.font = [UIFont systemFontOfSize:24 weight:1];
            if (!hasRedPacketd)
            {
                label.text = @"旺旺年！人旺旺";
                label.textColor = [UIColor greenColor];
            }
            else
            {
                NSString * string = [NSString stringWithFormat:@"+%d金币",i];
                NSString * iString = [NSString stringWithFormat:@"%d",i];
                NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
                
                [attributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont systemFontOfSize:27]
                                      range:NSMakeRange(0, 1)];
                [attributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont fontWithName:@"PingFangTC-Semibold" size:32]
                                      range:NSMakeRange(1, iString.length)];
                [attributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont systemFontOfSize:17]
                                      range:NSMakeRange(1 + iString.length, 2)];
                label.attributedText = attributedStr;
                label.textColor =[UIColor redColor];
            }
            
            [alertView addSubview:label];
            label.frame  = CGRectMake(point.x - 50, point.y, 100, 50);
            label.center = alertView.center;
            [UIView animateWithDuration:1 animations:^{
                alertView.alpha = 0;
                alertView.frame = CGRectMake(point.x- 50, point.y - 100, 100, 30);
            } completion:^(BOOL finished) {
                [alertView removeFromSuperview];
            }];
        }
    }
}
//关闭动画
- (void)endAnimation
{
    [self.timer invalidate];
    for (NSInteger i = 0; i < self.layer.sublayers.count ; i ++)
    {
        CALayer * layer = self.layer.sublayers[i];
        [layer removeAllAnimations];
    }
}
@end
