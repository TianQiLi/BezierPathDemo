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
/** <#name#> */
@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) UIButton * btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self bezierPathMask];
    
    [self customLayerTrangle];
    [self layerImage];
    [self testForAnimationProperty];
    
    [self testForBoundAndFrame];
    
}

- (void)testForBoundAndFrame{
    
    UIView * view = [[UIView alloc] initWithFrame: CGRectMake(50, 50, 100, 100)];
    [view setBackgroundColor:[UIColor redColor]];
    /** 表示左上角的坐标(50，50),那么意味着view 的内部坐标系的坐标原点向左上角发生了移动 */
    view.bounds = CGRectMake(50, 50, 100, 100);
    [self.view addSubview:view];
    
    UIView * subView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 30, 30)];
    [subView setBackgroundColor:[UIColor yellowColor]];
    [view addSubview:subView];
    
    
    
    
}


- (void)testForAnimationProperty{
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setFrame:CGRectMake(100, 100, 30, 30)];
    [_btn setBackgroundColor:[UIColor redColor]];
    [_btn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
}

- (void)clickEvent:(id)sender{
//    _maskView.layer.position = CGPointMake(_maskView.center.x+ 30, _maskView.center.y+ 30);
//    return;
    [UIView animateWithDuration:1 animations:^{
        self.maskView.bounds = CGRectMake(0,0,self.maskView.bounds.size.width + 30,self.maskView.bounds.size.height + 30);
//     _maskView.layer.position = CGPointMake(_maskView.center.x+ 30, _maskView.center.y+ 30);
//        _maskView.center = CGPointMake(_maskView.center.x+ 30, _maskView.center.y+ 30);
    }];
    
    
}

//镂空效果
- (void)bezierPathMask{
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, self.view.bounds.size.height-20)];
    _maskView.backgroundColor = [UIColor redColor];
    _maskView.alpha = 0.5;
    [self.view addSubview:_maskView];
    
    //maskView的圆角矩形路径
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 10, _maskView.bounds.size.width-20, _maskView.bounds.size.height-20) cornerRadius:15];
    
    //path 的去除的原型路径
    UIBezierPath * pathMask = [UIBezierPath bezierPathWithArcCenter:_maskView.center radius:100 startAngle:0 endAngle:2*M_PI clockwise:NO];
    [path appendPath:pathMask];
    
    CAShapeLayer * shapeLayer = [CAShapeLayer new];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor greenColor].CGColor;//无用
    //mask表示蒙版
    _maskView.layer.mask = shapeLayer;
    //可以看看下面代码的效果
//    [maskView.layer addSublayer:shapeLayer];
    
}

//自定义layer-三角形
- (void)customLayerTrangle{
    /**
     * 参考：https://blog.csdn.net/codingmaniac/article/details/41779709 文章不错
     * 在前面几讲中已经提到，每一个UIView内部都默认关联着一个CALayer，我们可用称这个Layer为Root Layer（根层）。所有的非Root Layer，也就是手动创建的CALayer对象，都存在着隐式动画。
     
     * 当对非Root Layer的部分属性进行相应的修改时，默认会自动产生一些动画效果，这些属性称为Animatable Properties(可动画属性)。
     
     * 当UIView需要显示时，它内部的层会准备好一个CGContextRef(图形上下文)，然后调用delegate(这里就是UIView)的drawLayer:inContext:方法，并且传入已经准备好的CGContextRef对象。而UIView在drawLayer:inContext:方法中又会调用自己的drawRect:方法
     
     * 平时在drawRect:中通过UIGraphicsGetCurrentContext()获取的就是由层传入的CGContextRef对象，在drawRect:中完成的所有绘图都会填入层的CGContextRef中，然后被拷贝至屏幕
     
     * position和anchorPoint属性都是CGPoint类型的
     * position可以用来设置CALayer在父层中的位置，它是以父层的左上角为坐标原点(0, 0)
     * anchorPoint称为"定位点"，它决定着CALayer身上的哪个点会在position属性所指的位置。它的x、y取值范围都是0~1，默认值为(0.5, 0.5)
    
     */
    
    
    CustomLayer * layer = [CustomLayer new];
 
    layer.bounds = CGRectMake(0, 0, 400, 400);
    layer.position = CGPointMake(300, 300);
    //必须调用，否则drawInContext不执行;
    //需要调用setNeedsDisplay这个方法，才会通知delegate进行绘图
    [layer setNeedsDisplay];
   
    [self.view.layer addSublayer:layer];
    //Animatable 可动画属性：自带隐式动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.position = CGPointMake(300, 400);
    });
}

- (void)layerImage{
    //layer 可以直接绘制图片
    CustomLayer * layer = [CustomLayer new];
    layer.bounds = CGRectMake(0, 0, 200, 200);
    layer.position = CGPointMake(350, 500);
    layer.contents = (id)[UIImage imageNamed:@"testImage"].CGImage;
//    [layer setNeedsDisplay];
    [self.view.layer addSublayer:layer];
}

@end
