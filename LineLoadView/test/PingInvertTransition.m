//
//  PingInvertTransition.m
//  KYPingTransition
//
//  Created by Kitten Yang on 1/30/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "PingInvertTransition.h"
#import "SecondViewController.h"
#import "FirstViewController.h"

@interface PingInvertTransition()

@property(nonatomic,strong)id<UIViewControllerContextTransitioning>transitionContext;

@end

@implementation PingInvertTransition


//“TIPS: 这个协议方法返回动画的执行时间。通常把我们把动画时间设计成一个外部接口，因此只要返回这个属性就可以了。”
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.7f;
}

//“TIPS: 一切的核心。所有 CoreAnimation 的代码就是写在这里了。”
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    /*
     “TIPS:  transitionContext 是动画执行过程中的上下文。通过 UIViewControllerContextTransitioning 你可以拿到执行动画的容器 containerView 。
     所有动画必须发生在这个容器上。除了可以拿到 containerView ，你还可以获取：
     UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
      
     UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];”
     */
    
    self.transitionContext = transitionContext;
    
    SecondViewController *fromVC = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    FirstViewController *toVC   = (FirstViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIButton *button = toVC.button;
    
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];

    
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:button.frame];
    
    /*
     “TIPS: 创建两个圆形的 UIBezierPath 实例；
     一个是初始位置的最小内接圈。
     另一个是拥有足够覆盖屏幕半径的外接圆。
     最终的动画则是在这两个贝塞尔路径之间进行的。
      
     通过确定初始点所在的象限位置，从而确定终点位置，从而计算出半径 —— 也就是最小能覆盖整个界面的圆。”
     */
    CGPoint finalPoint;
    
    //判断触发点在那个象限
    if(button.frame.origin.x > (toVC.view.bounds.size.width / 2)){
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第一象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第四象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - 0);
        }
    }else{
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第二象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第三象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - 0);
        }
    }

    

    CGFloat radius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y);
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue = (__bridge id)(startPath.CGPath);
    pingAnimation.toValue   = (__bridge id)(finalPath.CGPath);
    pingAnimation.duration = [self transitionDuration:transitionContext];
    pingAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    pingAnimation.delegate = self;
    
    [maskLayer addAnimation:pingAnimation forKey:@"pingInvert"];
    
}

//“TIPS: 最后通知上下文动画已完成。”
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;

}


@end





