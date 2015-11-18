//
//  SecondViewController.m
//  test
//
//  Created by 三开（北京） on 15/11/17.
//  Copyright © 2015年 北京三开科技股份有限公司. All rights reserved.
//

#import "SecondViewController.h"
#import "FirstViewController.h"
#import "PingInvertTransition.h"
@interface SecondViewController () <UINavigationControllerDelegate>{
    
    //设置并更新一个 iOS 7 新加入的类的对象。 UIPercentDrivenInteractiveTransition。
    //这个类的对象会根据我们的手势，来决定我们的自定义过渡的完成度
    UIPercentDrivenInteractiveTransition *percentTransition;
}

@end

@implementation SecondViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"page2"]];
    image.frame = [UIScreen mainScreen].bounds;
    image.userInteractionEnabled = YES;
    [self.view addSubview:image];
    
    //设置action, 并设置改变的方法,因为我们是想从第二个页面回到第一个页面,所以设置 UIRectEdgeLeft
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
    
    
    _button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_button addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_button setTitle:@"" forState:(UIControlStateNormal)];
    _button.frame = image.frame;
    [image addSubview:_button];
}
-(void)buttonAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    // 返回我们的自定义过渡
    return percentTransition;
}
-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    // 计算用户手指划了多远
    CGFloat per = [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    per = MIN(1.0,(MAX(0.0, per)));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // 创建过渡对象，弹出viewController
        percentTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        // 更新 interactive transition 的进度
        [percentTransition updateInteractiveTransition:per];
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        // 完成或者取消过渡
        if (per > 0.3) {
            [percentTransition finishInteractiveTransition];
        }else{
            [percentTransition cancelInteractiveTransition];
        }
        percentTransition = nil;
    }
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        PingInvertTransition *pingInvert = [PingInvertTransition new];
        return pingInvert;
    }else{
        return nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
