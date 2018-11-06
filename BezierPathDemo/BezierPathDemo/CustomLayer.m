//
//  CustomLayer.m
//  BezierPathDemo
//
//  Created by litianqi on 2018/11/6.
//  Copyright © 2018 tqUDown. All rights reserved.
//

#import "CustomLayer.h"

@implementation CustomLayer
- (void)drawInContext:(CGContextRef)ctx{
    // 设置为蓝色
    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
    // 设置起点
    CGContextMoveToPoint(ctx, 50, 0);
    // 从(50, 0)连线到(0, 100)
    CGContextAddLineToPoint(ctx, 0, 100);
    // 从(0, 100)连线到(100, 100)
    CGContextAddLineToPoint(ctx, 100, 100);
    // 合并路径，连接起点和终点
    CGContextClosePath(ctx);
    // 绘制路径
    CGContextFillPath(ctx);
    
}

@end
