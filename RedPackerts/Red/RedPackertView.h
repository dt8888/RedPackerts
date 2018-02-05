//
//  RedPackertView.h
//  RedPackerts
//
//  Created by DT on 2018/2/2.
//  Copyright © 2018年 dt. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface RedPackertView : UIView
@property(nonatomic,copy)void (^ButtonClick)(NSInteger);
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)CALayer *moveLayer;
-(void)startRedPackerts;
- (void)endAnimation;

@end
