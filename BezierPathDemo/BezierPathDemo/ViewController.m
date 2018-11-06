//
//  ViewController.m
//  BezierPathDemo
//
//  Created by litianqi on 2018/11/6.
//  Copyright © 2018 tqUDown. All rights reserved.
//

#import "ViewController.h"
#import "CustomLayer.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self bezierPathMask];
    
    [self customLayer];
}

//镂空效果
- (void)bezierPathMask{
    UIView * maskView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, self.view.bounds.size.height-20)];
    maskView.backgroundColor = [UIColor redColor];
    maskView.alpha = 0.5;
    [self.view addSubview:maskView];
    
    //maskView的圆角矩形路径
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 10, maskView.bounds.size.width-20, maskView.bounds.size.height-20) cornerRadius:15];
    
    //path 的去除的原型路径
    UIBezierPath * pathMask = [UIBezierPath bezierPathWithArcCenter:maskView.center radius:100 startAngle:0 endAngle:2*M_PI clockwise:NO];
    [path appendPath:pathMask];
    
    CAShapeLayer * shapeLayer = [CAShapeLayer new];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor greenColor].CGColor;//无用
    //mask表示蒙版
    maskView.layer.mask = shapeLayer;
    //可以看看下面代码的效果
//    [maskView.layer addSublayer:shapeLayer];
    
}

//自定义layer-三角形
- (void)customLayer{
    CustomLayer * layer = [CustomLayer new];
    layer.bounds = CGRectMake(0, 0, 400, 400);
    layer.position = CGPointMake(300, 300);
    //必须调用，否则drawInContext不执行
    [layer setNeedsDisplay];
    [self.view.layer addSublayer:layer];
    //Animatable 可动画属性：自带隐式动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.position = CGPointMake(300, 400);
    });
}

@end
